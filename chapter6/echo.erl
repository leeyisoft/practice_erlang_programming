-module (echo).

-export ([start/0, print/1, stop/0]).

-export ([loop/0]).

start() ->
    process_flag(trap_exit, true),
    io:format("start self pid: ~p~n", [self()]),
    register(?MODULE, spawn_link(?MODULE, loop, [])).

print(Msg) ->
    ?MODULE ! {print, Msg},
    ok.

stop() ->
    % ?MODULE ! stop,     ok.
    exit(self(), normal),
    ok.

loop() ->
    receive
        {print, Msg} ->
            io:format("self~p,~w~n",[ self(), Msg]),
            loop();
        {'EXIT', _Pid, _Reason} ->
            io:format("receive EXIT PID ~p, REASON~p~n", [_Pid, _Reason]),
            true;
        stop ->
            true
    end.
