
# Concentrating on F~oki and YAML
defmodule Chrysopoeia.Parser.Samples do
  def simple do
    "<html><head></head><body><p>Test</p><p class=\"tc\">test 2</p></body></html>"
  end

  def simple_real do
    """
<form action="/posts" method="POST">
  <input type="hidden" name="_csrf_token" value="RM8QG0hNbG71/b2nhPSB/qdDjX8/0LUQzTRDzCK81TM=">
  
    <div class="form-group">
      <label for="resource_post_body">post_body</label>
      <input type="text" class="form-control" name="resource[post_body]"
             id="resource_post_body" value="" >
    </div>
  
    <div class="form-group">
      <label for="resource_post_date">post_date</label>
      <input type="text" class="form-control" name="resource[post_date]"
             id="resource_post_date" value="" >
    </div>
  
    <div class="form-group">
      <label for="resource_post_title">post_title</label>
      <input type="text" class="form-control" name="resource[post_title]"
             id="resource_post_title" value="" >
    </div>
  
    <button type="submit" class="btn btn-default">Create</button>
    <a class="btn" href="/posts">Cancel</a>
</form>

    """
  end


  def simple_sans_closing do
    "<html><head></head><body><p><i>Test</p></body></html>"
  end

  def simple_overlapping do
    "<html><head></head><body><p><i>Test</p></i></body></html>"
  end
end


defmodule Chrysopoeia.Parser.Floki.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  test"parses well formed html" do
     Chrysopoeia.Parser.Samples.simple
      |> Chrysopoeia.Parser.Floki.parse
      |> assert_eq {"html", [], [{"head", [], []}, {"body", [], [{"p", [], ["Test"]}]}]}
  end

  #test"parses malformed html with closing tag missing" do
     #Chrysopoeia.Parser.Samples.simple_sans_closing
      #|> Chrysopoeia.Parser.Floki.parse
      #|> assert_eq {"html", [], [{"head", [], []}, {"body", [], [{"p", [], [{"i", [], ["Test"]}]}]}]}
  #end

  #test"parses malformed html with closing tag overlapping" do
     #Chrysopoeia.Parser.Samples.simple_overlapping
      #|> Chrysopoeia.Parser.Floki.parse
      #|> assert_eq {"html", [], [{"head", [], []}, {"body", [], [{"p", [], [{"i", [], ["Test"]}]}]}]}
  #end
end

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
