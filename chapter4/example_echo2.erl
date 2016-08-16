%% example4-2 echo进程
-module (example_echo2).

-export ([go/0, loop/0]).

go() ->
    register(?MODULE, spawn(?MODULE, loop, [])),
    ?MODULE ! {self(), hello},
    receive
        {_Pid, Msg} ->
            io:format("~w~n", [Msg])
    end.

loop() ->
    receive
        {From, Msg} ->
            From ! {self(), Msg},
            loop();
        stop ->
            true
    end.
