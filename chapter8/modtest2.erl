-module (modtest2).

-export ([main/0, loop/0, a/1, do/1]).

main() ->
    register(foo, spawn(?MODULE, loop, [])).

loop() ->
    receive
        {Sender, N} ->
            Sender ! modtest2:a(N)
    end,
    loop().

do(M) ->
    foo ! {self(), M},
    receive Y ->
        Y
    end.

a(N) ->
    N.
