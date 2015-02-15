
defmodule Chrysopoeia.Parser.Floki.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right

  alias Chrysopoeia.Parser.Floki, as: Floki
  alias Chrysopoeia.Parser.Samples, as: Samples

  test "parses well formed html" do
    Samples.simple(:html)
      |> Floki.parse
      |> assert_eq Samples.simple(:parse_tree) 
  end

  test"parses malformed html with closing tag missing" do
    Samples.simple_sans_closing(:html)
      |> Floki.parse
      |> assert_eq Samples.simple_sans_closing(:parse_tree)
  end

  test"parses malformed html with closing tag overlapping" do
    Samples.simple_overlapping(:html)
      |> Floki.parse
      |> assert_eq Samples.simple_overlapping(:parse_tree)
  end
end
