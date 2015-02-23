# TODO: Compiler has to add spacee (i.e. decendant operator)

# E F                     an F element descendant of an E element
# E > F                   an F element child of an E element
# E + F                   an F element immediately preceded by an E element
# E ~ F                   an F element preceded by an E element

defmodule Chrysopoeia.Selector.CSS.Compiler do

  # Takes the output of the CSS parser and compiles the map into functions for matching
  defp compile(map) when is_list(map) do
    map
      #|> Enum.map( &(compile_selector(&1)) )
      |> Enum.map_reduce(nil, fn 
                                (" ", nil)  -> { nil, " "}
                                ("<", nil)  -> { nil, "<"}
                                ("+", nil)  -> { nil, "+"}
                                ("~", nil)  -> { nil, "~"}
                                (e, " ")    -> { compile_selector(e, " "), nil}
                                (e, "+")    -> { compile_selector(e, "+"), nil}
                                (e, "~")    -> { compile_selector(e, "~"), nil}
                                (e, nil)    -> { compile_selector(e), nil}
      end)
  end

  # E F                     an F element descendant of an E element
  # return true if there is an e element in the path - does my path now include attributes?
  def compile_selector(%{"type" => type, "attr" => "", "op" => "", 
                         "value" => "", "ptype" => "", "pval" => "" }, " ") do
    fn (e, a, meta) -> e == type end
  end
 
  # takes a string which should be either a combinator function or a simple
  # selector

  #  "b" [{"id", "lvl_4_1"}] 
  # -- META: [ path: [{"html"}, {"body"}, {"div"}, {"span"}, {"p"}], 
  #            children: {["TEXT"], 0, 1}, 
  #            siblings: {["TEXT", "br", "i", "b", "span"], 4, 5}]
  # Combinators
  def compile_selector(str) when is_binary(str) do
      #str == ">" -> fn (e, a, meta) -> fn(a, b) -> true end end
      #str == "+" -> fn (e, a, meta) -> fn(a, b) -> true end end
      #str == "~" -> fn (e, a, meta) -> fn(a, b) -> true end end
    :combine
  end

  defp test_with_op("=" , lval, value), do: lval == value
  defp test_with_op("^=", lval, value), do: String.starts_with?(lval, value)
  defp test_with_op("$=", lval, value), do: String.ends_with?(lval, value)
  defp test_with_op("*=", lval, value), do: String.contains?(lval, value)
  defp test_with_op("|=", lval, value), do: String.starts_with?(lval, value <> "|")

  defmacro element_matches_type?(e, type) do
    quote do
      unquote(e) == unquote(type)
    end
  end

  # :simple_element
  def compile_selector(%{"type" => type, "attr" => "", "op" => "", 
                         "value" => "", "ptype" => "", "pval" => "" }) do
    fn (e, a, _meta) -> element_matches_type?(e, type) end# e == type end
  end

  defmacro has_attribute?(attributes, attribute_name) do
    quote do
      Enum.any?(unquote(attributes), fn 
        ({lattr, lval}) -> lattr == unquote(attribute_name) 
      end)
    end
  end

  # :attribute_only
  def compile_selector(%{"type" => "", "attr" => attr, "op" => "", 
                          "value" => "", "ptype" => "", "pval" => "" }) do
    #fn (e, a, _meta) -> Enum.any?(a, fn ({lattr, lval}) -> lattr == attr end) end
    fn (e, a, _meta) -> has_attribute?(a, attr) end
  end

  defmacro has_attribute_with_value?(attributes, attribute_name, op, value) do
    quote do
      Enum.any?(unquote(attributes), fn 
        ({lattr, lval}) -> lattr == unquote(attribute_name) 
                           && test_with_op(unquote(op), lval, unquote(value))
      end) 
    end
  end

  # :attribute_value
  def compile_selector(%{"type" => "", "attr" => attr, "op" => op, "value" => value, 
                          "ptype" => "", "pval" => "" }) do
    #fn (e, a, _meta) -> Enum.any?(a, fn ({lattr, lval}) -> 
                    #lattr == attr && test_with_op(op, lval, value)
      #end) 
    fn (e, a, _meta) -> has_attribute_with_value?(a, attr, op, value) end
  end

  # :simple_element_attribute
  def compile_selector(%{"type" => type, "attr" => attr, "op" => "", "value" => "", 
                          "ptype" => "", "pval" => "" }) do
    #fn (e, a, _meta) -> e == type && Enum.any?(a, fn ({lattr, lval}) -> lattr == attr end) end
    fn (e, a, _meta) -> element_matches_type?(e, type) && has_attribute?(a, attr) end
  end

  # :simple_element_attribute_value
  def compile_selector(%{"type" => type, "attr" => attr, "op" => op, "value" => value, 
                          "ptype" => "", "pval" => "" }) do
    #fn (e, a, _meta) -> e == type 
      #&& Enum.any?(a, fn ({lattr, lval}) -> lattr == attr 
                        #&& test_with_op(op, lval, value) end)
    #end

    fn (e, a, _meta) -> element_matches_type?(e, type) 
                        && has_attribute_with_value?(a, attr, op, value) end
  end

  def compile_selector(%{"type" => type, "attr" => attr, "op" => op, 
                          "value" => value, "ptype" => ptype, "pval" => pval }) do
    # fail, not yet implemented  
  end
  
end
