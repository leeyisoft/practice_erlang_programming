-file("macros1.erl", 1).

test1() ->
    io:format("~p=~p~n", ["length ( [ 1 , 2 , 3 ] )",length([1,2,3])]).

birthday({person,_,Age,_} = P) ->
    ok,
    begin
        rec0 = Age + 1,
        rec1 = P,
        case rec1 of
            {person,_,_,_} ->
                setelement(3, rec1, rec0);
            _ ->
                error({badrecord,person})
        end
    end.

module_info() ->
    erlang:get_module_info(macros1).

module_info(X) ->
    erlang:get_module_info(macros1, X).

