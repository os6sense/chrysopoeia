defmodule Chrysopoeia.Parser.ParseTree.Test do
  use ExUnit.Case
  import SaneAsserts

  alias Chrysopoeia.Parser.ParseTree, as: ParseTree
  alias Chrysopoeia.Parser.Samples, as: Sample

  test "Delete - simple, body" do
    Sample.simple(:parse_tree)
      |> ParseTree.delete("body")
      |> assert_eq {"html", [], [{"head", [], []}]}
  end

  test "Delete - Deep Nesting" do
    Sample.deep_nesting(:parse_tree)
      |> ParseTree.delete("img")
      |> ParseTree.delete("a")
      |> ParseTree.delete("br")
      |> ParseTree.delete("span")
      |> ParseTree.delete("garbage")
      |> assert_eq {"html", [], [{"head", [], []}, {"body", [], [{"div", [{"id", "deep_span"}], []}]}]}
  end

  test "Find - simple" do
    Sample.simple(:parse_tree)
      |> ParseTree.find("p")
      |> assert_eq {Sample.simple(:parse_tree), Sample.simple(:only_ps)}
  end

  test "to_html - simple" do
    Sample.simple(:parse_tree)
      |> ParseTree.to_html
      |> assert_eq Sample.simple(:html)
  end

  test "to_html - Deep Nestin" do
    Sample.deep_nesting(:parse_tree)
      |> ParseTree.to_html
      |> assert_eq "<html><head></head><body><div id=\"deep_span\"><span>lvl 1<span>lvl_2 1<span id=\"lvl_2_2\">lvl2 2</span><span>lvl 3<br /><span id=\"lvl_4_1\">lvl4 1</span><span id=\"lvl_4_2\">lvl4 2</span><span id=\"lvl_4_3\">lvl4 3</span><span id=\"lvl_4_4\">lvl4 4</span><span id=\"lvl_4_5\">lvl4 5</span><span id=\"lvl_4_6\">lvl4 6</span><span id=\"lvl_4_7\">lvl4 7<img src=\"something.jpg\" alt=\"test\" /><a href=\"somewhere.html\"><img alt=\"test\" src=\"something.jpg\" />sometext</a></span></span><span id=\"lvl2_3\">lvl2 3</span></span></span><span id=\"lvl 1 last\">lvl 1 last</span></div></body></html>"
  end


end
