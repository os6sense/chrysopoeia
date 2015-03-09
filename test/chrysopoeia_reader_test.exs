defmodule Chrysopoeia.Reader.Test do
  use ExUnit.Case

  import Mock

  test_with_mock "read with a https url returns a binary", HTTPotion,
      [get: fn(_url) -> "<html></html>" end] do
    assert Chrysopoeia.Reader.read("https://test.com") == "<html></html>"
  end

  test_with_mock "read with a http url returns a binary", HTTPotion,
      [get: fn(_url) -> "<html></html>" end] do
    assert Chrysopoeia.Reader.read("http://test.com") == "<html></html>"
  end

  test_with_mock "read with a file returns a binary", File,
      [read: fn(_path) -> {:ok, "<html></html>"} end] do
    assert Chrysopoeia.Reader.read("mocked_file.html") == "<html></html>"
  end
end
