%%% @desc
%%% c(macros1)
%%% rr(macros1).
%%% macros1:birthday(#person{name="Joe", age=21, phone="999-999"}).
%%%
%%% 打开系统调试 c(Module, [{d, debug}]).
%%% 例如 c(macros1, [{d, debug}]).
%%% @end
-module (macros1).

-compile(export_all).

-record (person, {name, age = 0, phone=""}).

-define(val (Call), io:format("~p=~p~n", [??Call, Call])).

-ifdef(debug).
-define (DBG(Str, Args), io:format(Str, Args)).
-else.
-define (DBG(Str, Args), ok).
-endif.

test1() ->
    ?val(length([1,2,3])).

birthday(#person{age=Age}=P) ->
    ?DBG("in records1:birthday(~p)~n", [P]),
    P#person{age=Age+1}.
