defmodule Chrysopoeia.Parser.Transform do
  @moduledoc 
  """
  Methods for transforming the parsetree
  """
  require Chrysopoeia.Parser.ParseTree, as: PT
  require Chrysopoeia.Accumulator, as: Accumulator

  alias Chrysopoeia.Selector.CSS, as: CSS

  defmacro attribute_set(name, val) do
    quote do
      match_args = fn ({an, av}) 
        -> if an == unquote(name), do: {an, unquote(val)}, else: {an, av} 
      end
      fn ({e, a, c}) -> {e, Enum.map(a, match_args), c} end
    end
  end

  # ============= NODE FUNCTIONS =================
  # Node based functions
  defmacro replace(id, params, do: body) do
  end
  defmacro insert(id, params, do: body) do
  end
  defmacro append(id, params, do: body) do
  end
  defmacro delete(id, params, do: body) do
  end

  # ==== extract is really just a find with some hand waving to deal
  # with the effects of other functions on the lacc accumulator.
  defmacro extract({id, _, _}) do
    attr_id = id |> Atom.to_string
    quote do
      def unquote(String.to_atom("extract_" <> attr_id))(_model) do
        selector = CSS.create("##{unquote(attr_id)}")

        {:query, fn
          (t = {e, a, _c}, meta, acc) -> 
            if CSS.match(e, a, meta, selector) do
              if is_tuple(acc), do: {t, acc} = acc
              acc = Accumulator.update_accumulator(acc, t)
            else
              if is_tuple(acc), do: acc = acc |> elem(1)
            end
            {t, acc}
          end}
      end
        
      @fns @fns ++ [ String.to_atom("extract_" <> unquote(attr_id)) ]
    end
  end

  # ======== DEFTRANSFORM ==================
  defmacro deftransform(name, do: body) do
    quote do
      import Chrysopoeia.Parser.Transform 
      import Chrysopoeia.Parser.Transform.Text
      import Chrysopoeia.Parser.Transform.Attribute

      require Chrysopoeia.Parser.ParseTree, as: PT

      alias   Chrysopoeia.Selector.CSS,     as: CSS

      require Logger

      defmodule unquote(name) do
        @fns [] 

        unquote(body)

        def init(source_file \\ @source) do
          unless String.ends_with?(source_file, ".html") do
            source_file = source_file <> ".html"
          end

          Chrysopoeia.Reader.read(source_file) 
            |> Chrysopoeia.Parser.Floki.parse
        end

        # Oh dear, we are going around the houses. It seems we can't add 
        # anonymous functions to the @fns constant hance when calling the 
        # transform we are trying to create the anonymous functions now.
        def functions(model) do
          Enum.map(@fns, fn
            (fn_name) -> apply(__MODULE__, fn_name, [model])  
          end)
        end

        ## another useful macro might be the transform order allowing it to be 
        ## overridden/changed.
        def transform_order do
          [:delete, :transform, :insert, :query]
        end

        def transform(model) do
          ## we need a list of all the transforms added  - they should be
          ## in the body the we just call 
          fncs = functions(model)
          init |> PT.walk(fncs, true) |> parse_tree_or_accumulator
        end

        defp parse_tree_or_accumulator(parse_tree) do
          accumulator = parse_tree 
                          |> elem(1) 
                          |> Keyword.get(:accumulator)

          if length(accumulator) > 0  do
            accumulator
          else
            parse_tree |> elem(0) 
          end
        end
      end 
    end 
  end
end
