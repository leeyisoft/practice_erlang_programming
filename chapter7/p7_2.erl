-module (p7_2).

-export ([birthday/1, joe/0, showPerson/1, boobar/1]).

-record (person, {name, age = 0, phone="", address=""}).

-ifdef(debug).
-define (DBG(Str, Args), io:format(Str, Args)).
-else.
-define (DBG(Str, Args), ok).
-endif.


boobar(#person{age=Age, phone=Phone, name=Name, address=Address}=P) when is_record(P, person) ->
    io:format("name:~p age:~p phone:~p address:~p~n", [Name, Age, Phone, Address]);
boobar(P) ->
    io:format("P is not recard: ~p~n", [P]).

birthday(#person{age=Age}=P) ->
    P#person{age=Age+1}.

joe() ->
    #person{name="Joe", age=21, phone="999-999"}.

showPerson(#person{age=Age, phone=Phone, name=Name, address=Address}) ->
    io:format("name:~p age:~p phone:~p address:~p~n", [Name, Age, Phone, Address]).
