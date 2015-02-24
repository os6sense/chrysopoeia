defmodule Chrysopoeia.Selector.CSS do

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

  # each mfn is a css matching function - note that I may need to reverse the order of ... something,
  # somewhere yet.
  def match(e, a, meta, mfns) do
    Enum.all?(mfns, fn (func) -> func.(e, a, meta) == true end)

    
    # so say I have the above data to work with, I'm the b element within a p
    # so take the simplist case
    #List.last(mfns).(e, a, meta) # call the last match function 
                                 # which is, e == "b"
                                 # its true so we'd return true

    # So harder, lets say we have "span p b" as our selector
    #List.last(mfns).(e, a, meta) # call the last match function 
                                 # which is, e == "b"
                                 # its true so we do the next one using the
                                 # next value in the path
    #List.last(mfns, -1).(List.last(meta[:path], -1), those_args, meta)
                                 # which is e == p

    # So our starting point is that the e, a arguments passed into the compiled
    # selector function may contain either the values of the current node
    # OR those of the path
  end
end
