ExUnit.start()

# Concentrating on F~oki and YAML
defmodule Chrysopoeia.Parser.Samples do

  def simple(:html) do
    "<html><head></head><body><p>Test</p><p class=\"tc\" id=\"id_1\">test 2</p></body></html>"
  end

  def simple(:parse_tree) do
    {"html", [], [{"head", [], []}, {"body", [], [{"p", [], ["Test"]}, {"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}]}]}
  end


  def simple_form do
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

  def simple_sans_closing(:html) do
    "<html><head></head><body><p><i>Test</p></body></html>"
  end

  def simple_sans_closing(:parse_tree) do
    {"html", [], [{"head", [], []}, {"body", [], [{"p", [], [{"i", [], ["Test"]}]}]}]}
  end

  def simple_overlapping(:html) do
    "<html><head></head><body><p><i>Test</p></i></body></html>"
  end

  def simple_overlapping(:parse_tree) do
    {"html", [], [{"head", [], []}, {"body", [], [{"p", [], [{"i", [], ["Test"]}]}]}]}
  end
end


