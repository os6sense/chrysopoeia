
# ============= TEXT FUNCTIONS =================

defmodule Chrysopoeia.Parser.Transform.Text do

  alias Chrysopoeia.Selector.CSS, as: CSS

  # ================= HELPERS
  def prep_css(css) do
    css
      |> to_string
      |> String.replace(" ", "_") 
      |> String.replace("[", "_") 
      |> String.replace("]", "_") 
      |> String.replace(".", "@") 
      |> String.replace("=", "_") 
      |> String.replace("#", "_") 
  end

  def fnc_name_atom(op, id, sel \\ nil) do
    attr_id = id 
      |> Atom.to_string

    (op |> Atom.to_string) <> "_" <> attr_id <> prep_css(sel) |> String.to_atom
  end

  defmacro create_selector(:select, sel) when is_list(sel) do
    sel = List.first(sel)
    quote do CSS.create(unquote(sel)) end
  end

  defmacro create_selector(:select, sel) do
    quote do CSS.create(unquote(sel)) end
  end

  defmacro create_selector(id, nil) do
    quote do CSS.create("##{unquote(id)|> Atom.to_string}") end
  end

  # Generic macro to dry up the various text alteration macros. Creates
  # a CSS selector to match any element with the id matching id and when 
  # matched the transform function provided by the body is applied to the
  # c element of the parsetrees {e, a, [c]} tupple, which *should* contain
  # just text. If it doesn't ... what happens? Deletion or failure?

  # id: id of the css element or a css selector string
  # op: the function to perform, used only in creation to uniquely 
  #     identify the transform function for runtime creation
  # text: will be replaced in the body of the calling function with the
  #       value of the text matched within the element tuple
  defmacro alter_text(id, op, text, sel \\ nil, do: body) do
    fnc_name = fnc_name_atom(op, id, sel) 

    quote do
      def unquote(fnc_name)(model) do
        var!(model) = model # make model available to contexts using the
                            # xxxxx_text/2 macro form.

        selector = create_selector(unquote(id), unquote(sel) )

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
      @fns @fns ++ [ unquote(fnc_name) ]
    end
  end

  # =========== PREPEND
  #============================================================================
  # puts the contents of body (which should evaluate to a string)
  # at the start of the html element with the id which matches the
  defmacro prepend_text({id, _, params}, do: body) do
    quote do
      alter_text(unquote(id), :prepend_2, text, unquote(params)) do
        unquote(body) <> List.first(text)
      end
    end
  end

  # supports use of the prepend text in the form 
  #   prepend_text id(:model_atom)
  defmacro prepend_text({id, _, params}) do
    if id == :select, 
      do: [ selector | params ] = params

    quote do
      alter_text(unquote(id), :prepend_1, text, unquote(selector) ) do
        model = var!(model) # Make the model available within this context
        Enum.map(unquote(params), fn
          (param) -> model[param] <> List.first(text)
        end) |> Enum.join("")
      end
    end
  end

  #========= APPEND
  # puts the contents of body (which should evaluate to a string)
  # at the start of the html element with the id which matches the
  defmacro append_text({id, _, params}, do: body) do
    quote do
      alter_text(unquote(id), :append_2, text, unquote(params)) do
        List.first(text) <> unquote(body) 
      end
    end
  end

  # supports use of the prepend text in the form 
  #   prepend_text id(:model_atom)
  defmacro append_text({id, _, params}) do
    if id == :select, 
      do: [ selector | params ] = params

    quote do
      alter_text(unquote(id), :append_1, text, unquote(selector) ) do
        model = var!(model) # Make the model available within this context
        Enum.map(unquote(params), fn
          (param) -> List.first(text) <> model[param] 
        end) |> Enum.join("")
      end
    end
  end

  # ==== REPLACE
  # puts the contents of body (which should evaluate to a string)
  # at the start of the html element with the id which matches the
  defmacro replace_text({id, _, params}, do: body) do
    quote do
      alter_text(unquote(id), :append_2, text, unquote(params)) do
        unquote(body) 
      end
    end
  end

  # supports use of the prepend text in the form 
  #   prepend_text id(:model_atom)
  defmacro replace_text({id, _, params}) do
    if id == :select, 
      do: [ selector | params ] = params

    quote do
      alter_text(unquote(id), :append_1, text, unquote(selector) ) do
        model = var!(model) # Make the model available within this context
        Enum.map(unquote(params), fn
          (param) -> model[param] 
        end) |> Enum.join("")
      end
    end
  end

end
