
defmodule Chrysopoeia.Parser.ParseTree do
  require Logger

  require Chrysopoeia.Parser.ParseTree.Walker, as: Walker

  defdelegate walk(t), to: Walker
  defdelegate walk(t, fns), to: Walker

  def find(parse_tree, node) do
    walk(parse_tree, [Walker.function(:find, "p")])
  end

  def delete(parse_tree, name) do
    walk(parse_tree, [Walker.function(:delete, name)])
  end

end
