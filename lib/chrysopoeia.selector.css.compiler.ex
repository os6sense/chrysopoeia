# TODO: Compiler has to add spacee (i.e. decendant operator)

# DONE E F        an F element descendant of an E element
# DONE  E > F     an F element child of an E element
# DONE E + F      an F element immediately preceded by an E element
# E ~ F           an F element preceded by an E element

defmodule Chrysopoeia.Selector.CSS.Compiler do

  require Logger
  import Chrysopoeia.Selector.CSS.Compiler.Macros

  # Takes the output of the CSS parser and compiles the map into functions for
  # matching
  def compile(map) when is_list(map) do
    map
      |> Enum.map_reduce(nil, fn 
           ("!", nil)  -> { nil, "!"}
           (">", nil)  -> { nil, ">"}
           ("+", nil)  -> { nil, "+"}
           ("~", nil)  -> { nil, "~"}
           (e, "!")    -> { compile_descendant_selector(e), nil}
           (e, ">")    -> { compile_child_selector(e), nil}
           (e, "+")    -> { compile_ipreceding_selector(e), nil}
           #(e, "~")    -> { compile_preceding_selector(e), nil}
           (e, nil)    -> { compile_selector(e), nil}
      end)
      |> elem(0)
      |> Enum.reject(fn (e) -> e == nil end)
  end

  def compile_descendant_selector(map), do: _compile_descendant_selector(map)
  def compile_child_selector(map), do: _compile_child_selector(map)
  def compile_selector( map ), do: _compile_selector(map)
  def compile_ipreceding_selector(map), do: _compile_ipreceding_selector(map)
  #def compile_preceding_selector(map), do: _compile_preceding_selector(map)

  # =========== PRIVATE

  defp test_with_op("=" , lval, value), do: lval == value
  defp test_with_op("^=", lval, value), do: String.starts_with?(lval, value)
  defp test_with_op("$=", lval, value), do: String.ends_with?(lval, value)
  defp test_with_op("*=", lval, value), do: String.contains?(lval, value)
  defp test_with_op("|=", lval, value), 
    do: String.starts_with?(lval, value <> "|")

  # Removes all path entries upto and including the one that matched.
  # meta = full meta keyword list
  # idx = the index before which elements should be discarded.
  defp adjust_path_meta(meta, idx, field) do
    #Logger.debug "ADJUSTING META (idx: #{idx}):  #{inspect meta} "
    Keyword.update(meta, field, [], &(Enum.slice(&1, idx, 9999) ))
    #Logger.debug "ADJUSTED META: #{inspect meta}"
    #meta
  end

  defp adjust_sibling_meta(meta, idx, false), do: meta
  defp adjust_sibling_meta(meta, idx, true) do
    IO.puts "#{inspect meta}"
    Keyword.update(meta, :siblings, {[], 0, 0}, &(_do_sibling_delete(&1, idx) ))
  end
  defp _do_sibling_delete({siblings, current, total}, idx) do
    {List.delete_at(siblings, idx), current - 1, total - 1}
  end


  # =======================================================================
  # ====================== IMMEDIATELY PRECEEDING =========================
  # =======================================================================
  # E + F - an F element immediately preceded by an E element

  # return true if the first element in the siblings matches the selector
  # value
  # Note that this implementation will only work for the LAST element in
  # the selector since parent elements in the path DO NOT include sibling 
  # information
  defp _compile_ipreceding_selector( cssmap_t(type) ) do
    ipreceding(e) do elem(e, 0) == type end
  end
  defp _compile_ipreceding_selector( cssmap_a(attr) ) do
    ipreceding(e) do has_attribute?(elem(e, 1), attr) end
  end
  defp _compile_ipreceding_selector( cssmap(attr, op, value) ) do
    ipreceding(e) do has_attribute_with_value?(elem(e, 1), attr, op, value) end
  end
  # :element_attribute
  defp _compile_ipreceding_selector( cssmap(type, attr) ) do
    ipreceding(e) do elem(e, 0) == type && has_attribute?(elem(e, 1), attr) end
  end
  # :element_attribute_value
  defp _compile_ipreceding_selector( css_map(type, attr, op, value) ) do
    ipreceding(e) do 
      elem(e, 0) == type 
      && has_attribute_with_value?(elem(e, 1), attr, op, value) 
    end
  end

  # =======================================================================
  # ============================= CHILD  ==================================
  # =======================================================================
  # E > F                   an F element child of an E element
  # return true if the first element in the path matches the selector value
  defp _compile_child_selector( cssmap_t(type) ) do
    child(e) do elem(e, 0) == type end
  end
  # :attribute_only
  defp _compile_child_selector( cssmap_a(attr) ) do
    child(e) do has_attribute?(elem(e, 1), attr) end
  end
  # :attribute_value
  defp _compile_child_selector( cssmap(attr, op, value) ) do
    child(e) do has_attribute_with_value?(elem(e, 1), attr, op, value) end
  end
  # :element_attribute
  defp _compile_child_selector( cssmap(type, attr) ) do
    child(e) do elem(e, 0) == type && has_attribute?(elem(e, 1), attr) end
  end
  # :element_attribute_value
  defp _compile_child_selector( css_map(type, attr, op, value) ) do
    child(e) do 
      elem(e, 0) == type 
      && has_attribute_with_value?(elem(e, 1), attr, op, value) 
    end
  end

  # =======================================================================
  # ========================== DESCENDANT  ================================
  # =======================================================================
  @doc """
    E F - an F element descendant of an E element
    return true if there is an element in the path matching the selector
    value
  """
  # element only
  defp _compile_descendant_selector( cssmap_t(type) ) do
    descendant(e) do elem(e, 0) == type end
  end
  # :attribute_only
  defp _compile_descendant_selector( cssmap_a(attr) ) do
    descendant(e) do has_attribute?(elem(e, 1), attr) end
  end
  # :attribute_value
  defp _compile_descendant_selector( cssmap(attr, op, value) ) do
    descendant(e) do has_attribute_with_value?(elem(e, 1), attr, op, value) end
  end
  # :element_attribute
  defp _compile_descendant_selector( cssmap(type, attr) ) do
    descendant(e) do elem(e, 0) == type && has_attribute?(elem(e, 1), attr) end
  end
  # :element_attribute_value
  defp _compile_descendant_selector( css_map(type, attr, op, value) ) do
    descendant(e) do 
      elem(e, 0) == type 
      && has_attribute_with_value?(elem(e, 1), attr, op, value) 
    end
  end

  # ==========================================================================
  # ========================== SIMPLE SINGLE  ================================
  # ==========================================================================
  # Simplist case: matches the attribute itself. Used for single element
  # selectors e.g. "p"

  # :simple_element
  defp _compile_selector( cssmap_t(type) ) do
    single(e, a) do element_matches_type?(e, type) end
  end
  # :attribute_only
  defp _compile_selector( cssmap_a(attr) ) do
    single(e,a) do has_attribute?(a, attr) end
  end
  # :attribute_value
  defp _compile_selector( cssmap(attr, op, value) ) do
    single(e, a) do has_attribute_with_value?(a, attr, op, value) end
  end
  # :simple_element_attribute
  defp _compile_selector( cssmap(type, attr) ) do
    single(e, a) do 
      element_matches_type?(e, type) && has_attribute?(a, attr)
    end
  end
  # :simple_element_attribute_value
  defp _compile_selector( cssmap(type, attr, op, value) ) do
    single(e, a) do 
      element_matches_type?(e, type) 
                        && has_attribute_with_value?(a, attr, op, value)
    end
  end

  def compile_selector(%{"type" => type, "attr" => attr, "op" => op, 
                          "value" => value, "ptype" => ptype, "pval" => pval }) do
    # fail, not yet implemented  
  end
  
end
