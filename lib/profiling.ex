
defmodule SampleRunner do
  import ExProf.Macro

  alias Chrysopoeia.Parser.ParseTree, as: ParseTree

  defp load_wikipedia_html() do
    {_, content} = File.read("./test/html_test_samples/parsing_wikipedia.html")

    content |> Chrysopoeia.Parser.Floki.parse
  end

  @doc "analyze with profile macro"
  def do_analyze do
    parsetree = load_wikipedia_html()
    profile do
      parsetree
        |> ParseTree.find("[id=Psycholinguistics]")
        |> elem(1)
    end
  end

  @doc "get analysis records and sum them up"
  def run do
    records = do_analyze
    total_percent = Enum.reduce(records, 0.0, &(&1.percent + &2))
    IO.inspect "total = #{total_percent}"
  end
end

