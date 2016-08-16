-module (text).

-compile(export_all).


format(File) ->
    {ok, Text} = file:read_file(File),
    TList = string:tokens(binary_to_list(Text), " \n"),
    Text2 = format(TList, 0, ""),
    file:write_file("text_format.txt", list_to_binary(Text2)).

format([], _Len, List) ->
    List;
format(Text, Len, List) when Len>5 ->
    [H|Tail] = Text,
    format(Tail, 0, List++H++" "++"\n");
format(Text, Len, List) ->
    [H|Tail] = Text,
    format(Tail, Len+1, List++H++" ").
