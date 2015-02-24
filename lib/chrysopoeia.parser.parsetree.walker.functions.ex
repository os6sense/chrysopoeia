
defmodule Chrysopoeia.Parser.ParseTree.Walker.Functions do
  require Logger
  require Chrysopoeia.Accumulator, as: Accumulator
  require Chrysopoeia.Selector.CSS, as: CSS

  def function(:copy) do
      {:transform, fn
          (t = {e, a, c}, meta, acc) -> 
            Logger.debug "COPY: #{inspect e} #{inspect a} -- META: #{inspect meta}"
            {t, acc}
          end
      }
  end

  def function(:delete, selector_fn) do
    {:delete, fn
      (t = {e, a, _c}, meta, acc) -> 
         #Logger.debug "delete: #{inspect e} -- #{inspect name}"
         unless CSS.match(e, a, meta, selector_fn), do: {t, acc}, else: {{:delete, [], []}, acc}
      end
    }
  end

  def function(:find, selector_fn) do
      {:query, fn
        (t = {e, a, _c}, meta, acc) -> 

          #Logger.debug "find A: #{inspect t} -- #{inspect acc}"

          if CSS.match(e, a, meta, selector_fn),
            do: acc = Accumulator.update_accumulator(acc, t)

          #Logger.debug "find B: #{inspect t} -- #{inspect acc}"
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

