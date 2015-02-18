
defmodule Chrysopoeia.Parser.ParseTree.Walker.Functions do
  require Logger

  def function(:copy) do
      {:transform, fn
          (t, a) -> 
            Logger.debug "copy: #{inspect t} -- #{inspect a}"
            {t, a}
          end
      }
  end

  def function(:delete, name) do
    {:delete, fn
      (t = {e, a, c}, acc) -> 
         Logger.debug "delete: #{inspect e} -- #{inspect name}"
         unless e == name, do: {t, acc}, else: {{:delete, [], []}, acc}
      end
    }
  end

  def function(:find, name) do
      {:query, fn
        (t = {e, a, c}, acc) -> 
          Logger.debug "find A: #{inspect t} -- #{inspect acc}"
          if e == name do
            acc = update_accumulator(acc, t)
          end

          Logger.debug "find B: #{inspect t} -- #{inspect acc}"
          {t, acc}
        end
      }
  end


  # We have a little accumulator module here boys and girls!
  def reset_index(acc, 0) do
    Keyword.update(acc, :index, 0, fn(n) -> 0 end)
  end

  def increment_index(acc, t) when is_integer(t) do
    Keyword.update(acc, :index, 0, fn(n) -> n + t end)
  end

  def update_accumulator(acc, t) when is_tuple(t) do
    Keyword.update(acc, :accumulator, [], fn(c) -> c ++ [t] end) 
  end
  def update_accumulator([], t) when is_list(t), do: t
  def update_accumulator(acc, t) when is_list(t) do
    acc
     |> Keyword.update(:accumulator, [], fn(c) -> c ++ t[:accumulator] end)
     |> Keyword.update(:index, 0, fn(c) -> t[:index] end)
  end

  @doc ~S"""
    Order the list of function tuples fns by the atom order in fns_order

  """
  @spec order(fns::List[Tuple], fns_order::List[Atom]) :: List
  def order(fns, fns_order \\ [:delete, :transform, :insert, :query]) do
    Enum.flat_map(fns_order, fn(key) -> Keyword.take(fns, [key]) end)
  end
end

