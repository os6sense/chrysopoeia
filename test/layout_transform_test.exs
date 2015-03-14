import Chrysopoeia.Parser.Transform 

# A simple transform to include the body of one file inside another
# e.g. post/edit.html inside the content are of layout/main.html 

## NB COMMENTED OUT PURELY WHILE I WORK ON THE POSTEDIT page level transforms.
#deftransform EditPage do
  #@source "templates/layout/main"

  ## am I going to have to supply an apply macro - what about when there 
  ## are multiple transforms?
  ##insert edit_form("div[id=content]", transformed) do
    ##insert_transformed(transformed)
  ##end
  ## alternate idea - replace anything within the content id element with
  ## the transformed.

  #replace content transformed

  ## Page title will need changing parameter or model?
  #replace_text title("title")  do
    #model[:title]
  #end
#end

deftransform Extract do
  @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit.html"
  extract content
end

deftransform PrependText do
  @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit.html"
  extract action_title

  prepend_text action_title do
    model[:action_title]
  end
end

deftransform AppendText do
  @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit.html"
  extract action_title

  append_text action_title do
    model[:action_title]
  end
end


#deftransform PostEdit do
  ## This is the name of the file to transform. A .html extension is assumed.
  #@source "templates/post/edit"

  ## the extract macro means that the only parts of this transform that
  ## will be returned are the parts within the content id div.
  #extract content

  ## RULE ONE!
  ## If no parameters are passed to certain functions we assume the name of the
  ## function matches an element with an id atribute of that name.
  ##
  ## e.g. rather than:
  ##   prepend_text action_title("#action_title") do
  ## we have :
  ## insert_text action_title do
  #prepend_text action_title do
    #model[:action_title]
  #end

  ## Will replace the value of the "value" attribute of the
  ## element #post id ... not sure about this.
  #replace_attribute post_id(:value) do
    #model[:post_id]
  #end

  #replace_text post_date do
    #model[:post_date]
  #end

  #replace_text post_body do
    #model[:post_body]
  #end

  ## errors - hmm theres a tricky one. If there are errors we 
  ## want the form to contain them - probably transformed
  ## Remember our order though - deletes first!

  ## TODO leaving this one for last
  ##delete form_errors when model[:errors] == []
  ##replace_text form_errors(transform) do
    ### this is probably a transform too! 
    ####model[:errors].map
  ##end
#end

# should I be looking at inserting one transform inside another at
# this point? Yes I should I think

defmodule Transforms.Simple.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right

  test "extract" do
    assert_eq Extract.transform("") |> List.first |> elem(1) , [{"id", "content"}]
  end

  test "prepend_text" do
    model = [{:action_title, "Creating "}]
    
    assert_eq PrependText.transform(model) , [{"h1", [{"id", "action_title"}], ["Creating The word \"Editing\" or \"Creating\" should be introduced before this"]}]
  end

  # Okay lets deal with the PostEdit transforms first.
  #test "applys the transforms to a file" do
    ## #apply can be our pipelining op maybe?
    ##transformed = Transforms.apply(conn, PostEdit)
    #model = [{:action, :create}, {:post_id, "1"}, 
             #{:post_date, "022/01/2015"}, {:post_body, "First post wow!"}]

    ## Ohhh far nicer.
    #PostEdit.transform(model)
  #end

  #test "inserts one file inside of another" do
    # This begs the queston of how one composes transforms?
    # PostEdit.transform(model)
      #|> EditPage.transform(model)
    
    #transformed = Transforms.apply(conn, transforms)
  #end
end
