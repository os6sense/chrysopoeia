
# ============= TEXT FUNCTIONS =================
defmodule Chrysopoeia.Parser.Transform.Text do

  alias Chrysopoeia.Selector.CSS, as: CSS

  # Generic macro to dry up the various text alteration macros. Creates
  # a CSS selector to match any element with the id matching id and when 
  # matched the transform function provided by the body is applied to the
  # c element of the parsetrees {e, a, [c]} tupple, which *should* contain
  # just text. If it doesn't ... what happens? Deletion or failure?

  # id: id of the css element 
  # op: the function to perform, used only in creation to uniquely 
  #     identify the transform function for runtime creation
  # text: will be replaced in the body of the calling function with the
  #       value of the text matched within the element tuple
  defmacro alter_text(id, op, text, do: body) do
    attr_id = id |> Atom.to_string
    op_name = Atom.to_string(op) <> "_" <> attr_id

    quote do
      def unquote(String.to_atom(op_name))(model) do
        var!(model) = model # make model available to contexts using the
                            # xxxxx_text/2 macro form.

        selector = CSS.create("##{unquote(attr_id)}")

        {:transform, fn
          (t = {e, a, unquote(text)}, meta, acc) -> 
            if CSS.match(e, a, meta, selector), 
              do: t = {e, a, [unquote(body)]}

            if is_tuple(acc), 
              do: acc = acc |> elem(1) # prevent the accumulator being 
                                       # polluted with the parsetree
            {t, acc }
          end}
        end
        
      # Add the functions *name* to the list which will be created when 
      # deftransform#functions is called. This is because we cant pass the
      # function directly into @fns when expanding the macro.
      @fns @fns ++ [ String.to_atom(unquote(op_name)) ]
    end
  end

  # puts the contents of body (which should evaluate to a string)
  # at the start of the html element with the id which matches the
  defmacro prepend_text({id, _, _}, do: body) do
    quote do
      alter_text(unquote(id), :prepend_2, text) do
        unquote(body) <> List.first(text)
      end
    end
  end

  # supports use of the prepend text in the form 
  #   prepend_text id(:model_atom)
  defmacro prepend_text({id, _, params}) do
    quote do
      alter_text(unquote(id), :prepend_1, text) do
        model = var!(model)
        Enum.map(unquote(params), fn
          (param) -> model[param] <> List.first(text)
        end) |> Enum.join("")
      end
    end
  end

  # TODO - test and I need the shortcut model forms.
  defmacro append_text({id, _, _}, do: body) do
    quote do
      alter_text(unquote(id), :append, text) do
        List.first(text) <> unquote(body)
      end
    end
  end

  defmacro replace_text({id, _, _}, do: body) do
    quote do
      alter_text(unquote(id), :replace, text) do
        unquote(body)
      end
    end
  end
end

