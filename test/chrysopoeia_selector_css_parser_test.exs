

defmodule Chrysopoeia.Selector.CSS.Parser.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  alias Chrysopoeia.Selector.CSS.Parser, as: Parser

  def single_split(str, attr \\ ["type", "attr", "op", "value"]) do
    str |> Parser.split |> List.first |> Map.take(["type", "attr", "op", "value"]) 
  end

  test "#split - single element" do
    "p" 
      |> Parser.split 
      |> List.first 
      |> Map.take(["type"]) 
      |> assert_eq %{"type" => "p"}
  end

  test "#split - single element with id" do
    "p[id]" 
      |> Parser.split 
      |> List.first 
      |> Map.take(["type", "attr"]) 
      |> assert_eq %{"attr" => "id", "type" => "p"}
  end

  test "#split - single element with id and value" do
    "p[id=val]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "=", "value" => "val", "type" => "p"}
  end

  test "#split - attribute only with id and value" do
    "[id=val]"  
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "=", "value" => "val", "type" => ""}
  end

  test "#split - attribute only with id" do
    "[id]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "", "value" => "", "type" => ""}
  end

  test "#split - attribute only with ~= comparitor" do
    "[id~=val]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "~=", "value" => "val", "type" => ""}
  end

  test "#split - attribute only with $= comparitor" do
    "[id$=val]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "$=", "value" => "val", "type" => ""}
  end

  test "#split - attribute only with ^= comparitor" do
    "[id^=val]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "^=", "value" => "val", "type" => ""}
  end

  test "#split - attribute only with *= comparitor" do
    "[id*=val]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "*=", "value" => "val", "type" => ""}
  end

  test "#split - attribute only with |= comparitor" do
    "[id|=val]" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "|=", "value" => "val", "type" => ""}
  end

  test "#split - class selector" do
    ".aclass"
      |> single_split 
      |> assert_eq %{"attr" => "class", "op" => "=", "value" => "aclass", "type" => ""}
  end

  test "#split - id selector" do
    "#myid" 
      |> single_split 
      |> assert_eq %{"attr" => "id", "op" => "=", "value" => "myid", "type" => ""}
  end

  test "#split - single element, pseudo type" do
    "p:first-child" 
      |> Parser.split 
      |> List.first 
      |> Map.take(["type", "ptype", "pval"]) 
      |> assert_eq %{"ptype" => "first-child", "pval" => "", "type" => "p"}
  end

  test "#split - single element, pseudo type with value" do
    "p:first-child(5)" 
      |> Parser.split 
      |> List.first 
      |> Map.take(["type", "ptype", "pval"]) 
      |> assert_eq %{"ptype" => "first-child", "pval" => "5", "type" => "p"}
  end

  test "#split - multiple elements" do
    "p b" 
      |> Parser.split 
      |> Enum.map(&Map.take(&1, ["type"])) 
      |> assert_eq [%{"type" => "p"}, %{"type" => "b"}]
  end

  test "#split - multiple elements, attributes and values" do
    "p[id=id_1] .inner b[class=bold]" 
      |> Parser.split 
      |> Enum.map(&Map.take(&1, ["type", "attr", "value"])) 
      |> assert_eq [%{"attr" => "id", "type" => "p", "value" => "id_1"},
                    %{"attr" => "class", "type" => "", "value" => "inner"},
                    %{"attr" => "class", "type" => "b", "value" => "bold"}]
  end

   test "#split - multiple . and #" do
    "#id_1 .inner .bold" 
      |> Parser.split 
      |> Enum.map(&Map.take(&1, ["type", "attr", "value"])) 
      |> assert_eq [%{"attr" => "id", "type" => "", "value" => "id_1"},
                    %{"attr" => "class", "type" => "", "value" => "inner"},
                    %{"attr" => "class", "type" => "", "value" => "bold"}]
  end

  test "#split - multiple elements with comparitor" do
    "p > b" 
      |> Parser.split 
      |> assert_eq [%{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "p", "value" => ""}, 
                    ">",
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "b", "value" => ""}]
  end

end
