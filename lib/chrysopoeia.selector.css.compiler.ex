# TODO: Compiler has to add spacee (i.e. decendant operator)

# E F                     an F element descendant of an E element
# E > F                   an F element child of an E element
# E + F                   an F element immediately preceded by an E element
# E ~ F                   an F element preceded by an E element

defmodule Chrysopoeia.Selector.CSS.Compiler do

  require Logger
  @doc """
    The map produced by the css parser has 6 fields of which only four
    will be regularly used. The css_map macro provides a short hand
    for those four elements.
  """
  defmacro css_map(type, attr, op, value) do
    quote do
      %{"type" => unquote(type), "attr" => unquote(attr), 
        "op" => unquote(op), 
        "value" => unquote(value), "ptype" => "", "pval" => "" }
    end
  end

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

  # Takes the output of the CSS parser and compiles the map into functions for matching
  def compile(map) when is_list(map) do
    map
      |> Enum.map_reduce(nil, fn 
           ("!", nil)  -> { nil, "!"}
           (">", nil)  -> { nil, ">"}
           ("+", nil)  -> { nil, "+"}
           ("~", nil)  -> { nil, "~"}
           (e, "!")    -> { compile_descendant_selector(e), nil}
           (e, ">")    -> { compile_child_selector(e), nil}
           #(e, "+")    -> { compile_imm_preceding_selector(e), nil}
           #(e, "~")    -> { compile_preceding_selector(e), nil}
           (e, nil)    -> { compile_selector(e), nil}
      end)
      |> elem(0)
      |> Enum.reject(fn (e) -> e == nil end)
  end

  # ============================= CHILD  ==================================
  # E > F                   an F element child of an E element
  defmacro child(e, do: block) do
    quote do
      fn (_e, _a, meta) -> 
        unquote(e) = List.last(meta[:path]) 
        unquote(block) 
      end
    end
  end

  def compile_child_selector( css_map(type, "", "", "") ) do
    child(e) do elem(e, 0) == type end
  end
  # :attribute_only
  def compile_child_selector( css_map("", attr, "", "") ) do
  end


  # ========================== DESCENDANT  ================================
  @doc """
    E F - an F element descendant of an E element
    return true if there is an element in the path matching the selector
    value
  """
  # Helper - skips having to repeat enum
  defmacro descendant(e, do: block) do
    quote do
      fn (_e, _a, meta) -> Enum.any?(meta[:path], fn (unquote(e)) -> unquote(block) end) end
    end
  end

  # element only
  def compile_descendant_selector( css_map(type, "", "", "") ) do
    Logger.debug("COMPILING DEC FN")
    descendant(e) do Logger.debug("DEC FN element only e:#{inspect elem(e, 0)}, type:#{inspect type}"); elem(e, 0) == type end
  end
  # :attribute_only
  def compile_descendant_selector( css_map("", attr, "", "") ) do
    descendant(e) do Logger.debug("DEC FN"); has_attribute?(elem(e, 1), attr) end
  end
  # :attribute_value
  def compile_descendant_selector( css_map("", attr, op, value) ) do
    descendant(e) do Logger.debug("DEC FN"); has_attribute_with_value?(elem(e, 1), attr, op, value) end
  end
  # :element_attribute
  def compile_descendant_selector( css_map(type, attr, "", "") ) do
    descendant(e) do Logger.debug("DEC FN"); elem(e, 0) == type && has_attribute?(elem(e, 1), attr) end
  end
  # :element_attribute_value
  def compile_descendant_selector( css_map(type, attr, op, value) ) do
    descendant(e) do 
      Logger.debug("DEC FN")
      elem(e, 0) == type 
      && has_attribute_with_value?(elem(e, 1), attr, op, value) 
    end
  end

  defp test_with_op("=" , lval, value), do: lval == value
  defp test_with_op("^=", lval, value), do: String.starts_with?(lval, value)
  defp test_with_op("$=", lval, value), do: String.ends_with?(lval, value)
  defp test_with_op("*=", lval, value), do: String.contains?(lval, value)
  defp test_with_op("|=", lval, value), do: String.starts_with?(lval, value <> "|")

  # Simplist case: matches the attribute itself. Used for single element
  # selectors e.g. "p"
  # :simple_element
  def compile_selector( css_map(type, "", "", "") ), 
    do: fn (e, _a, _meta) -> element_matches_type?(e, type) end
  # :attribute_only
  def compile_selector( css_map("", attr, "", "") ), 
    do: fn (_e, a, _meta) -> has_attribute?(a, attr) end
  # :attribute_value
  def compile_selector( css_map("", attr, op, value) ), 
    do: fn (e, a, _meta) -> has_attribute_with_value?(a, attr, op, value) end
  # :simple_element_attribute
  def compile_selector( css_map(type, attr, "", "") ), 
    do: fn (e, a, _meta) -> element_matches_type?(e, type) 
                        && has_attribute?(a, attr) end
  # :simple_element_attribute_value
  def compile_selector( css_map(type, attr, op, value) ), 
    do: fn (e, a, _meta) -> element_matches_type?(e, type) 
                        && has_attribute_with_value?(a, attr, op, value) end

  def compile_selector(%{"type" => type, "attr" => attr, "op" => op, 
                          "value" => value, "ptype" => ptype, "pval" => pval }) do
    # fail, not yet implemented  
  end
  
end
