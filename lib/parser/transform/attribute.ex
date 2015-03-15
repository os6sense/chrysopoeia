
defmodule Chrysopoeia.Parser.Transform.Attribute do

  # Just copied the old code from transforms into here for now
  defmacro attribute_set(name, val) do
    quote do
    match_args = fn ({an, av})
    -> if an == unquote(name), do: {an, unquote(val)}, else: {an, av}
    end
    fn ({e, a, c}) -> {e, Enum.map(a, match_args), c} end
    end
  end

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

end

