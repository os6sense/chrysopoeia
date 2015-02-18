defmodule Chrysopoeia.Parser.ParseTree.Walker.Functions.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right

  alias Chrysopoeia.Parser.ParseTree.Walker.Functions

  test "Orders function tupples to prescribed" do
    [{:insert, nil}, {:insert, nil}, {:transform, nil}, {:delete, nil}]
      |> Functions.order([:delete, :transform, :insert, :query])
      |> assert_eq [{:delete, nil}, {:transform, nil}, {:insert, nil}, {:insert, nil}]
  end
end
