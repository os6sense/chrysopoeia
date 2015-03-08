
defmodule Chrysopoeia.Parser.ParseTree do
  require Logger

  require Chrysopoeia.Parser.ParseTree.Walker, as: Walker
  require Chrysopoeia.Parser.ParseTree.Walker.Functions, as: Functions
  alias Chrysopoeia.Selector.CSS, as: CSS

  def walk(t),      do: Walker.walk(t) |> elem(0)
  def walk(t, fns), do: Walker.walk(t, fns) |> elem(0)

  def find(parse_tree, selector) when is_binary(selector) do
    Walker.walk(parse_tree, [Functions.function(:find, CSS.create(selector) )])
  end

  def find(parse_tree, selector) when is_list(selector) do
    Walker.walk(parse_tree, [Functions.function(:find, selector)])
  end

  def delete(parse_tree, selector) when is_binary(selector) do
    Walker.walk(parse_tree, [Functions.function(:delete, CSS.create(selector) )]) 
      |> elem(0)
  end

  def delete(parse_tree, selector) when is_list(selector) do
    Walker.walk(parse_tree, [Functions.function(:delete, selector )]) 
      |> elem(0)
  end

  # insert a text node
  #def insert(parse_tree, selector_fn, fragment) when is_binary(fragment) do
    ## convert text fragment to parse_tree
  #end

  ## insert a parse_tree_fragment
  #def insert(parse_tree, selector_fn, fragment) when is_tuple(fragment) do
  #end


  def to_html(parse_tree) do
    Walker.walk(parse_tree) 
      |> elem(0)
      |> :mochiweb_html.to_html
      |> Enum.join  
  end

  # alternate way of walking the tree - probably much better
  #def prepare_tree({tag, attrs, children}) when not is_atom(tag) do
      #{tag, make_ref(), attrs, prepare_tree(children, [])}
  #end

  #def prepare_tree(tree) do 
    #tree
  #end

  #def prepare_tree([], result) do 
    #Enum.reverse(result)
  #end

  #def prepare_tree([head | tail], result) do
      #prepare_tree(tail, [prepare_tree(head) | result])
  #end


end
