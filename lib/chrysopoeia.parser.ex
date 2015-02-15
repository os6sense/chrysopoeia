
defmodule Chrysopoeia.Parser do
  use Behaviour
  defcallback parse(binary) :: List | Binary
end

defmodule Chrysopoeia.Parser.Eml do
  require Eml

  def parse(binary) do
    binary |> Eml.parse
  end
end

defmodule Chrysopoeia.Parser.Floki do
  require Floki 

  def parse(binary) do
    binary |> Floki.parse
  end

  def to_zipper(parse_tree) do

  end
end

defmodule Chrysopoeia.Parser.XML do
  require Exmerl

  def parse(binary) do
    binary |> Exmerl.parse
  end
end

defmodule Chrysopoeia.Parser.Yaws do
  def parse(binary) do
    binary |> :erlang.binary_to_list |> :yaws_html.h2e 
  end
end

defmodule Chrysopoeia.Parser.Trane do
  def parse(binary) do
    binary |> :trane.sax(fn(t,a)-> a++[t] end, [])
  end
end
