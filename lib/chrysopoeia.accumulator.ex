
defmodule Chrysopoeia.Accumulator do
  @moduledoc ~S"""
    A simple wrapper around an accumulator to make using it more generic and 
    reliable.
  """
  require Logger

  def create, 
    do: [{:accumulator, []}, {:index, 0}]

  def reset_index(acc, val \\ 0),   
    do: Keyword.update(acc, :index, val, fn(_) -> 0 end)

  def increment_index(acc, t) when is_integer(t), 
    do: Keyword.update(acc, :index, 0, fn(n) -> n + t end)

  def update_accumulator(acc, t) when is_tuple(t), 
    do: Keyword.update(acc, :accumulator, [], fn(c) -> c ++ [t] end) 

  def update_accumulator([], t) when is_list(t), do: t
  def update_accumulator(acc, t) when is_list(t) do
    acc
     |> Keyword.update(:accumulator, [], fn(c) -> c ++ t[:accumulator] end)
     |> Keyword.update(:index, 0, fn(_) -> t[:index] end)
  end
end

