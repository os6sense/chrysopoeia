
defmodule Chrysopoeia.Parser.ParseTree do
  require Chrysopoeia.Parser.ParseTree.Walker, as: Walker

  defdelegate walk(t), to: Walker
  defdelegate walk(t, fns), to: Walker

  def find(pt = {_, _, _}, node) do
    IO.puts "FIND"

    return_node = fn(t = {e, a, c}, acc) ->
      if e == node do
        IO.puts "MATCH #{inspect e}"
        acc = acc ++ [t]
      end
      t
    end

    walk(pt, [return_node])
  end

  def delete do

  end

end
