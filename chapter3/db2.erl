-module (db2).

-export ([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

-spec new() -> [].
-spec write(Key::term(), Value::term(), Db::list()) -> [{Key::term(), Value::term()}|list()].
-spec read(Key::term(), Db::list()) -> {ok, Value::term()}.
-spec match(Value::term(), Db::list()) -> [Key::term()].
-spec delete(Key::term(), Db::list()) -> [].
-spec destroy(Db::list()) -> ok.

%% api
new() ->
    [].

write(Key, Value, Db) ->
    [{Key, Value}|Db].

read(Key, Db) ->
    proplists:get_value(Key, Db, {error, instance}).

match(Value, Db) ->
    proplists:get_all_values(Value, [list_to_tuple(lists:reverse(tuple_to_list(TupleX))) || TupleX<-Db]).

delete(Key, Db) ->
    proplists:delete(Key, Db).


destroy(_Db) ->
    {ok, "success"}.
%% end api

%% private


%% end private
