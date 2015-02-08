defmodule Chrysopoeia.Parser.Transform do
  @moduledoc 
  """
  Methods for transforming the parsetree
  """

  require Chrysopoeia.Parser.ParseTree
  alias Chrysopoeia.Parser.ParseTree, as: PT
  
  #def to_kw_list(parse_tree) do
    #parse_tree
  #end

  def transform([list], css_fun, trns_fun \\ nil) do
    PT._walk(list, css_fun, trns_fun, [])
  end

end


