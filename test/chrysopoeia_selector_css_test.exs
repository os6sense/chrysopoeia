
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

  def test_descendant(selector) do
    Sample.deep_nesting(:parse_tree)
      |> ParseTree.find( selector )
      |> elem(1)
      |> Keyword.get(:accumulator)
  end

  test "selector - finds a single element" do
    Sample.simple(:parse_tree)
      |> ParseTree.find( CSS.create("p") )
      |> assert_eq {Sample.simple(:parse_tree), [accumulator: [{"p", [], ["Test"]}, {"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}], index: 0]}
  end

  # Th
  test "selector - deep nested 1" do
      CSS.create("#deep_span span a img[alt=test]") 
      |> test_descendant
      |> assert_eq  [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}]
  end

  test "selector - deep nested single selector (img)" do
      CSS.create("img") 
      |> test_descendant
      |> assert_eq  [{"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"img", [{"alt", "test"}, {"src", "something.jpg"}], []}]
  end
  
  test "selector - deep nested in between elements" do
      CSS.create("span span #lvl_4_3") 
      |> test_descendant
      |> assert_eq  [{"span", [{"id", "lvl_4_3"}], ["lvl4 3"]}]
  end

  test "selector - deep nested last element" do
      CSS.create("div #lvl_1_last") 
      |> test_descendant
      |> assert_eq  [{"span", [{"id", "lvl_1_last"}], ["lvl_1_last"]}]
  end

  test "selector - deep nested last element no select" do
      CSS.create("div span span #lvl_1_last") 
      |> test_descendant
      |> assert_eq []
  end



end
