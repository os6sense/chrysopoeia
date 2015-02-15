
defmodule Chrysopoeia.Parser.ParseTree.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  alias Chrysopoeia.Parser.ParseTree, as: ParseTree

  test "Simple Walk" do
    Chrysopoeia.Parser.Samples.simple(:parse_tree)
      |> ParseTree.walk 
      |> assert_eq Chrysopoeia.Parser.Samples.simple(:parse_tree)
  end

  test "Deep Nesting Walk" do
    Chrysopoeia.Parser.Samples.deep_nesting(:parse_tree)
      |> ParseTree.walk 
      |> assert_eq Chrysopoeia.Parser.Samples.deep_nesting(:parse_tree)
  end


  # Find isnt working because the application of functions to the structure
  # relies on a broken walker.
  #test "find" do
    #Chrysopoeia.Parser.Samples.simple(:parse_tree)
      #|> ParseTree.find("p")
      #|> assert_eq Chrysopoeia.Parser.Samples.simple(:parse_tree)
  #end

end
