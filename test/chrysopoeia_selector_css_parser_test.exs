

defmodule Chrysopoeia.Selector.CSS.Parser.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  alias Chrysopoeia.Selector.CSS.Parser, as: Parser

  def create_single(str, attr \\ ["type", "attr", "op", "value"]) do
    str |> Parser.create |> List.first |> Map.take(["type", "attr", "op", "value"]) 
  end

  test "#create - single element" do
    "p" 
      |> Parser.create 
      |> List.first 
      |> Map.take(["type"]) 
      |> assert_eq %{"type" => "p"}
  end

  test "#create - single element with id" do
    "p[id]" 
      |> Parser.create 
      |> List.first 
      |> Map.take(["type", "attr"]) 
      |> assert_eq %{"attr" => "id", "type" => "p"}
  end

  test "#create - single element with id and value" do
    "p[id=val]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "=", "value" => "val", "type" => "p"}
  end

  test "#create - attribute only with id and value" do
    "[id=val]"  
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "=", "value" => "val", "type" => ""}
  end

  test "#create - attribute only with id" do
    "[id]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "", "value" => "", "type" => ""}
  end

  test "#create - attribute only with ~= comparitor" do
    "[id~=val]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "~=", "value" => "val", "type" => ""}
  end

  test "#create - attribute only with $= comparitor" do
    "[id$=val]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "$=", "value" => "val", "type" => ""}
  end

  test "#create - attribute only with ^= comparitor" do
    "[id^=val]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "^=", "value" => "val", "type" => ""}
  end

  test "#create - attribute only with *= comparitor" do
    "[id*=val]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "*=", "value" => "val", "type" => ""}
  end

  test "#create - attribute only with |= comparitor" do
    "[id|=val]" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "|=", "value" => "val", "type" => ""}
  end

  test "#create - class selector" do
    ".aclass"
      |> create_single 
      |> assert_eq %{"attr" => "class", "op" => "=", "value" => "aclass", "type" => ""}
  end

  test "#create - id selector" do
    "#myid" 
      |> create_single 
      |> assert_eq %{"attr" => "id", "op" => "=", "value" => "myid", "type" => ""}
  end

  test "#create - single element, pseudo type" do
    "p:first-child" 
      |> Parser.create 
      |> List.first 
      |> Map.take(["type", "ptype", "pval"]) 
      |> assert_eq %{"ptype" => "first-child", "pval" => "", "type" => "p"}
  end

  test "#create - single element, pseudo type with value" do
    "p:first-child(5)" 
      |> Parser.create 
      |> List.first 
      |> Map.take(["type", "ptype", "pval"]) 
      |> assert_eq %{"ptype" => "first-child", "pval" => "5", "type" => "p"}
  end

  test "#create - multiple elements" do
    "p b" 
      |> Parser.create 
      |> assert_eq  [%{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "b", "value" => ""}, 
                     "!", 
                     %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "p", "value" => ""}]
  end

  test "#create - multiple elements, attributes and values" do
    "p[id=id_1] .inner b[class=bold]" 
      |> Parser.create 
      |> assert_eq [%{"attr" => "class", "type" => "b", "value" => "bold", "op" => "=", "ptype" => "", "pval" => ""},
                    "!",
                    %{"attr" => "class", "type" => "", "value" => "inner", "op" => "=", "ptype" => "", "pval" => ""},
                    "!",
                    %{"attr" => "id", "type" => "p", "value" => "id_1", "op" => "=", "ptype" => "", "pval" => ""}]
                    
  end

  test "#create - multiple . and #" do
    "#id_1 .inner .bold" 
      |> Parser.create 
      |> assert_eq [%{"attr" => "class", "type" => "", "value" => "bold", "op" => "=", "ptype" => "", "pval" => ""},
                    "!",
                    %{"attr" => "class", "type" => "", "value" => "inner", "op" => "=", "ptype" => "", "pval" => ""},
                    "!",
                    %{"attr" => "id", "type" => "", "value" => "id_1", "op" => "=", "ptype" => "", "pval" => ""}]
                    
  end

  test "#create - multiple elements with comparitor" do
    "p > b" 
      |> Parser.create 
      |> assert_eq [%{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "b", "value" => ""},
                    ">",
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "p", "value" => ""}]
  end

  test "create - adds a descendant operator" do
    IO.puts "p b > c"
    "p b > c" 
      |> Parser.create
      |> assert_eq [%{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "c", "value" => ""}, 
                    ">",
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "b", "value" => ""},
                    "!",
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "p", "value" => ""}]
  end

  test "create - complex - makes sense" do
    "span > p > b + em"
      |> Parser.create
      |> assert_eq [%{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "em", "value" => ""}, "+", 
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "b", "value" => ""}, ">",
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "p", "value" => ""}, ">", 
                    %{"attr" => "", "op" => "", "ptype" => "", "pval" => "", "type" => "span", "value" => ""}]
  end
end
