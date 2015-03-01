defmodule Chrysopoeia.CSS.Benchmarks do
  use Benchfella
  
  alias Chrysopoeia.Parser.ParseTree, as: ParseTree
  defp load_wikipedia_html() do
    {_, content} = File.read("./test/html_test_samples/parsing_wikipedia.html")

    content |> Chrysopoeia.Parser.Floki.parse
  end

  bench "CSS find - wikipedia", [parse_tree: load_wikipedia_html()] do
    result = parse_tree
      |> ParseTree.find("h3 + p")
      #|> ParseTree.find("[id=Psycholinguistics]")
      |> elem(1)

    #IO.puts "-----------------------------"
    #IO.inspect result
    #IO.puts "-----------------------------"
  end

end
