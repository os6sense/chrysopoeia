
# The code is becoming quite complex and I can macro down a lot
# of the repeated functionality so I want to test that it all fits
# together at this point.

defmodule Chrysopoeia.Selector.CSS.A.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  alias Chrysopoeia.Selector.CSS, as: CSS
  alias Chrysopoeia.Parser.Samples, as: Sample
  alias Chrysopoeia.Parser.ParseTree, as: ParseTree
  alias Chrysopoeia.Parser.ParseTree.Walker.Functions, as: Functions

  test "selector - finds a single element" do
    Sample.simple(:parse_tree)
      |> ParseTree.find( CSS.create("p") )
      |> assert_eq {Sample.simple(:parse_tree), [accumulator: [{"p", [], ["Test"]}, {"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}], index: 0]}
  end

  test "selector - deep nested" do
    Sample.deep_nesting(:parse_tree)
      |> ParseTree.find( CSS.create("span #lvl_4_2") )
      |> assert_eq {Sample.simple(:parse_tree), [accumulator: [{"p", [], ["Test"]}, {"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}], index: 0]}
  end

end
