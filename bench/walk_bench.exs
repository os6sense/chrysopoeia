defmodule Chrysopoeia.Walker.Benchmarks do
  use Benchfella

  alias Chrysopoeia.Parser.ParseTree.Walker, as: Walker
  alias Chrysopoeia.Parser.ParseTree, as: ParseTree

  defp load_wikipedia_html() do
    {_, content} = File.read("./test/html_test_samples/parsing_wikipedia.html")
    content
  end

  bench "Walker - parse only, wikipedia", [html: load_wikipedia_html()] do
    html 
      |> Chrysopoeia.Parser.Floki.parse
  end


  bench "Walker Walk - wikipedia", [html: load_wikipedia_html()] do
    html 
      |> Chrysopoeia.Parser.Floki.parse
      |> Walker.walk 
      |> elem(0) 
  end

  bench "Walker Walk+to_html - wikipedia", [html: load_wikipedia_html()] do
    html 
      |> Chrysopoeia.Parser.Floki.parse
      |> Walker.walk 
      |> elem(0) 
      |> ParseTree.to_html
  end
end

