-module (mutex2).

-export ([start/0, stop/0]).
-export ([init/0, wait/0, signal/0]).

start() ->
    register(?MODULE, Pid = spawn(?MODULE, init, [])),
    io:format("server pid is ~p.~n", [Pid]).

stop() ->
    ?MODULE ! stop.

wait() ->
    ?MODULE ! {wait, self()},
    io:format("~p.~n", [self()]),
    receive
        ok ->
            io:format("Signal is allocated. Linked.~n", [])
    end.

signal() ->
    ?MODULE ! {signal, self()},
    receive
        ok ->
            io:format("Signal return. Unlinked~n", [])
    end.

init() ->
    % 将 ?MODULE 进程转变为系统进程，捕捉EXIT信号
    process_flag(trap_exit, true),
    loop().

loop() ->
    receive
        {wait, Pid} ->
            link(Pid), % 匹配请求，并连接客户端进程
            Pid!ok,
            busy(Pid);
        stop ->
            terminate()
    end.

busy(Pid) ->
    receive
        {signal, Pid} ->
            unlink(Pid), % 释放信号，同时解除连接
            Pid!ok,
            loop();
        stop -> %
            unlink(Pid),
            Pid!ok,
            terminate();
        {'EXIT', Pid, Reason} ->
            io:format("Client is down. Signal return.~p ~p.~n", [Pid, Reason]),
            loop()
    end.

terminate() ->
    receive
        {wait, Pid} ->
            io:format("delete 1.~n", []),
            exit(Pid, kill),
            terminate()
    after 0 ->
        io:format("server is down.~n", [])
    end.
