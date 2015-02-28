defmodule Chrysopoeia.Selector.CSS.Compiler__iprededing.Test do
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

  test "simple element preceding - should match" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"div", []} ], 1, 1 }}])
      |> elem(0) |> assert_eq true

    fun.("p", [], [{:siblings, {[{"div", []}, {"span", []}], 1, 2 }}])
      |> elem(0) |> assert_eq true

    fun.("p", [], [{:siblings, {[{"p", []}, {"span", []}, {"div", []} ], 3, 3 }}])
      |> elem(0) |> assert_eq true
  end

  test "simple element preceding - should not match" do
    fun = Compiler.compile_ipreceding_selector(@simple_element) 
    fun.("p", [], [{:siblings, {[{"p", []}, {"div", []}, {"span", []}], 3, 3 }}])
      |> elem(0) |> assert_eq false

    fun.("p", [], [{:siblings, {[{"div", []}, {"span", []}], 2, 2 }}])
      |> elem(0) |> assert_eq false
  end

  test "attribute only preceeding - should match" do
    fun = Compiler.compile_ipreceding_selector(@attribute_only)
    fun.("p", [], [{:siblings, {[{"p", [{"id", "jjk1"} ]}, {"div", []}, {"span", []}], 1, 3 }}])
      |> elem(0) |> assert_eq true

    fun.("p", [], [{:siblings, {[{"p", []}, {"div", []}, {"span", [{"id", "jjk1"}  ]}], 3, 3 }}])
      |> elem(0) |> assert_eq true
  end

  test "attribute only preceeding - should fail" do
    fun = Compiler.compile_ipreceding_selector(@attribute_only)
    fun.("p", [], [{:siblings, {[{"p", [{"id", "1"} ]}, {"div", []}, {"span", []}], 2, 3 }}])
      |> elem(0) |> assert_eq false
  end

  #test "attribute value" do
    #fun = Compiler.compile_child_selector(@attribute_value)
    #fun.("p", [], [{:path, [{"div", [{"id", "lvl_1"}]}] }])
      #|> elem(0) |> assert_eq true

    #fun.("p", [], [{:path, [{"div", []}, {"span", [{"id", "lvl_1"}]}] }])
      #|> elem(0) |> assert_eq false

    #fun.("p", [], [{:path, [{"div", [{"id", "lvl_2"}]}]}])
      #|> elem(0) |> assert_eq false
  #end
  
  #test "element attribute " do
    #fun = Compiler.compile_child_selector(@simple_element_attribute)
    #fun.("p", [], [{:path, [{"p", [{"id", "lvl_1"}]}] }])
      #|> elem(0) |> assert_eq true

    #fun.("p", [], [{:path, [{"p", []}, {"p", [{"id", "lvl_1"}]}] }])
      #|> elem(0) |> assert_eq false

    #fun.("p", [], [{:path, [{"p", []}, {"span", [{"id", "lvl_1"}]}] }])
      #|> elem(0) |> assert_eq false

    #fun.("p", [], [{:path, [{"div", [{"id", "lvl_2"}]}]}])
      #|> elem(0) |> assert_eq false
  #end

end
