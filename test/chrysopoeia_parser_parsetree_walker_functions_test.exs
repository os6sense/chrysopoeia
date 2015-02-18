defmodule Chrysopoeia.Parser.ParseTree.Walker.Functions.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right

  alias Chrysopoeia.Parser.ParseTree.Walker.Functions

  test "Orders function tupples to prescribed" do
    [{:insert, nil}, {:insert, nil}, {:transform, nil}, {:delete, nil}]
      |> Functions.order([:delete, :transform, :insert, :query])
      |> assert_eq [{:delete, nil}, {:transform, nil}, {:insert, nil}, {:insert, nil}]
  end

  test "Merges two accumulators" do
    a1 = [ {:accumulator, [{"list 1", 1, 1 }]}, {:index, {1, 1} }]
    a2 = [ {:accumulator, [{"list 2", 2, 2 }]}, {:index, {2, 2} }]

    IO.inspect Functions.update_accumulator(a1, a2)
    IO.inspect Functions.update_accumulator([], a2)

  end

end
