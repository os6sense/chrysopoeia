require Exmerl
require Floki 
require Eml

defmodule Chrysopoeia.Parser do
  use Behaviour
  defcallback parse(binary) :: List | Binary
end

defmodule Chrysopoeia.Parser.Eml do
  def parse(binary) do
    binary |> Eml.parse
  end
end

defmodule Chrysopoeia.Parser.Floki do
  def parse(binary) do
    binary |> Floki.parse
  end
end

defmodule Chrysopoeia.Parser.XML do
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
