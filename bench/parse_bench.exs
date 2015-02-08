defmodule Chrysopoeia.Parser.Benchmarks do
  use Benchfella

  # alias Chrysopoeia.Parser

  defp load__wikipedia_html() do
    {_, content} = File.read("./test/html_test_samples/parsing_wikipedia.html")
    content
  end

  defp load_simple_html() do
    "<html><head></head><body><p>hello</p></body></html>"
  end

  bench "Trane Parse - simple", [html: load_simple_html()] do
    html |> Chrysopoeia.Parser.Trane.parse
  end

  bench "Yaws Parse - simple", [html: load_simple_html()] do
    html |> Chrysopoeia.Parser.Yaws.parse
  end

  bench "Eml Parse - simple", [html: load_simple_html()] do
    html |> Chrysopoeia.Parser.Eml.parse
  end

  bench "Floki Parse - simple", [html: load_simple_html()] do
    html |> Chrysopoeia.Parser.Floki.parse
  end

  bench "Exmerl Parse - simple", [html: load_simple_html()] do
    html |> Chrysopoeia.Parser.XML.parse
  end

  bench "Trane Parse - wikipedia", [html: load__wikipedia_html()] do
    html |> Chrysopoeia.Parser.Trane.parse
  end

  bench "Eml Parse - wikipedia", [html: load__wikipedia_html()] do
    html |> Chrysopoeia.Parser.Eml.parse
  end

  bench "Floki Parse - wikipedia", [html: load__wikipedia_html()] do
    html |> Chrysopoeia.Parser.Floki.parse
  end

  bench "Yaws Parse - wikipedia", [html: load__wikipedia_html()] do
    html |> Chrysopoeia.Parser.Yaws.parse
  end

  #bench "Exmerl Parse - wikipedia", [html: load__wikipedia_html()] do
    #html |> Exmerl.parse
  #end

end
