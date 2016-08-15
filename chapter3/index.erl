-module(index).

-compile(export_all).
% -export([])

read() ->
    OriginDoc = io:get_line("document:"),
    Doc = string:tokens(OriginDoc, ", ."),
    [OriginDoc, Doc].

index_file(File) ->
    {ok, OriginDoc} = file:read_file(File),
    Doc = string:tokens(binary_to_list(OriginDoc), ", .\n\""),
    List = lists:keysort(2, foreach_doc(Doc, [])),
    file:write_file("doc2.txt",
        term_to_binary(lists:flatten(io_lib:write(List))),
        [binary]),
    List.

foreach_doc([], List) ->
    List;
foreach_doc([WordStr|Doc], List) ->
    Word = list_to_atom(string:to_lower(WordStr)),
    List2 = case lists:keyfind(Word, 1, List) of
        {Word, Num} ->
            lists:keyreplace(Word, 1, List, {Word, Num+1});
        false ->
            [{Word, 1}|List]
    end,
    foreach_doc(Doc, List2).


% 将索引的模式转换成TupleList的模式。举例说明：列表[1,2,3,5,6]，把第一个元素1直接放入chpattern/4中的中间量M，第二个元素是第一个元素加1，即连续，那么丢掉；当到遍历到第四个元素“5”时，5=/=3+1（上一个元素加1），所以将上一个元素“3”放入M，反转M放入L，就得到TupleList的第一个Tuple元素{1,3}。接着清空M，再直接把5放入M，重复上述过程，遍历索引列表，得到完整的TupleList。

chpattern(List) ->
    list_to_str(chpattern(List, [], [])).

list_to_str(List2) ->
    Str = lists:concat(lists:map(
        fun(List) ->
            [H|_]=List,
            Last = lists:last(List),
            if
                H==Last ->
                    integer_to_list(H);
                true ->
                     integer_to_list(H)++"-"++integer_to_list(Last)++","
            end
        end, List2)),
    string:strip(Str, both, $,).

chpattern([], M, List) ->
    lists:reverse([lists:reverse(M)|List]);
chpattern([T], M, List) ->
    TInM = lists:member(T, M),
    [H|_Tail] = M,
    TeqHP1 = T==(H+1),
    
    if
        TInM ->
            chpattern([], M, List);
        TeqHP1 ->
            chpattern([], [T|M], List);
        true ->
            chpattern([], [T], [lists:reverse(M)|List])
    end;
chpattern([H1|[H2|_Tail2]=Tail1], M, List) ->
    H1IsMember = lists:member(H1, M),
    H2IsMember = lists:member(H2, M),
    NotH1 = not H1IsMember,
    NotH2 = not H2IsMember,
    H1EqH2 = H1==H2,
    H2EqH1P1 = H2==(H1+1),
    RetL = if
        H1EqH2 and NotH2 ->
            chpattern(Tail1, [H1|M], List);
        H1EqH2 and H2IsMember ->
            chpattern(Tail1, M, List);
        H2EqH1P1 and NotH1 ->
            chpattern(Tail1, [H1|M], List);
        H2EqH1P1 and H1IsMember ->
            chpattern(Tail1, M, List);
        H1=/=H2 ->
            chpattern(Tail1, [], [lists:reverse([H1|M])|List])
    end,
    RetL.
