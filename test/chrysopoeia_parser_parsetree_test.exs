
defmodule Chrysopoeia.Parser.ParseTree.Test do
  use ExUnit.Case

  alias Chrysopoeia.Parser.ParseTree, as: ParseTree
  alias Chrysopoeia.Parser.Samples, as: Sample

  def assert_eq(left, right) do
    assert left == right
  end

  def assert_walk_does_not_change(parse_tree), 
    do: parse_tree |> ParseTree.walk |> assert_eq parse_tree

  test "empty", 
    do: assert_walk_does_not_change Sample.empty(:parse_tree)

  test "empty_html", 
    do: assert_walk_does_not_change Sample.empty_html(:parse_tree)

  test "single_empty_node", 
    do: assert_walk_does_not_change Sample.single_empty_node(:parse_tree)

  test "single_text_node", 
    do: assert_walk_does_not_change Sample.single_text_node(:parse_tree)

  test "Simple Walk", 
    do: assert_walk_does_not_change Sample.simple(:parse_tree)

  test "Deep Nesting Walk", 
    do: assert_walk_does_not_change Sample.deep_nesting(:parse_tree)

  test "Delete - single_text_node" do
    Sample.simple(:parse_tree)
      |> ParseTree.delete("p")
      |> assert_eq {"html", [], [{"head", [], []}, {"body", [], []}]}
  end

  #test "Delete - Deep Nesting" do
    #Sample.deep_nesting(:parse_tree)
      #|> ParseTree.delete("span")
      #|> assert_eq {"tml", [], [{"head", [], []}, {"body", [], []}]}
  #end


  # Find isnt working because the application of functions to the structure
  # relies on a broken walker.
  #test "Find" do
    #Chrysopoeia.Parser.Samples.simple(:parse_tree)
      #|> ParseTree.find("p")
      #|> assert_eq Chrysopoeia.Parser.Samples.simple(:only_ps)
  #end

end
