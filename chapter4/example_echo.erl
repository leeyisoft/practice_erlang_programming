%% example4-1 echo进程
-module (example_echo).

-export ([go/0, loop/0]).

go() ->
    Pid = spawn(?MODULE, loop, []),
    Pid ! {self(), hello},
    receive
        {Pid, Msg} ->
            io:format("~w~n", [Msg])
    end,
    Pid ! stop.

loop() ->
    receive
        {From, Msg} ->
            From ! {self(), Msg},
            loop();
        stop ->
            true
    end.
