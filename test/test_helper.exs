ExUnit.start()

# Concentrating on F~oki and YAML
defmodule Chrysopoeia.Parser.Samples do

  def simple(:html) do
    "<html><head></head><body><p>Test</p><p class=\"tc\" id=\"id_1\">test 2</p></body></html>"
  end

  def simple(:parse_tree) do
    {"html", [], [{"head", [], []}, {"body", [], [{"p", [], ["Test"]}, {"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}]}]}
  end

  def deep_nesting(:html) do
    """
      <html>
        <head></head>
        <body>
          <div id="deep_span">
            <span>lvl 1<span>lvl_2 1<span id="lvl_2_2">lvl2 2</span>
                <span>lvl 3<br/>
                  <span id="lvl_4_1">lvl4 1</span>
                  <span id="lvl_4_2">lvl4 2</span>
                  <span id="lvl_4_3">lvl4 3</span>
                  <span id="lvl_4_4">lvl4 4</span>
                  <span id="lvl_4_5">lvl4 5</span>
                  <span id="lvl_4_6">lvl4 6</span>
                  <span id="lvl_4_7">lvl4 7<img src="something.jpg" alt="test"/>
                    <a href="somewhere.html"><img alt="test" src="something.jpg"/>sometext</a>
                  </span>
                </span>
                <span id="lvl2_3">lvl2 3</span>
              </span>
            </span>
            <span id="lvl 1 last">lvl 1 last</span>
          </div>
        </body>
      </html>
    """
  end

  def deep_nesting(:parse_tree) do
    {"html", [],
            [{"head", [], []},
             {"body", [],
              [{"div", [{"id", "deep_span"}],
                [{"span", [],
                  ["lvl 1",
                   {"span", [],
                    ["lvl_2 1", {"span", [{"id", "lvl_2_2"}], ["lvl2 2"]},
                     {"span", [],
                      ["lvl 3", {"br", [], []}, {"span", [{"id", "lvl_4_1"}], ["lvl4 1"]}, {"span", [{"id", "lvl_4_2"}], ["lvl4 2"]}, {"span", [{"id", "lvl_4_3"}], ["lvl4 3"]}, {"span", [{"id", "lvl_4_4"}], ["lvl4 4"]},
                       {"span", [{"id", "lvl_4_5"}], ["lvl4 5"]}, {"span", [{"id", "lvl_4_6"}], ["lvl4 6"]},
                       {"span", [{"id", "lvl_4_7"}],
                        ["lvl4 7", {"img", [{"src", "something.jpg"}, {"alt", "test"}], []}, {"a", [{"href", "somewhere.html"}], [{"img", [{"alt", "test"}, {"src", "something.jpg"}], []}, "sometext"]}]}]},
                     {"span", [{"id", "lvl2_3"}], ["lvl2 3"]}]}]}, {"span", [{"id", "lvl 1 last"}], ["lvl 1 last"]}]}]}]}
  end


  def simple_form do
    """
      <div id="deep_span">
        <span>lvl 1
          <span>lvl_2
            <span>lvl 3<br/>
              <span id="lvl_4">lvl4
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


