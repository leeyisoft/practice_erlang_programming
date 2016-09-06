-module (db_server).

-export ([start/0, stop/0, upgrade/1]).

-export ([write/2, read/1, delete/1]).

-export ([init/0, loop/1]).

-vsn(1.0).

start() ->
    register(?MODULE, spawn(?MODULE, init, [])).

stop() ->
    ?MODULE ! stop.

upgrade(Data) ->
    ?MODULE ! {upgrade, Data}.

write(Key, Data) ->
    ?MODULE ! {write, Key, Data}.

read(Key) ->
    ?MODULE ! {read, self(), Key},
    receive
        Reply ->
            Reply
    end.

delete(Key) ->
    ?MODULE ! {delete, Key}.

init() ->
    loop(db:new()).

loop(Db) ->
    receive
        {write, Key, Data} ->
            loop(db:write(Key, Data, Db));
        {read, Pid, Key} ->
            Pid ! db:read(Key, Db),
            loop(Db);
        {delete, Key} ->
            loop(db:delete(Key, Db));
        {upgrade, Data} ->
            NewDb = db:convert(Data, Db),
            ?MODULE:loop(NewDb);
        stop ->
            db:destroy(Db)
    end.
