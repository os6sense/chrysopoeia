
defmodule Chrysopoeia.Accumulator.Test do
  use ExUnit.Case

  @a1 [ {:accumulator, [{"list 1", 1, 1 }]}, {:index, {1, 1} }]
  @a2 [ {:accumulator, [{"list 2", 2, 2 }]}, {:index, {2, 2} }]

  def assert_eq(left, right), do: assert left == right

  require Chrysopoeia.Accumulator, as: Accumulator

  test "#create Creates an empty Accumulator" do
    Accumulator.create |> assert_eq [accumulator: [], index: 0]
  end

  test "Adds a list to the accumulator" do
    Accumulator.update_accumulator(@a1, @a2) 
      |> assert_eq [accumulator: [{"list 1", 1, 1}, {"list 2", 2, 2}], index: {2, 2}]
  end

  test "creates an accumulator if the accumulator is an empty list" do
    Accumulator.update_accumulator([], @a2) 
      |> assert_eq [accumulator: [{"list 2", 2, 2}], index: {2, 2}]
  end
end
