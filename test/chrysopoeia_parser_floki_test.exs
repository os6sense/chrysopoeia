
defmodule Chrysopoeia.Parser.Floki.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  test "parses well formed html" do
    Chrysopoeia.Parser.Samples.simple(:html)
      |> Chrysopoeia.Parser.Floki.parse
      |> assert_eq Chrysopoeia.Parser.Samples.simple(:parse_tree) 
  end

  test"parses malformed html with closing tag missing" do
    Chrysopoeia.Parser.Samples.simple_sans_closing(:html)
      |> Chrysopoeia.Parser.Floki.parse
      |> assert_eq Chrysopoeia.Parser.Samples.simple_sans_closing(:parse_tree)
  end

  test"parses malformed html with closing tag overlapping" do
    Chrysopoeia.Parser.Samples.simple_overlapping(:html)
      |> Chrysopoeia.Parser.Floki.parse
      |> assert_eq Chrysopoeia.Parser.Samples.simple_overlapping(:parse_tree)
  end
end
