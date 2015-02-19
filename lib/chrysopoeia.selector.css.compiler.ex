

defmodule Chrysopoeia.Selector.CSS.Compiler do

  defp compile(map) when is_list(map) do
    map
      |> Enum.map( &(compile_selector(&1)) )
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

  def is_not_pseudo(m) do
  end


  # What about *?


  # :simple_element
  def compile_selector(%{"type" => type, "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" }) do
    fn (e, a, _meta) -> e == type end
  end

  # :attribute_only
  def compile_selector(%{"type" => "", "attr" => attr, "op" => "", 
                          "value" => "", "ptype" => "", "pval" => "" }) do
    fn (e, a, _meta) -> Enum.any?(a, fn ({lattr, lval}) -> lattr == attr end) end
  end

  defp test_with_op("=" , lval, value), do: lval == value
  defp test_with_op("^=", lval, value), do: String.starts_with?(lval, value)
  defp test_with_op("$=", lval, value), do: String.ends_with?(lval, value)
  defp test_with_op("*=", lval, value), do: String.contains?(lval, value)
  defp test_with_op("|=", lval, value), do: String.starts_with?(lval, value <> "|")

  # :attribute_value
  def compile_selector(%{"type" => "", "attr" => attr, "op" => op, "value" => value, 
                          "ptype" => "", "pval" => "" }) do
    #:attribute_value
    fn (e, a, _meta) -> Enum.any?(a, fn ({lattr, lval}) -> 
                    lattr == attr 
                    && test_with_op(op, lval, value)
                    #&& cond do
                      #op == "=" -> lval == value
                      #op == "^=" -> String.starts_with?(lval, value)
                      #op == "$=" -> String.ends_with?(lval, value)
                      #op == "*=" -> String.contains?(lval, value)
                      #op == "|=" -> String.starts_with?(lval, value <> "|")
                    #end
      end) 
    end
  end

  # :simple_element_attribute
  def compile_selector(%{"type" => type, "attr" => attr, "op" => "", "value" => "", 
                          "ptype" => "", "pval" => "" }) do
    fn (e, a, _meta) -> e == type && Enum.any?(a, fn ({lattr, lval}) -> lattr == attr end) end
  end

  # :simple_element_attribute_value
  def compile_selector(%{"type" => type, "attr" => attr, "op" => op, "value" => value, 
                          "ptype" => "", "pval" => "" }) do
    fn (e, a, _meta) -> e == type 
      && Enum.any?(a, fn ({lattr, lval}) -> lattr == attr 
                        #&& lval == value end) 
                        && test_with_op(op, lval, value) end)
    end
  end

  def compile_selector(%{"type" => type, "attr" => attr, "op" => op, 
                          "value" => value, "ptype" => ptype, "pval" => pval }) do
    # fail, not implemented  
  end






  # need to think about the match function in order to work this out
  # mfns are the match functions
  def match(e, a, meta, mfns) do
    
    # so say I have the above data to work with, I'm the b element within a p
    # so take the simplist case
    #List.last(mfns).(e, a, meta) # call the last match function 
                                 # which is, e == "b"
                                 # its true so we'd return true

    # So harder, lets say we have "span p b" as our selector
    #List.last(mfns).(e, a, meta) # call the last match function 
                                 # which is, e == "b"
                                 # its true so we do the next one using the
                                 # next value in the path
    #List.last(mfns, -1).(List.last(meta[:path], -1), those_args, meta)
                                 # which is e == p

    # So our starting point is that the e, a arguments passed into the compiled
    # selector function may contain either the values of the current node
    # OR those of the path
  end

  
end
