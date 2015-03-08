
# The code is becoming quite complex and I can macro down a lot
# of the repeated functionality so I want to test that it all fits
# together at this point.

defmodule Chrysopoeia.Selector.CSS.Test do
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

  def test_child(selector) do
    Sample.deep_nesting(:parse_tree)
      |> ParseTree.find(selector)
      |> elem(1)
      |> Keyword.get(:accumulator)
  end

  test "descendant selector - finds a single element" do
    Sample.simple(:parse_tree)
      |> ParseTree.find( CSS.create("p") )
      |> assert_eq {Sample.simple(:parse_tree), [accumulator: [{"p", [], ["Test"]}, {"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}], index: 0]}
  end

  test "descendant selector - deep nested 1" do
      CSS.create("#deep_span span a img[alt=test]") 
      |> test_descendant
      |> assert_eq  [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}]
  end

  test "descendant selector - deep nested single selector (img)" do
      CSS.create("img") 
      |> test_descendant
      |> assert_eq  [{"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"img", [{"alt", "test"}, {"src", "something.jpg"}], []}]
  end
  
  test "descendant selector - deep nested in between elements" do
      CSS.create("span span #lvl_4_3") 
      |> test_descendant
      |> assert_eq  [{"span", [{"id", "lvl_4_3"}], ["lvl4 3"]}]
  end

  test "descendant selector - deep nested last element TEXT" do
      CSS.create("div #lvl_1_last") 
      |> test_descendant
      |> assert_eq  [{"span", [{"id", "lvl_1_last"}], ["lvl_1_last"]}]
  end

  test "descendant selector - deep nested last element no select" do
      CSS.create("div span span #lvl_1_last") 
      |> test_descendant
      |> assert_eq []
  end

  test "child selector - deep nested last element TEXT" do
      CSS.create("div > span > #lvl_1_last") 
      |> test_child
      |> assert_eq  [{"span", [{"id", "lvl_1_last"}], ["lvl_1_last"]}]
  end

  test "child selector - deep nested last element TEXT, no select" do
      CSS.create("body > span > #lvl_1_last") 
      |> test_child
      |> assert_eq  []
  end

  test "mixed selector - deep nested last element TEXT" do
      CSS.create("body span > #lvl_1_last") 
      |> test_child
      |> assert_eq  [{"span", [{"id", "lvl_1_last"}], ["lvl_1_last"]}]
  end

  test "ipreeding selector - deep nested 1" do
      CSS.create("#lvl_4_2 + #lvl_4_3") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_3"}], ["lvl4 3"]}]
  end

  test "ipreeding selector - deep nested 2" do
      CSS.create("span > #lvl_4_2 + #lvl_4_3") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_3"}], ["lvl4 3"]}]
  end

  test "ipreeding selector - deep nested 3" do
      CSS.create("div > #lvl_4_2 + #lvl_4_3") 
      |> test_child
      |> assert_eq []
  end

  test "ipreeding selector - deep nested 4" do
      CSS.create("#lvl_4_1 + #lvl_4_2 + #lvl_4_3 + #lvl_4_4") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_4"}], ["lvl4 4"]}]
  end

  test "ipreceding selector - at the start" do
      CSS.create("#lvl_4_1 + #lvl_4_2") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_2"}], ["lvl4 2"]}]
  end

  test "ipreceding selector - span and elem at the end" do
      CSS.create("span > #lvl_4_6 + #lvl_4_7") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_7"}], ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]
  end

  test "ipreceding selector - at the end" do
      CSS.create("#lvl_4_6 + #lvl_4_7") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_7"}], ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]
  end

  test "preceding selector - at the end" do
      CSS.create("#lvl_4_6 ~ #lvl_4_7") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_7"}], ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]
  end

  test "preceding selector - span and at the end" do
      CSS.create("span > #lvl_4_6 ~ #lvl_4_7") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_7"}], ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]
  end

  test "preceding selector - span and 3 ~ at the end" do
      CSS.create("span > #lvl_4_5 ~ #lvl_4_6 ~ #lvl_4_7") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_7"}], ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]
  end

  test "preceding selector - div and 3 ~ at the end" do
      CSS.create("div #lvl_4_5 ~ span ~ #lvl_4_7") 
      |> test_child
      |> assert_eq [{"span", [{"id", "lvl_4_7"}], ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]
  end

end
