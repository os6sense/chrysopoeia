defmodule Chrysopoeia.Selector.CSS.Compiler__child.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  alias Chrysopoeia.Selector.CSS.Compiler, as: Compiler

  # e.g. div > p
  @simple_element %{"type" => "div", "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  # e.g. p[id]
  @simple_element_attribute %{"type" => "p", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  # e.g. p[id=lvl_1]
  @simple_element_attribute_value %{"type" => "p", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }

  # e.g. [id=lvl_1]
  @attribute_value        %{"type" => "", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }

  # e.g. [id]
  @attribute_only %{"type" => "", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  test "simple element" do
    fun = Compiler.compile_child_selector(@simple_element) 
    fun.("p", [], [{ :path, [{"div", []}] }])
      |> elem(0) |> assert_eq true

    fun.("p", [], [ {:path,  [{"div", []}, {"span", []}] }])
      |> elem(0) |> assert_eq true

    fun.("p", [], [ {:path,  [{"span", []}, {"div", []}] }])
      |> elem(0) |> assert_eq false

    fun.("p", [], [{:path, [{"span", []}] }])
      |> elem(0) |> assert_eq false
  end

  test "attribute only" do
    fun = Compiler.compile_child_selector(@attribute_only)
    fun.("p", [], [{:path, [{"div", [{"id", "blah"}]}] }])
      |> elem(0) |> assert_eq true

    fun.("p", [], [{:path, [{"div", []}, {"span", [{"id", "blah"}]}] }])
      |> elem(0) |> assert_eq false

    fun.("p", [], [{:path, [{"span", [{"idi", ""}]}]} ])
      |> elem(0) |> assert_eq false
  end

  test "attribute value" do
    fun = Compiler.compile_child_selector(@attribute_value)
    fun.("p", [], [{:path, [{"div", [{"id", "lvl_1"}]}] }])
      |> elem(0) |> assert_eq true

    fun.("p", [], [{:path, [{"div", []}, {"span", [{"id", "lvl_1"}]}] }])
      |> elem(0) |> assert_eq false

    fun.("p", [], [{:path, [{"div", [{"id", "lvl_2"}]}]}])
      |> elem(0) |> assert_eq false
  end
  
  test "element attribute " do
    fun = Compiler.compile_child_selector(@simple_element_attribute)
    fun.("p", [], [{:path, [{"p", [{"id", "lvl_1"}]}] }])
      |> elem(0) |> assert_eq true

    fun.("p", [], [{:path, [{"p", []}, {"p", [{"id", "lvl_1"}]}] }])
      |> elem(0) |> assert_eq false

    fun.("p", [], [{:path, [{"p", []}, {"span", [{"id", "lvl_1"}]}] }])
      |> elem(0) |> assert_eq false

    fun.("p", [], [{:path, [{"div", [{"id", "lvl_2"}]}]}])
      |> elem(0) |> assert_eq false
  end

end
