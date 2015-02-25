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

  # TODO: Bigone - the compiled function should return a tuple.
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
    #IO.inspect mfns
    #Enum.all?(mfns, fn (func) -> 

      ### TODO
      ### Insufficient to *exclude* matches based on the tree. Every enumeration should reduce the meta path
      ### since we are climbing the path tree
      #func.(e, a, meta) == true 
    #end)
    # This is the equivilent of Enum.all? but with an accumulator for the
    # meta data with an adjusted path
    # ************************a***************** 
    # why don't I just adjust the meta and return it in/from
    # the compiled function? doh!
    #########################################
    Logger.debug "------------------ NEW CSS MATCH ---------------------"
    Enum.reduce(selector_fns, {true, meta}, fn 
      (func, {all_true?, adjusted_meta}) ->
        # NOTE: I don't want to just adjust the meta, I want to remove 
        # all the enties upto and including the one that matched
        Logger.debug "#e:#{inspect e} a:#{inspect a} meta: #{inspect adjusted_meta}"
        if all_true? do
          {func.(e, a, adjusted_meta), adjust_meta_path(meta)}
        else
          {false, meta}
        end
    end) |> elem(0)
  end

  # Removes the first n entries from the path

  # Removes the first entry from the path
  defp adjust_meta_path(meta), 
    do: Keyword.update(meta, :path, [], &(adjust_path(&1) ))
  defp adjust_path([head | tail]), do: tail
  defp adjust_path([last]), do: []
  defp adjust_path(nil), do: nil


end
