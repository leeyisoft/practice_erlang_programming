-module (db).

-export ([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

-spec new() -> [].
-spec write(Name::term(), Place::term(), Db::list()) -> [{Name::term(), Place::term()}|list()].
-spec read(Name::term(), Db::list()) -> {ok, Place::term()}.
-spec match(Place::term(), Db::list()) -> [Name::term()].
-spec delete(Name::term(), Db::list()) -> [].
-spec destroy(Db::list()) -> ok.

%% api
new() ->
    [].

write(Name, Place, Db) ->
    [{Name, Place}|Db].

read(_Name, []) ->
    {error, instance};
read(Name, Db) ->
    [{Name1, Place}|Tail] = Db,
    if
        Name1==Name ->
            {ok, Place};
        true ->
            read(Name, Tail)
    end.

match(_Place, []) ->
    [];
match(Place, Db) ->
    [{Name, Place1}|Tail] = Db,
    if
        Place1==Place ->
            [Name|match(Place, Tail)];
        true ->
            match(Place, Tail)
    end.

delete(_Name, []) ->
    [];
delete(Name, Db) ->
    delete(Name, Db, []).

delete(_Name, [], _) ->
    {error, "non-existent"};
delete(Name, Db, RetDb) ->
    [{Name1, Place}|Tail] = Db,
    if
        Name==Name1 ->
            RetDb++Tail;
        true ->
            delete(Name, Tail, [{Name1, Place}|RetDb])
    end.


destroy(_Db) ->
    {ok, "success"}.
%% end api

%% private


%% end private
