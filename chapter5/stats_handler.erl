-module (stats_handler).

-export ([init/1, terminate/1, handle_event/2]).

init(InitDataList) ->
    InitDataList.

terminate(DataList) ->
    DataList.

handle_event({Type, _Id, Description}, DataList) ->
    case lists:keyfind({Type, Description}, 1, DataList) of
        false ->
            [{{Type, Description}, 1}|DataList];
        {Key, Count} ->
            NewDataList = lists:keyreplace(Key, 1, DataList, {Key, Count+1}),
            NewDataList
    end.
