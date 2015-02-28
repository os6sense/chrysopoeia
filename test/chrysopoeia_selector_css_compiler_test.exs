
defmodule Chrysopoeia.Selector.CSS.Compiler.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right
  def assert_neq(left, right), do: assert left != right

  #alias Chrysopoeia.Selector.CSS.Parser, as: Parser
  alias Chrysopoeia.Selector.CSS.Compiler, as: Compiler

  # e.g. p
  @simple_element %{"type" => "p", "attr" => "", "op" => "", "value" => "", "ptype" => "", "pval" => "" }

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
  # We need some finely crafter meta

  # e.g. >
  @combinator ">"

  #test "combinator" do
    #Compiler.compile_selector(@combinator) 
      #|> assert_eq :combine
  #end

  test "simple element" do
    fun = Compiler.compile_selector(@simple_element) 
    fun.("p", [], nil)
      |> assert_eq {true, nil}

    fun.("a", [], nil)
      |> assert_eq {false, nil}
  end

  test "attribute only eq" do
    fun = Compiler.compile_selector(@attribute_only) 
    fun.("", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}

    fun.("", [{"nid", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "attribute value - eq" do
    fun = Compiler.compile_selector(@attribute_value_eq) 
    fun.("", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}
      
    fun.("", [{"id", "lvl_2"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "attribute value - hat ^" do
    fun = Compiler.compile_selector(@attribute_value_hat) 
    fun.("", [{"id", "lvl_2"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}
      
    fun.("", [{"id", "xlvl_2"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "attribute value - dollar $" do
    fun = Compiler.compile_selector(@attribute_value_dollar) 
    fun.("", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}
      
    fun.("", [{"id", "lvl_2"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "attribute value - star *" do
    fun = Compiler.compile_selector(@attribute_value_star) 
    fun.("", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}
      
    fun.("", [{"id", "l_2"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "attribute value - pipe |" do
    fun = Compiler.compile_selector(@attribute_value_pipe) 
    fun.("", [{"id", "lvl_2|lvl_1|"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}
      
    fun.("", [{"id", "lvl_2"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "simple_element_attribute" do
    fun = Compiler.compile_selector(@simple_element_attribute) 
    fun.("p", [{"id", "lvl_dontcare"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}

    fun.("a", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

  test "simple_element_attribute_value" do
    fun = Compiler.compile_selector(@simple_element_attribute_value) 
    fun.("p", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {true, nil}

    fun.("a", [{"id", "lvl_1"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}

    fun.("p", [{"id", "lvl_2"}, {"class", "indent"}], nil)
      |> assert_eq {false, nil}
  end

end

