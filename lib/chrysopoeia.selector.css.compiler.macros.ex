
defmodule Chrysopoeia.Selector.CSS.Compiler.Macros do

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

  defmacro ipreceding(e, do: block) do
    quote do
      fn (_e, _a, meta) -> 
        siblings = elem(meta[:siblings], 0)
        pos = elem(meta[:siblings], 1) 

        if is_binary(List.first(siblings)) do
          pos = pos - 2
        else
          pos = pos - 1
        end

        unquote(e) = Enum.at( elem(meta[:siblings], 0), pos)
        result = unquote(block)

        #  IO.puts "PRECEEDING: #{inspect unquote(e)}"

        { result, adjust_sibling_meta(meta, pos, result) }

        #IO.puts "PRECEEDING: #{inspect result} META: #{inspect meta[:siblings]}"
        #x
      end
    end
  end

  defmacro single(e, a, do: block) do
    quote do
      fn (unquote(e), unquote(a), meta) -> 
        IO.puts "SINGLE: #{inspect [:siblings]} SIBLINGS: #{inspect meta[:siblings]}"
        {unquote(block), meta}
      end
    end
  end

  defmacro child(e, do: block) do
    quote do
      fn (_e, _a, meta) -> 
        unquote(e) = List.first(meta[:path]) 
        {unquote(block), adjust_path_meta(meta, 1, :path)}
      end
    end
  end

  # Helper - skips having to repeat enum
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
