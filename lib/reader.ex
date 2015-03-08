
defmodule Chrysopoeia.Reader do
  @moduledoc
  """
    Given either a path or a URL the Reader will read the file and return
    a binary 
  """
  def read("https://" <> url), do: url |> HTTPotion.get
  def read("http://" <> url), do: url |> HTTPotion.get
  def read(path), do: path |> File.read
end
