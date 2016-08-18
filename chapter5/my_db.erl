-module(my_db).

-export ([start/0, stop/0, write/2, delete/1, read/1, match/1]).

-export ([init/0]).

%% public api
start() ->
    register(?MODULE, spawn(?MODULE, init, [])),
    ok.

stop() ->
    call(?MODULE, stop),
    ok.

write(Key, Element) ->
    call(?MODULE, {write, Key, Element}),
    ok.

delete(Key) ->
    call(?MODULE, {delete, Key}),
    ok.
read(Key) ->
    Element = call(?MODULE, {read, Key}),
    if
        {error, instance} == Element ->
            Element;
        true ->
            {ok, Element}
    end.
match(Key) ->
    call(?MODULE, {match, Key}).
%% end api

%% protected (export but not api)
init() ->
    loop([]).
%% end

%% private (not export)
loop(Db) ->
    receive
        {FromPid, {write, Key, Element}} ->
            NewDb = [{Key,Element}|Db],
            FromPid ! {reply, ok},
            loop(NewDb);
        {FromPid, {delete, Key}} ->
            case lists:keysearch(Key, 1, Db) of
                false ->
                    FromPid ! {reply, {error, instance}},
                    loop(Db);
                {value, {Key2, _Element}} ->
                    NewDb = lists:keydelete(Key2, 1, Db),
                    FromPid ! {reply, ok},
                    loop(NewDb)
            end;
        {FromPid, {read, Key}} ->
            case lists:keysearch(Key, 1, Db) of
                false ->
                    FromPid ! {reply, {error, instance}},
                    loop(Db);
                {value, {_Key2, Element}} ->
                    FromPid ! {reply, Element},
                    loop(Db)
            end;
        {FromPid, {match, Element}} ->
            Keys = proplists:get_all_values(Element, [list_to_tuple(lists:reverse(tuple_to_list(TupleX))) || TupleX<-Db]),
            FromPid ! {reply, Keys},
            loop(Db);
        stop ->
            ok
    end.

call(Name, Msg) ->
    Name ! {self(), Msg},
    receive
        {reply, Reply} ->
            Reply
    end.

%% end private
