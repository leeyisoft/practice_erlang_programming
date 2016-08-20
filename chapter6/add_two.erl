-module (add_two).

-export ([start/0, request/1, loop/0]).

start() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, loop, []),
    register(?MODULE, Pid),
    {ok, Pid}.

request(Int) ->
    ?MODULE ! {request, self(), Int},
    receive
        {result, Result} ->
            Result;
        {'EXIT', _Pid, Reason} ->
            {error, Reason}
    after
        1000 ->
            timeout
    end.

loop() ->
    receive
        {request, Pid, Msg} ->
            Pid ! {result, Msg+2}
    end,
    loop().
