defmodule Chrysopoeia.Parser.ParseTree.Walker do
  require Logger
  @moduledoc
  """
    Methods for walking the parsetree
  """
  import IO, only: [puts: 1]

  defmacro function(:copy) do
    quote do
      fn(t, a) -> 
        Logger.debug "copy: #{inspect t} -- #{inspect a}"
        unless a == [], do: a, else: t 
      end
    end
  end

  defmacro function(:delete, name) do
    quote do
      fn(t = {e, a, c}, acc) -> 
        Logger.debug "delete: #{inspect e} -- #{inspect unquote(name)}"
        unless e == unquote(name), do: t, else: {:delete, [], []}
      end
    end
  end

  defmacro function(:find, name) do
     quote do
      fn(t, a) -> 
        Logger.debug "find: #{inspect t} #{inspect a}"
        if e == unquote(name), do: t 
      end
    end
  end

  @doc ~S"""
    Walk a parse tree of the syntax pt = {element, arguments, [<{pt}>...]]} 
    where pt can be a recuring child element or re-occur multiple times.

    t: pt, as described above.
    fns: A list of selector/transform functions to be applied during the
         walk. See Transform.transform/2 
         a single function in the function list is of the form:

            fn(tuple, accumulator)

          e.g. the default copy function is:
            fn(t = {e, a, c}, acc) -> t end]
  """
  def walk(t, fns \\ [function(:copy)]) when is_tuple(t) do
    Logger.debug "Walk"
    _walk(t, fns, nil)
  end

  @doc ~S""" 
    matches a text node. 
  """
  def _walk(text , fns, acc) when is_binary(text) do
    Logger.debug "Text Node 2 - #{inspect text} || #{String.strip(text)}"
    String.strip(text)
  end
    
    # matches a text node with children
  def _walk(t = { _, _, [c]}, fns, acc) when is_binary(c) do
    Logger.debug "Text Node 3 - #{inspect t}"
    reduce_node(fns, t)
  end

  @doc ~S"""
    Add the (e)lement and (a)rguments to the accumulator, apply the walk
    function to the tuple elements within the list c
  """
  def _walk(t = {e, a, c = [head | tail]}, fns, acc) when is_list(c) do
    Logger.debug "List Walk - #{inspect e}"
    {e, a, c} = reduce_node(fns, t)

    unless e == :delete do
      children = Enum.map(c, fn(child) -> _walk(child, fns, acc) end)
      {e, a, Enum.filter(children, &fn_filter_child/1)}
    end
  end


  @doc ~S"""
    Matches the tuple with no children (i.e an empty list) as the last element.
  """
  def _walk(t = {_, _, []}, fns, acc) do
    Logger.debug "Empty Last Element (fns) #{inspect t}"
    reduce_node(fns, t)
    #Enum.reduce([[]] ++ fns, fn(fun, r_acc) -> fun.(t, r_acc) end)
  end

  @doc ~S"""

  """
  def _walk({}, _fns, _acc) do
    Logger.debug "Empty Element (fns)"
    {}
  end

  # -------- Helpers --------
  # 
  # Used by Enum.filter to remove tupple with :delete as the first value
  defp fn_filter_child({e, a, c}), do: e != :delete
  defp fn_filter_child(text) when is_binary(text), do: true

  # Apply the fncs to the node - really only useful for text nodes
  # or those without children
  defp reduce_node(fns, t), 
    do: Enum.reduce([[]] ++ fns, fn(fun, r_acc) -> fun.(t, r_acc) end)


end
