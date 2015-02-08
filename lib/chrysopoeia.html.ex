
# Unused, experiment
defmodule Chrysopoeia.HTML do

  defmacro defhtml(name, html) do
    html = Keyword.get(html, :do, nil)
    quote do
      def unquote(name)do
        unquote(html)
        #Macro.escape(html)
      end
    end
  end
end
