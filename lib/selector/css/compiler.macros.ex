
defmodule Chrysopoeia.Selector.CSS.Compiler.Macros do

  # test to check if the element passed to the selector function matches the
  # type within the map
  defmacro element_matches_type?(e, type) do
    quote do
      unquote(e) == unquote(type)
    end
  end


  defmacro has_attribute?(attributes, attribute_name) do
    quote do
      Enum.any?(unquote(attributes), fn 
        ({lattr, lval}) -> lattr == unquote(attribute_name) 
      end)
    end
  end

  defmacro has_attribute_with_value?(attributes, attribute_name, op, value) do
    quote do
      Enum.any?(unquote(attributes), fn 
        ({lattr, lval}) -> lattr == unquote(attribute_name) 
                           && test_with_op(unquote(op), lval, unquote(value))
      end) 
    end
  end

  # Macro to find any preceding siblings before the current element in the meta
  # and perform the equivilent of Enum.any? on the siblings keyword field.
  # Returns a tuple containing the result and the meta data with the sibling
  # path adjusted to only contain the siblings before the element on which a
  # match was made.
  defmacro preceding(el, do: block) do
    quote do
      fn (_e, _a, meta) -> 
        #IO.puts "PREECEDING"
        #IO.puts "#{inspect meta}"
        count = elem(meta[:siblings], 1) 
        siblings = Enum.take(elem(meta[:siblings], 0), count ) 
                    |> Enum.reverse
        
        {result, idx} = Enum.reduce(siblings, {false, 0}, fn 
          (unquote(el), {any?, idx}) when is_binary(unquote(el)) ->  
            if any?, do: {true, idx}, else: {false, idx + 1}
          (unquote(el), {any?, idx}) -> 
            if any?, do: {true, idx}, else: {unquote(block), idx + 1}
        end)

        #siblings = Enum.reverse(siblings)
        #IO.puts "RESULT: #{result} IDX: #{idx}"
        
        { result, Keyword.update(meta, :siblings, {[], 0, 0}, fn 
          ({siblings, current, total}) -> 
            {Enum.take(siblings, count - idx), current, total } 
        end) }
      end
    end
  end

  # Macro to find any *immediately* preceding siblings before the current
  # element in the meta.
  # Returns a tuple containing the result and the meta data with the sibling
  # path adjusted to no longer include the element on which the match was made.
  defmacro ipreceding(e, do: block) do
    quote do
      fn (te, _a, meta) -> 
        siblings = elem(meta[:siblings], 0)
        pos = elem(meta[:siblings], 1) - 1 # -1 since tuples are zero indexed
        count = elem(meta[:siblings], 1) 

        # Might have a bug here - what about when we try a match and TEXT
        # is unquoted into block?
        #if is_binary(List.first(siblings)) do
          ##  IO.puts "ADJUSTING POS"
          ##pos = pos - 1
        #end

        if pos > 0 do
          unquote(e) = Enum.at( elem(meta[:siblings], 0), pos - 1)

          #Logger.debug "CHECKING #{inspect unquote(e) } :: #{inspect Enum.at(elem(meta[:siblings], 0), pos - 1) }"
          #Logger.debug "POS: #{pos} - SIBLINGS #{inspect siblings}"

          result = unquote(block)

          #Logger.debug "RESULT: #{result}"

          { result, adjust_sibling_meta(meta, pos - 1, result) }
        else
          { false, meta }
        end

      end
    end
  end

  # Macro to perform a match against a single element.
  # Returns the result of the match and the unadjusted meta.
  defmacro single(e, a, do: block) do
    quote do
      fn (unquote(e), unquote(a), meta) -> 
        #Logger.debug "SINGLE: #{inspect [:siblings]} SIBLINGS: #{inspect meta[:siblings]}"
        #IO.puts "SINGLE: #{inspect unquote(e)} SIBLINGS: #{inspect meta[:siblings]}"
        {unquote(block), meta}
      end
    end
  end

  # Macro to test if the first element in the path is a match against the 
  # unquoted test.
  # Returns the result and the meta with the first element of the path deleted.
  defmacro child(e, do: block) do
    quote do
      fn (_e, _a, meta) -> 
        unquote(e) = List.first(meta[:path]) 
        {unquote(block), adjust_path_meta(meta, 1, :path)}
      end
    end
  end

  # Macro to test if the unquoted test matches against any parent element in
  # meta[:path].
  # Returns the result and the meta with all the elements upto and including
  # the matching element deleted.
  defmacro descendant(el, do: block) do
    quote do
      fn (e, a, meta) -> 
        {result, idx} = Enum.reduce(meta[:path], {false, 0}, fn 
          (unquote(el), {any?, idx}) -> if any?, do: {true, idx}, else: {unquote(block), idx + 1}
        end)

        {result, adjust_path_meta(meta, idx, :path)}
      end
    end
  end

  @doc """
    The map produced by the css parser has 6 fields of which only four
    will be regularly used. The css_map macro provides a short hand
    for those four elements.
  """
  defmacro css_map(type, attr, op, value) do
    quote do
      %{"type" => unquote(type), "attr" => unquote(attr), "op" => unquote(op), 
        "value" => unquote(value), "ptype" => "", "pval" => "" }
    end
  end

  # TODO: I'm still not happy with this...
  defmacro cssmap_t(type) do
    quote do css_map(unquote(type), "", "", "") end
  end

  defmacro cssmap_a(attr) do
    quote do css_map("", unquote(attr), "", "") end
  end

  defmacro cssmap(attr, op, value) do
    quote do css_map("", unquote(attr), unquote(op), unquote(value)) end
  end

  defmacro cssmap(type, attr) do
    quote do css_map(unquote(type), unquote(attr), "", "") end
  end

  defmacro cssmap(type, attr, op, value) do
    quote do 
      css_map(unquote(type), unquote(attr), unquote(op), unquote(value)) 
    end
  end
end
