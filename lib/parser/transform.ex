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


  # ============= TEXT FUNCTIONS =================
  # Generic macro to dry up the various text alteration macros
  # id: id of the css element 
  # op: the function to perform, used only in creation to uniquely 
  #     identify the transform function for runtime creation
  # text: will be replaced in the body of the calling function with the
  #       value of the text matched within the element tuple
  defmacro alter_text(id, op, text, do: body) do
    attr_id = id |> Atom.to_string
    quote do
      def unquote(String.to_atom("#{Atom.to_string(op)}_" <> attr_id))(model) do
        var!(model) = model
        selector = CSS.create("##{unquote(attr_id)}")

        {:transform, fn
          (t = {e, a, unquote(text)}, meta, acc) -> 
            if CSS.match(e, a, meta, selector), 
              do: t = {e, a, [unquote(body)]}

            if is_tuple(acc), 
              do: acc = acc |> elem(1)

            {t, acc }
          end}
        end
        
      @fns @fns ++ [ String.to_atom("#{Atom.to_string(unquote(op))}_" <> unquote(attr_id)) ]
    end
  end

  defmacro prepend_text({id, _, _}, do: body) do
    quote do
      alter_text(unquote(id), :prepend, text) do
        unquote(body) <> List.first(text)
      end
    end
  end

  defmacro append_text({id, _, _}, do: body) do
    quote do
      alter_text(unquote(id), :append, text) do
        List.first(text) <> unquote(body)
      end
    end
  end

  defmacro replace_text({id, _, _}, do: body) do
    quote do
      alter_text(unquote(id), :append, text) do
        unquote(body)
      end
    end
  end

  # WORKING!!
  #defmacro prepend_text({id, _e_meta, _params}, do: body) do
    #attr_id = id |> Atom.to_string
    #quote do
      #def unquote(String.to_atom("prepend_" <> attr_id))(model) do
        #var!(model) = model

        #selector = CSS.create("##{unquote(attr_id)}")

        #{:transform, fn
          #(t = {e, a, c}, meta, acc) -> 
            #if CSS.match(e, a, meta, selector), 
              #do: t = {e, a, [model[:action_title] <> List.first(c)]}

            #if is_tuple(acc), 
              #do: acc = acc |> elem(1)

            #{t, acc }
          #end}
        #end
        
      #@fns @fns ++ [ String.to_atom("prepend_" <> unquote(attr_id)) ]
    #end
  #end

  
  # ============= ATTRIBUTE FUNCTIONS =================
  defmacro replace_attribute(id, do: body) do
  end
  # ============= NODE FUNCTIONS =================
  # Node based functions
  defmacro replace(id, params, do: body) do
  end
  defmacro insert(id, params, do: body) do
  end
  defmacro append(id, params, do: body) do
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
