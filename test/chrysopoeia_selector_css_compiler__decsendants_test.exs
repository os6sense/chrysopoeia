defmodule Chrysopoeia.Selector.CSS.Compiler__descendants.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  #alias Chrysopoeia.Selector.CSS.Parser, as: Parser
  alias Chrysopoeia.Selector.CSS.Compiler, as: Compiler

  # e.g. p
  @simple_element_descendant [%{"type" => "div", "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" },
                              ">",
                              %{"type" => "p", "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" }]

  @simple_element %{"type" => "div", "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  #@attribute_only %{"type" => "", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }
  # e.g. p[id]
  @simple_element_attribute %{"type" => "p", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  # e.g. p[id=lvl_1]
  @simple_element_attribute_value %{"type" => "p", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }

  # e.g. [id=lvl_1]
  @attribute_value        %{"type" => "", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }
  @attribute_value_eq     @attribute_value # %{"type" => "", "attr" => "id", "op" => "=", "value" => "lvl_1", "ptype" => "", "pval" => "" }
  @attribute_value_hat    %{"type" => "", "attr" => "id", "op" => "^=", "value" => "lvl", "ptype" => "", "pval" => "" }
  @attribute_value_dollar %{"type" => "", "attr" => "id", "op" => "$=", "value" => "l_1", "ptype" => "", "pval" => "" }
  @attribute_value_star   %{"type" => "", "attr" => "id", "op" => "*=", "value" => "vl", "ptype" => "", "pval" => "" }
  @attribute_value_pipe   %{"type" => "", "attr" => "id", "op" => "|=", "value" => "lvl_2", "ptype" => "", "pval" => "" }

  # e.g. [id]
  @attribute_only %{"type" => "", "attr" => "id", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

  test "simple element" do
    fun = Compiler.compile_descendant_selector(@simple_element) 
    fun.("p", [], %{:path => [{"div", []}]})
      |> assert_eq true

    fun.("p", [], %{:path => [{"div", []}, {"span", []}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"span", []}]})
      |> assert_eq false
  end

  test "attribute only" do
    fun = Compiler.compile_descendant_selector(@attribute_only)
    fun.("p", [], %{:path => [{"div", [{"id", "blah"}]}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"div", []}, {"span", [{"id", "blah"}]}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"span", [{"idi", ""}]}]})
      |> assert_eq false
  end

  test "attribute value" do
    fun = Compiler.compile_descendant_selector(@attribute_value)
    fun.("p", [], %{:path => [{"div", [{"id", "lvl_1"}]}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"div", []}, {"span", [{"id", "lvl_1"}]}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"div", [{"id", "lvl_2"}]}]})
      |> assert_eq false
  end
  
  test "element attribute " do
    fun = Compiler.compile_descendant_selector(@simple_element_attribute)
    fun.("p", [], %{:path => [{"p", [{"id", "lvl_1"}]}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"p", []}, {"p", [{"id", "lvl_1"}]}] })
      |> assert_eq true

    fun.("p", [], %{:path => [{"p", []}, {"span", [{"id", "lvl_1"}]}] })
      |> assert_eq false

    fun.("p", [], %{:path => [{"div", [{"id", "lvl_2"}]}]})
      |> assert_eq false
  end

end
