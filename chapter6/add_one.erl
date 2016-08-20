-module (add_one).

-export ([start/0, request/1, loop/0]).

start() ->
    register(?MODULE, spawn_link(?MODULE, loop, [])).

request(Int) ->
    ?MODULE ! {request, self(), Int},
    receive
        {result, Result} ->
            Result
    after
        1000 ->
            timeout
    end.

loop() ->
    receive
        {request, Pid, Msg} ->
            Pid ! {result, Msg+1}
    end,
    loop().
