
defmodule Chrysopoeia.Parser.ParseTree.Walker.Test do
  use ExUnit.Case

  import SaneAsserts

  alias Chrysopoeia.Parser.ParseTree.Walker, as: Walker
  alias Chrysopoeia.Parser.Samples, as: Sample

  def assert_walk_does_not_change(parse_tree), 
    do: parse_tree |> Walker.walk |> elem(0) |> assert_eq parse_tree

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

end

