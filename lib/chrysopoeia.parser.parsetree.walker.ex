defmodule Chrysopoeia.Parser.ParseTree.Walker do
  @moduledoc
  """
    Methods for walking the parsetree
  """
  import IO, only: [puts: 1]

  @doc
  """
    Walk a parse tree of the syntax pt = {element, arguments, [<{pt}>...]]} 
    where pt can be a recuring child element or re-occur multiple times.

    t: pt, as described above.
    fns: A list of selector/transform functions to be applied during the
         walk. See Transform.transform/2
  """
  def walk(t = {_,_,_}, fns \\ []) do
    #fns = [fn(t = {e, a, c}, acc) -> t end]
    IO.puts "Public"
    _walk(t, fns, [])
  end

  @doc 
  """ 
    matches a text node. The first form matches an empty list of transform
    functions.
  """
  def _walk(t = { e, a, [c]}, [], _acc) when is_binary(c) do
    puts "Text Node #{inspect t}"
    t
  end
    
  def _walk(t = { _, _, [c]}, fns, acc) when is_binary(c) do
    puts "Text Node #{inspect t}"
    Enum.map(fns, fn(fun) -> fun.(t, acc) end)
  end

  @doc
  """
    Add the element and arguments to the accumulator, apply the walk function
    to the tuple elements within the list c

    e: element
    a: arguments
    c: children
  """
  def _walk(t = {e, a, c = _}, fns, acc) when is_list(c) do
    puts "List Walk"
    {e, a, Enum.map(c, fn(et) -> _walk(et, fns, acc) end )}
    
  end

  @doc
  """
    Matches the tuple with no children (i.e an empty list) as the last element.
  """
  def _walk(t = {_, _, _ = []}, [], acc) do
    puts "Empty Last Element"
    t
  end

  def _walk(t = {_, _, _ = []}, fns, acc) do
    puts "Empty Last Element 2"
    Enum.map(fns, fn(fun) -> fun.(t, acc) end)
  end

end
