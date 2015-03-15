import Chrysopoeia.Parser.Transform 

defmodule Transforms.Simple.Test do
  use ExUnit.Case

  def assert_eq(left, right), do: assert left == right

  def to_text(content) do
    content
      |> List.first 
      |> elem(2)
      |> List.first
  end


  # TODO, belongs in transform
  test "extract" do
    # Example of a very simple transform to extract the content of a file
    deftransform Extract do
      @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit"
      extract content
    end

    assert_eq Extract.transform("") 
                |> List.first |> elem(1), [{"id", "content"}]
  end

  test "prepend_text" do
    # A simple transform with text prepended to one of the elements, demonstrates
    # the two forms of prepend_text, one with an id and a model field name, the
    # other with an explicit body.
    deftransform PrependText do
      @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit"
      extract action_title

      prepend_text action_title(:action_title) 

      prepend_text action_title do
       "FOO. #{model[:action_title]} BAR. "
      end
    end

    model = [{:action_title, "BAZ."}]
    
    assert_eq PrependText.transform(model) |> to_text, "FOO. BAZ. BAR. BAZ.ACTION TITLE"
  end

  test "prepend text with select" do
    # we also have an additional two forms of xxxxx_text using the select
    # keyword we can specify a full css selector
    deftransform PrependTextTWO do
      @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit"
      extract action_title

      prepend_text select("#content h1[id=action_title]", :action_title)
      prepend_text select("#content h1[id=action_title]"), do: "FOO."
    end

    model = [{:action_title, "BAR "}]
    assert_eq PrependTextTWO.transform(model) |> to_text, "FOO.BAR ACTION TITLE"
  end

  test "append_text" do
    # A simple transform with text appended to one of the elements
    deftransform AppendText do
      @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit"
      extract action_title

      prepend_text action_title, do: model[:action_title]
      append_text action_title, do: model[:action_title]
    end

    model = [{:action_title, "BAZ"}]
    assert_eq AppendText.transform(model) |> to_text, "BAZACTION TITLEBAZ"
  end

  test "replace_text" do
    # A simple transform with text replaced, then prepended and appended to one of
    # the elements
    deftransform ReplaceText do
      @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit"
      extract action_title

      replace_text action_title, do: model[:replacement]
      prepend_text action_title, do: model[:before]
      append_text action_title, do: model[:after]
    end

    model = [{:before, "Start of "}, 
             {:after, " ..."}, 
             {:replacement, "new text"}]

    assert_eq ReplaceText.transform(model) |> to_text, "Start of new text ..."
  end

  test "replace_text_overwrite" do
    # A simple transform showing that prepended and appended to one of
    # the elements and THEN replacing will overwrite the other changes.
    deftransform ReplaceTextOverwrite do
      @source "/home/leej/Elixir/chrysopoeia/test/templates/post/edit"
      extract action_title

      prepend_text action_title, do: model[:before]
      append_text action_title, do: model[:after]
      replace_text action_title, do: model[:replacement]
    end

    model = [{:before, "Start of "}, 
             {:after, " ..."}, 
             {:replacement, "new text"}]

    assert_eq ReplaceTextOverwrite.transform(model) |> to_text, "new text"
  end
end
