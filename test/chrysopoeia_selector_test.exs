
defmodule Samples.ParseTree do
  def simple do
    [{"html", [], 
        [{"head", [], []}, {"body", [], 
            [{"p", [], ["Test"]}, {"p", [{"class", "tc"}], ["test 2"]}]}]}]
  end
end

defmodule Chrysopoeia.Parser.ParseTree.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  test "walk" do
    Samples.ParseTree.simple
      |> Chrysopoeia.Parser.ParseTree.walk( fn({e, a, c}) -> true end, 
                                        fn({e, a, c}) -> {e, a, c} end)
      |> assert_eq ["html", "head", "body", "p", "p"]
  end
end

defmodule Chrysopoeia.Parser.Transform.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  test "transform" do
    Samples.ParseTree.simple
      |> Chrysopoeia.Parser.Transform.transform( fn({e, a, c}) -> e == "p" end, 
                                                 fn({e, a, c}) -> {e, a, String.upcase List.first c} end)
      |> assert_eq ["html", "head", "body", "p", "p"]
  end
end
