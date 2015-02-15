
"""

Below is the list of CSS selectors from 

.ident                  equivilent to *[class="ident"]
#ident                  equivilent to *[id="ident"]

*                       any element 

E                       an element of type E  

E#myid                  an E element with ID equal to "myid".

E:not(s)                an E element that does not match simple selector s

E F                     an F element descendant of an E element
e.g. "div p" would select all p elements that are a child of div

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

  def match(t = {_,_,_}, selectors) do
    true
  end

  @doc ~S"""


  """
  def parse(sel) do
    cond do
      # returns {element, attribute, regexp} works for attribute selectors
      sel.contains("[") ->
        # its an attribute selector
        cond do
          sel.contains("~=") -> nil
            # E[foo~="bar"] an E element whose "foo" attribute value is a
            # list of whitespace-separated values, one of which is exactly
            # equal to "bar"
          sel.contains("^=") -> nil
            # E[foo^="bar"] an E element whose "foo" attribute value begins
            # exactly with the string "bar"
          sel.contains("$=") -> nil
            # E[foo$="bar"] an E element whose "foo" attribute value ends
            # exactly with the string "bar"
          sel.contains("*=") -> nil
            # E[foo*="bar"] an E element whose "foo" attribute value contains the 
            # substring "bar"
          sel.contains("|=") -> nil
            # E[foo|="en"] an E element whose "foo" attribute has a
            # hyphen-separated list of values beginning (from the left) with
            # "en"
          sel.contains("=") ->  nil
            # E[foo="bar"] an E element whose "foo" attribute value is
            # exactly equal to "bar"
          true -> 
            # E[foo] an E element with a "foo" attribute
            "tmp"
        end

      #sel.contains(":") ->
       ## its a child selector OR e:not(s)
      #sel.contains("#") ->
      ## E#myid                  an E element with ID equal to "myid".
      #sel.contains(">") ->
      #sel.contains("+") ->
      #sel.contains("~") ->



    # E > F                   an F element child of an E element

    # E + F                   an F element immediately preceded by an E element

    # E ~ F                   an F element preceded by an E element




      {"p", nil, nil}
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
  end

