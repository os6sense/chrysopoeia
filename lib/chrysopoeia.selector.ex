
"""

Below is the list of CSS selectors 

.ident                  equivilent to *[class="ident"]
#ident                  equivilent to *[id="ident"]

*                       any element 
E                       an element of type E  
E#myid                  an E element with ID equal to "myid".
E:not(s)                an E element that does not match simple selector s
E F                     an F element descendant of an E element
E > F                   an F element child of an E element
E + F                   an F element immediately preceded by an E element
E ~ F                   an F element preceded by an E element
E:nth-child(n)          an E element, the n-th child of its parent
E:nth-last-child(n)     an E element, the n-th child of its parent, counting 
                        from the last one
E:nth-of-type(n)        an E element, the n-th sibling of its type 
E:nth-last-of-type(n)   an E element, the n-th sibling of its type, counting 
                        from the last one
E:first-child           an E element, first child of its parent
E:last-child            an E element, last child of its parent
E:first-of-type         an E element, first sibling of its type
E:last-of-type          an E element, last sibling of its type
E:only-child            an E element, only child of its parent
E:only-of-type          an E element, only sibling of its type
E:empty                 an E element that has no children (including text nodes)




"""
defmodule Chrysopoeia.Selector.CSS do


  @doc ~S"""
    Given a string e.g. "div span p", create a selector function for matching
    against the meta. The function should be a list of functions which can
    be applied (right to left?) to match a nodes e, a and meta
  """
  def create(str) do
    str
      |> split
      |> compile
  end

  defp compile(map) when is_list(map) do
    map
      |> Enum.map( &(compile_selector(&1)) )
  end

  # takes a string which should be either a combinator function or a simple
  # selector

  #  "span" [{"id", "lvl_4_1"}] 
  # -- META: [ path: [{"html"}, {"body"}, {"div"}, {"span"}, {"span"}, {"span"}, {"span"}], 
  #            children: {["TEXT"], 0, 1}, 
  #            siblings: {["TEXT", "br", "span", "span", "span", "span", "span", "span", "span"], 3, 9}]
  # Combinators
  defp compile_selector(str) when is_binary(str) do
      #str == ">" -> fn (e, a, meta) -> fn(a, b) -> true end end
      #str == "+" -> fn (e, a, meta) -> fn(a, b) -> true end end
      #str == "~" -> fn (e, a, meta) -> fn(a, b) -> true end end
  end

  defp compile_selector(map) do
    #cond do


      ## Child?
      #str.contains(":") -> fn (e, a, meta) ->  false end

      ## it is an element selector?
      #true ->fn (e, a, meta) -> e == str end
    #end
  end

  # Helper - make . and # syntax consistant
  defp normalise(str) do
    cond do
      # equivilent to *[class=val]
      String.starts_with?(str, [".", "*."]) ->
        "[class=#{String.lstrip(str, ?.)}]"
      # equivilent to [id=val]
      String.starts_with?(str, ["#", "*#"]) -> 
        "[id=#{String.lstrip(str, ?#)}]"
      true -> str
    end
  end

  def split(str) do
    str 
      |> String.split
      |> Enum.map &_do_split(&1)
  end
  
  # Takes a selector string and returns matched groups. 
  defp _do_split(">"), do: ">"
  defp _do_split("+"), do: "+"
  defp _do_split("~"), do: "~"
  defp _do_split(str) when is_binary(str) do
    str = normalise(str)
    #https://regex101.com/r/xW8tT1/2 - I feel dirty
    ~r/(?<type>[\w\*]+)?([\[](?<attr>\w+)((?<op>[\^$|~\*]?=?)(?<value>[\w]+))?[\]])?([:](?<ptype>[\w\-]+)([\(](?<pval>[\d]+)[\)])?)?/
      |> Regex.named_captures(str)
  end

  #def match(parse_tree, css_selector = "*", fun) do
  ##    walk(parse_tree, fn(e, a, c) -> true end, fn)
  #end

  #def match(parse_tree, css_selector = "." <> binary, fun) do
  #end

  #def match(parse_tree, css_selector = "#" <> binary, fun) do
  #end

  #def match(parse_tree, css_selector) do
  #end
end
