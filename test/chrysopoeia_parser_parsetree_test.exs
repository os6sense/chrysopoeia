
defmodule Chrysopoeia.Parser.ParseTree.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  alias Chrysopoeia.Parser.ParseTree, as: ParseTree

  test "walk" do
    Chrysopoeia.Parser.Samples.simple(:parse_tree)
      |> ParseTree.walk 
      |> assert_eq Chrysopoeia.Parser.Samples.simple(:parse_tree)
  end

  test "find" do
    Chrysopoeia.Parser.Samples.simple(:parse_tree)
      |> ParseTree.find("p")
      |> assert_eq Chrysopoeia.Parser.Samples.simple(:parse_tree)
  end

end
