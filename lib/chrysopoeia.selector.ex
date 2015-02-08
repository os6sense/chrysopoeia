
"""

Below is the list of CSS selectors from 

*                       any element 

E                       an element of type E  

E#myid                  an E element with ID equal to "myid".

E:not(s)                an E element that does not match simple selector s

E F                     an F element descendant of an E element

E > F                   an F element child of an E element

E + F                   an F element immediately preceded by an E element

E ~ F                   an F element preceded by an E element

E[foo]                  an E element with a "foo" attribute

E[foo="bar"]            an E element whose "foo" attribute value is exactly 
                        equal to "bar"

E[foo~="bar"]           an E element whose "foo" attribute value is a list of 
                        whitespace-separated values, one of which is exactly 
                        equal to "bar"

E[foo^="bar"]           an E element whose "foo" attribute value begins 
                        exactly with the string "bar"

E[foo$="bar"]           an E element whose "foo" attribute value ends exactly 
                        with the string "bar"

E[foo*="bar"]           an E element whose "foo" attribute value contains the 
                        substring "bar"

E[foo|="en"]            an E element whose "foo" attribute has a 
                        hyphen-separated list of values beginning (from the 
                        left) with "en"

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

E::first-line   the first formatted line of an E element  The ::first-line pseudo-element   1
E::first-letter   the first formatted letter of an E element  The ::first-letter pseudo-element   1
E::before   generated content before an E element   The ::before pseudo-element   2
E::after  generated content after an E element  The ::after pseudo-element  2


"""
defmodule Chrysopoeia.Selector.CSS do
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

