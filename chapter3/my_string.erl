
%% my_string:slice("abcdefghi jklmn", "bf l").
%% 使用分隔符把字符串分割 参考了 string:tokens/2 效果和它一样

-module (my_string).

-export ([slice/2]).


slice(String, List) ->
    slice(String, List, []).


slice([], _List, Ret) ->
    lists:reverse(Ret);
slice([H|String], List, Ret) ->
    case lists:member(H, List) of
        true ->
            slice(String, List, Ret);
        false ->
            slice(String, List, Ret, [H])
    end.

slice([], _List, Ret, Memb) ->
    lists:reverse([lists:reverse(Memb) | Ret]);
slice([H|String], List, Ret, Memb) ->
    case lists:member(H, List) of
        true ->
            slice(String, List, [lists:reverse(Memb)|Ret]);
        false ->
            slice(String, List, Ret, [H|Memb])
    end.
