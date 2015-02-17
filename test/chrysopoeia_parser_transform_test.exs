
defmodule Chrysopoeia.Parser.Transform.Test do
  use ExUnit.Case

  def assert_eq(left, right) do
    assert left == right
  end

  require Chrysopoeia.Parser.Transform, as: Transform
  test "transform" do

    # Hmmmmmmm bad api, maybe better?
    # Transform.attribute([~s(p[id="id_1"]), "id", "abcde"])
    transform = Transform.create([~s(p[id="id_1"])]) do
      Transform.attribute_set("id", "abcde")
    end

    transforms = [transform]

    #{"p", [{"class", "tc"}, {"id", "id_1"}], ["test 2"]}
      #|> Transform.transform( transforms )
      #|> assert_eq {"p", [{"class", "tc"}, {"id", "abcde"}], ["test 2"]}
  end
end

"""

How to use this? Fleshing out

selector = ~s(form[id="id_1"]) 
fn({e, a, c}) ->  
                  Node.insert_html(a, "html as a string")

selector = ~s(input[name="_csrf_token"])
fn({e, a, c}) -> Atrribute.set(a, "value", "abcd")

"""
