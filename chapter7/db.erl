-module (db).

-export ([new/0, destroy/1, write/2, delete/2, read/2, match/2]).

-include("kv.hrl").

-type record()::kv.

-spec new() -> [].
-spec write(Data::record(), Db::list()) -> [record()|list()].
-spec read(Key::term(), Db::list()) -> {ok, Value::term()}.
-spec match(Value::term(), Db::list()) -> [Key::term()].
-spec delete(Key::term(), Db::list()) -> [].
-spec destroy(Db::list()) -> ok.

%% api
new() ->
    [].

write(Data, Db) when is_record(Data, kv) ->
    [Data|Db].

read(Key, Db) ->
    List = [E#kv.value|| E<-Db, E#kv.key==Key],
    case List of
        [Data] ->
            {ok, Data};
        [Data|_Tail] ->
            {ok, Data};
        [] ->
            {error, instance}
    end.

match(Value, Db) ->
    [E#kv.key|| E<-Db, E#kv.value==Value].

delete(Key, Db) ->
    [E || E<-Db, E#kv.key=/=Key].


destroy(_Db) ->
    {ok, "success"}.
%% end api

%% private


%% end private
