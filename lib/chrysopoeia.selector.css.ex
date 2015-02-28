defmodule Chrysopoeia.Selector.CSS do

  require Logger
  alias Chrysopoeia.Selector.CSS.Parser, as: Parser
  alias Chrysopoeia.Selector.CSS.Compiler, as: Compiler

  @doc """
    Given a string e.g. "div span p", create a selector function for matching
    against the meta. The function should be a list of functions which can
    be applied (right to left?) to match a nodes e, a and meta
  """
  def create(str) do
    str
      |> Parser.create
      |> Compiler.compile
  end

  # TODO: Big one - the compiled function should return a tuple.
  #         true/false as to whether the match was successful
  #         the adjusted meta which would be just the meta on a simple
  #         selector, but would be the meta[:path] onwards from where
  #         the last match occured. 

  #        e.g. {true, meta}
  # 
  # Note that this is going to cause a LOT of tests to fail


  # each mfn is a css matching function - note that the order of functions is reversed
  # by the css parser - does that work?
  def match(e, a, meta, selector_fns) do
    Logger.debug "------------------ NEW CSS MATCH ---------------------"
    Enum.reduce(selector_fns, {true, meta}, fn 
      (func, {all_true?, adjusted_meta}) ->
        Logger.debug "#e:#{inspect e} a:#{inspect a} meta: #{inspect adjusted_meta}"
        if all_true? do
          func.(e, a, adjusted_meta)
        else
          {false, meta}
        end
    end) |> elem(0)
  end

  #Removes the first entry from the path
  #defp adjust_meta_path(meta), 
    #do: Keyword.update(meta, :path, [], &(adjust_path(&1) ))
  #defp adjust_path([head | tail]), do: tail
  #defp adjust_path([last]), do: []
  #defp adjust_path(nil), do: nil


end
