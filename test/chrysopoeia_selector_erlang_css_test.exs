
defmodule Chrysopoeia.Selector.CSS.Erlang.Test do
  use ExUnit.Case

  import SaneAsserts
  #def assert_eq(left, right), do: assert left == right
  #def assert_neq(left, right), do: assert left != right

  alias Chrysopoeia.Parser.Samples, as: Sample

  alias Chrysopoeia.Selector.Erlang.CSS, as: CSS


  #test "select_combinators" do
    #Sample.simple(:parse_tree) 
      #|> :erlangcss.select("p")
      #|> assert_eq ""
  #end
end

