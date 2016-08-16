-module (echo).

-export ([start/0, print/1, stop/0]).

-export ([loop/0]).

start() ->
    register(?MODULE, spawn(?MODULE, loop, [])),
    ok.

print(Msg) ->
    ?MODULE ! {print, Msg},
    ok.

stop() ->
    ?MODULE ! stop,
    ok.

loop() ->
    receive
        {print, Msg} ->
            io:format("~w~n",[Msg]),
            loop();
        stop ->
            true
    end.
