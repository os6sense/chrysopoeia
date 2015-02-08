
defmodule Chrysopoeia.Parser.ParseTree do
  @moduledoc
  """
    Methods for walking the parsetree
  """
  import IO, only: [puts: 1]

  @doc
  """

  """
  def walk([list], css_fun \\ fn -> true end, trns_fun \\ nil) do
    _walk(list, css_fun, trns_fun, [])
  end

  @doc 
  """
  matches a text node.
  """
  def _walk(t = {e, a, [c]}, css_fun, trns_fun, acc) when is_binary(c) do
    if css_fun.(t), do: trns_fun.(t), else: t
  end

  @doc
  """
  Add the element and arguments to the accumulator, apply the walk function
  to the tuple elements within the list c
  """
  def _walk(t = {e, a, c = _}, css_fun, trns_fun, acc) when is_list(c) do
    acc ++ {e, a, Enum.map(c, fn(et) 
      -> _walk(et, css_fun, trns_fun, acc) 
    end )}
  end

  @doc
  """
  Matches the tuple with no children (i.e an empty list) as the last element.
  """
  def _walk(t = {e, a, l = []}, css_fun, trns_fun, acc) do 
    if css_fun.(t), do: trns_fun.(t), else: t
  end
end


