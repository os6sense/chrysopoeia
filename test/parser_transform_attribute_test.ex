
defmodule Chrysopoeia.Parser.Transform.Attibute do
  
  # the old test
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

