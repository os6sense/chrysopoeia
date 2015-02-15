defmodule Chrysopoeia.Parser.Transform do
  @moduledoc 
  """
  Methods for transforming the parsetree
  """
  require Chrysopoeia.Parser.ParseTree, as: PT
  
  # Thought - maybe create a transfrom so that we
  # have a kw list rather than sting keys?
  #def to_kw_list(parse_tree) do
    #parse_tree
  #end

  alias Chrysopoeia.Selector.CSS, as: CSS

  def transform(t = {_, _, _}, fns) do
    PT.walk(t, fns)
  end

  defmacro attribute_set(name, val) do
    quote do
      match_args = fn ({an, av}) 
        -> if an == unquote(name), do: {an, unquote(val)}, else: {an, av} 
      end
      fn ({e, a, c}) -> {e, Enum.map(a, match_args), c} end
    end
  end

  @doc ~S"""
    Creates a new transform

    selector, block
  """
  defmacro create(selector, do: blk) do
    quote do
      fn(t = {_, _, _}, acc) 
        -> if CSS.match(t, unquote(selector)), do: unquote(blk).(t), else: t
      end
    end
  end

  def attribute(selector, attribute, new_value) do
    create(selector) do
      attribute_set(attribute, new_value)
    end

  end

end


