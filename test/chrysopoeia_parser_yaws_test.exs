
#defmodule Chrysopoeia.Parser.Yaws.Test do
  #use ExUnit.Case

  #def assert_eq(left, right) do
    #assert left == right
  #end

  #test"parses well formed html" do
     #Chrysopoeia.Parser.Samples.simple
      #|> Chrysopoeia.Parser.Yaws.parse
      #|> assert_eq [{:html, [], [{:head, [], []}, {:body, [], [{:p, []}, 'Test']}]}]
  #end

  #test"parses malformed html with closing tag missing" do
     #Chrysopoeia.Parser.Samples.simple_sans_closing
      #|> Chrysopoeia.Parser.Yaws.parse
      #|> assert_eq {"html", [], [{"head", [], []}, {"body", [], [{"p", [], [{"i", [], ["Test"]}]}]}]}
  #end

  #test"parses malformed html with closing tag overlapping" do
     #Chrysopoeia.Parser.Samples.simple_overlapping
      #|> Chrysopoeia.Parser.Yaws.parse
      #|> assert_eq {"html", [], [{"head", [], []}, {"body", [], [{"p", [], [{"i", [], ["Test"]}]}]}]}
  #end
#end
