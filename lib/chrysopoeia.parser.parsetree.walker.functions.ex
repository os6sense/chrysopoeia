
defmodule Chrysopoeia.Parser.ParseTree.Walker.Functions do
  require Logger

  #defmacro function(:copy) do
    #quote do
      #{:transform, fn
          #(t, a) -> 
            #Logger.debug "copy: #{inspect t} -- #{inspect a}"
            #{t, a}
          #end
      #}
    #end
  #end

  def function(:copy) do
      {:transform, fn
          (t, a) -> 
            Logger.debug "copy: #{inspect t} -- #{inspect a}"
            {t, a}
          end
      }
  end

  #defmacro function(:delete, name) do
    #quote do
      #{:delete, fn
        #(t = {e, a, c}, acc) -> 
           #Logger.debug "delete: #{inspect e} -- #{inspect unquote(name)}"
           #unless e == unquote(name), do: {t, acc}, else: {{:delete, [], []}, acc}
        #end
      #}
    #end
  #end
  
  def function(:delete, name) do
    {:delete, fn
      (t = {e, a, c}, acc) -> 
         Logger.debug "delete: #{inspect e} -- #{inspect name}"
         unless e == name, do: {t, acc}, else: {{:delete, [], []}, acc}
      end
    }
  end


  #defmacro function(:find, name) do
    #quote do
      #{:query, fn
        #(t = {e, a, c}, acc) -> 
          #Logger.debug "find A: #{inspect t} -- #{inspect acc}"
          #if e == unquote(name) do
            #acc = acc ++ [t]
          #end

          #Logger.debug "find B: #{inspect t} -- #{inspect acc}"
          #{t, acc}
        #end
      #}
    #end
  #end

  def function(:find, name) do
      {:query, fn
        (t = {e, a, c}, acc) -> 
          Logger.debug "find A: #{inspect t} -- #{inspect acc}"
          if e == name do
            #acc = acc ++ [t]
            acc = update_accumulator(acc, t)
          end

          Logger.debug "find B: #{inspect t} -- #{inspect acc}"
          {t, acc}
        end
      }
  end

  def update_accumulator(acc, t) when is_tuple(t) do
    Keyword.update(acc, :accumulator, [t], fn(c) -> c ++ t end) 
  end

  #def update_accumulator(acc, t) when is_integer(t) do
    #Keyword.update(acc, :index, 0, fn(_) -> t end)
  #end

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

