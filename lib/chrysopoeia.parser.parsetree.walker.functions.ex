
defmodule Chrysopoeia.Parser.ParseTree.Walker.Functions do
  require Logger
  require Chrysopoeia.Accumulator, as: Accumulator

  def function(:copy) do
      {:transform, fn
          (t = {e, a, c}, meta, acc) -> 
            Logger.debug "COPY: #{inspect e} #{inspect a} -- META: #{inspect meta}"
            {t, acc}
          end
      }
  end

  def function(:delete, name) do
    {:delete, fn
      (t = {e, _a, _c}, meta, acc) -> 
         Logger.debug "delete: #{inspect e} -- #{inspect name}"
         unless e == name, do: {t, acc}, else: {{:delete, [], []}, acc}
      end
    }
  end

  def function(:find, name) do
      {:query, fn
        (t = {e, _a, _c}, meta, acc) -> 

          Logger.debug "find A: #{inspect t} -- #{inspect acc}"

          if e == name, 
            do: acc = Accumulator.update_accumulator(acc, t)

          Logger.debug "find B: #{inspect t} -- #{inspect acc}"
          {t, acc}
        end
      }
  end


  @doc ~S"""
    Order the list of function tuples fns by the atom order in fns_order

  """
  @spec order(fns::List[Tuple], fns_order::List[Atom]) :: List
  def order(fns, fns_order \\ [:delete, :transform, :insert, :query]) do
    Enum.flat_map(fns_order, fn(key) -> Keyword.take(fns, [key]) end)
  end
end

