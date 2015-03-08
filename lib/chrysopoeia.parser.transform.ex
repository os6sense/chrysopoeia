defmodule Chrysopoeia.Parser.Transform do
  @moduledoc 
  """
  Methods for transforming the parsetree
  """
  require Chrysopoeia.Parser.ParseTree, as: PT
  
  alias Chrysopoeia.Selector.CSS, as: CSS

  def transform(t = {_, _, _}, fns) do
    PT.walk(t, fns)
  end

  defmacro attribute_set(name, val) do
    quote do
      match_args = fn ({an, av}) 
        -> if an == unquote(name), do: {an, unquote(val)}, else: {an, av} 
      end
      fn ({e, a, c}) -> {e, Enum.map(a, match_args), c} end
    end
  end

  @doc ~S"""
    Creates a new transform

    selector, block
  """
  defmacro create(selector, do: blk) do
    quote do
      fn (t = {_, _, _}, acc) 
        -> if CSS.match(t, unquote(selector)), do: unquote(blk).(t), else: t
      end
    end
  end

  def attribute(selector, attribute, new_value) do
    create(selector) do
      attribute_set(attribute, new_value)
    end
  end
  # ========= ABOVE IS PROTOTYPING CODE

  defmacro deftransform(name, do: body) do
    quote do
      # deftransforms - adds an init method
      #def init(source_file \\ unquote(@source)) do
      def init(source_file) do
        Chrysopoeia.Reader.read(source_file) 
        #   |> Chrysopoeia.Template.store
      end

      # another useful macro might be the transform order allowing it to be 
      # overridden/changed.
      def transform_order do
        [:deletes, :text_and_arguments, :nodes, :inserts]
      end
    end
  end

  defmacro extract(id, params, do: body) do
    quote do 
      IO.puts "extract"
    end
  end

  defmacro replace_text(id, do: body) do
  end

  defmacro insert_text(id, do: body) do
  end

  defmacro replace_attribute(id, params, do: body) do
    quote do
    end
  end

  # Node based functions
  defmacro replace(id, params, do: body) do
  end

  defmacro insert(id, params, do: body) do
  end

  defmacro append(id, params, do: body) do
  end



end


