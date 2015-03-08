defmodule Chrysopoeia.Selector.CSS.Compiler__ipreceding.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  alias Chrysopoeia.Selector.CSS.Compiler, as: Compiler

  # e.g. div + p
  @simple_element %{"type" => "div", "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  # e.g. p[id]
  @simple_element_attribute %{"type" => "p", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  # e.g. p[id=lvl_1]
  @simple_element_attribute_value %{"type" => "p", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }

  # e.g. [id=lvl_1]
  @attribute_value        %{"type" => "", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }

  # e.g. [id]
  @attribute_only %{"type" => "", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  test "preceeding element is matched" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"div", []}, {"p", []} ], 2, 2 }}])
      |> elem(0) |> assert_eq true
  end

  test "matching of the first element doesnt crash" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"div", []}, {"p", []}], 1, 2 }}])
      |> elem(0) |> assert_eq false
  end

  test "simple element immediately preceding - at end should match" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"p", []}, {"div", []}, {"p", []} ], 3, 3 }}])
      |> elem(0) |> assert_eq true
  end

  test "simple element immediately preceding - should not match" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"p", []}, {"div", []}, {"p", []}], 2, 3 }}])
      |> elem(0) |> assert_eq false
  end

  test "simple element immediately preceding - should not match" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"div", []}, {"p", []}, {"p", []}], 3, 3 }}])
      |> elem(0) |> assert_eq false
  end

  test "attribute only immediately preceeding at start - should match" do
    fun = Compiler.compile_ipreceding_selector(@attribute_only)
    fun.("div", [], [{:siblings, {[{"p", [{"id", "jjk1"} ]}, {"div", []}, {"span", []}], 2, 3 }}])
      |> elem(0) |> assert_eq true
  end

  test "attribute only immediately preceeding at end - should match" do
    fun = Compiler.compile_ipreceding_selector(@attribute_only)
    fun.("p", [], [{:siblings, {[{"p", []}, {"span", [{"id", "jjk1"}]}, {"p", []}], 3, 3 }}])
      |> elem(0) |> assert_eq true
  end

  test "attribute only immediately preceeding - should fail" do
    fun = Compiler.compile_ipreceding_selector(@attribute_only)
    fun.("p", [], [{:siblings, {[{"p", [{"id", "1"} ]}, {"div", []}, {"span", []}], 3, 3 }}])
      |> elem(0) |> assert_eq false
  end
end
