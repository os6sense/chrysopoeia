defmodule Chrysopoeia.CSS.Benchmarks do
  use Benchfella
  
  alias Chrysopoeia.Parser.ParseTree, as: ParseTree

  defp load_wikipedia_html() do
    {_, content} = File.read("./test/html_test_samples/parsing_wikipedia.html")

    content |> Chrysopoeia.Parser.Floki.parse
  end

  defp create_selector(sel \\ "h3 + p") do
    Chrysopoeia.Selector.CSS.create(sel)
  end

  bench "CSS find single element by id - wikipedia", [parse_tree: load_wikipedia_html()] do
    result = parse_tree
    #|> ParseTree.find("h3 + p")
      |> ParseTree.find("[id=Psycholinguistics]")
      |> elem(1)
  end

  bench "CSS find preceeding operatior - wikipedia", [parse_tree: load_wikipedia_html()] do
    result = parse_tree
      |> ParseTree.find("h3 + p")
      |> elem(1)
  end

  bench "CSS find preceeding operatior, compiled selector - wikipedia", 
    [parse_tree: load_wikipedia_html(), selector: create_selector("h3 + p")] do
    result = parse_tree
      |> ParseTree.find(selector)
      |> elem(1)
  end



end
