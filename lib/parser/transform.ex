defmodule Chrysopoeia.Parser.Transform do
  @moduledoc 
  """
  Methods for transforming the parsetree
  """
  require Chrysopoeia.Parser.ParseTree, as: PT
  require Chrysopoeia.Accumulator, as: Accumulator
  alias Chrysopoeia.Selector.CSS, as: CSS

  def transform(t = {_, _, _}, fns) do
    PT.walk(t, fns)
  end

  #def apply(model, transforms) do
  #end

  defmacro attribute_set(name, val) do
    quote do
      match_args = fn ({an, av}) 
        -> if an == unquote(name), do: {an, unquote(val)}, else: {an, av} 
      end
      fn ({e, a, c}) -> {e, Enum.map(a, match_args), c} end
    end
  end

  @doc ~S"""
    Creates a new transform

    selector, block
  """
  defmacro create(selector, do: blk) do
    quote do
      fn (t = {_, _, _}, acc) 
        -> if CSS.match(t, unquote(selector)), do: unquote(blk).(t), else: t
      end
    end
  end


  def attribute(selector, attribute, new_value) do
    create(selector) do
      attribute_set(attribute, new_value)
    end
  end

  # ========= ABOVE IS PROTOTYPING CODE

  # ============= TEXT FUNCTIONS =================
  defmacro replace_text(id, do: body) do
    quote do
    end
  end

  defmacro prepend_text(id, do: body) do
  end

  defmacro insert_text(id, do: body) do
  end

  defmacro append_text(id, do: body) do
  end

 
  # ============= ATTRIBUTE FUNCTIONS =================
  defmacro replace_attribute(id, do: body) do
    quote do
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

  # I dont want to break the above just yet
  #defmacro create_query(selector, t, acc, do: blk) do
    #quote do
      #{:query, fn 
        #(unquote(t) = t = {e, a, _c}, meta, unquote(acc) = acc)
          #-> if CSS.match(e, a, meta, unquote(selector)), 
               #do: unquote(blk), else: {t, acc}
        #end}
    #end
  #end

  # ==== extract is really just a find
  defmacro extract(id) do
    attr_id = id |> elem(0) |> Atom.to_string
    quote do
      def unquote(String.to_atom("extract_" <> attr_id))(_model) do
        selector = CSS.create("##{unquote(attr_id)}")

        {:query, fn
          (t = {e, a, _c}, meta, acc) -> 
            if CSS.match(e, a, meta, selector),
              do: acc = Accumulator.update_accumulator(acc, t)
            {t, acc}
          end }
      end
        
      @fns @fns ++ [ String.to_atom("extract_" <> unquote(attr_id)) ]
    end
  end

  # ======== DEFTRANSFORM ==================
  defmacro deftransform(name, do: body) do
    quote do
      import  Chrysopoeia.Parser.Transform 
      require Chrysopoeia.Parser.ParseTree, as: PT
      alias   Chrysopoeia.Selector.CSS, as: CSS

      require Logger

      defmodule unquote(name) do
        @fns [] 

        unquote(body)

        def init(source_file \\ @source) do
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


      end # modele end
    end # quote end
  end
end
