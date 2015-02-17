
defmodule Chrysopoeia.Parser.ParseTree do
  require Logger

  require Chrysopoeia.Parser.ParseTree.Walker, as: Walker

  defmacro function(:delete, name) do
    quote do
      fn(t = {e, a, c}, acc) -> 
        Logger.debug "delete: #{inspect e} -- #{inspect unquote(name)}"
        unless e == unquote(name), do: {t, acc}, else: {{:delete, [], []}, acc}
      end
    end
  end

  defmacro function(:find, name) do
     quote do
      fn(t = {e, a, c}, acc) -> 
        Logger.debug "find A: #{inspect t} -- #{inspect acc}"
        if e == unquote(name), do: acc = acc ++ [t]
        Logger.debug "find B: #{inspect t} -- #{inspect acc}"
        {t, acc}
      end
    end
  end

  def walk(t),      do: Walker.walk(t) |> elem(0)
  def walk(t, fns), do: Walker.walk(t, fns) |> elem(0)

  def find(parse_tree, selector_fn) do
    Walker.walk(parse_tree, [function(:find, selector_fn)])
  end

  def delete(parse_tree, selector_fn) do
    Walker.walk(parse_tree, [function(:delete, selector_fn)]) 
      |> elem(0)
  end

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
