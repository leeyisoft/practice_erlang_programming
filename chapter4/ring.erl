%% -----------------------------------------------------------------------------
%% Copyright © 2016-2020 leeyi
%%
%% You should have received a copy of the GNU Lesser General Public
%% License along with Erlang UUID.  If not, see
%% <http://www.gnu.org/licenses/>.
%% -----------------------------------------------------------------------------
%% @author leeyi <leeyisoft@qq.com>
%% @copyright 2016-2020 leeyi
%% @doc
%% ...
%% @end
%% @reference See <a href="">See</a>
%%            for more information.
%% -----------------------------------------------------------------------------
-module (ring).

-export ([start/3, stop/1]).

-export ([loop/0, get_process_name/2]).

%% 密码加密函数
%%--------------------------------------------------------------------
%% Function: start(M, N, Msg)
%%           M   = integer(), 发送消息数量
%%           N   = integer(), 循环进程数量
%%           Msg = any(), 任意erlang项式
%% Descrip.:
%% Returns : void
%% Example : ring:start(1, 5, hello).
%%--------------------------------------------------------------------
start(M, N, Msg) ->
    Pid = self(),
    io:format("start ring ~p, ~p, ~p, start pid: ~p~n", [M, N, Msg, Pid]),
    PList = get_process_name(N, []),
    lists:map(fun(ProcessName) -> register(ProcessName, spawn(?MODULE, loop, [])) end, PList),

    io:format("process pid  ~p~n", [[whereis(Process) || Process<-PList]]),
    io:format("process name ~p~n", [PList]),

    send(M, PList, PList, Msg),
    stop(N).

send(M, [T], PL, Msg) ->
    [H|_Tail] = PL,
    sleep(3),
    send_msg(T, H, M, Msg),
    send(M, PL, PL, Msg);
    % ok;
send(M, PList, PL, Msg) ->
    [From|[To|Tail]] = PList,
    send_msg(From, To, M, Msg),
    send(M, [To|Tail], PL, Msg).

send_msg(From, To, _M, Msg) ->
    Seq = lists:seq(1, _M),
    lists:map(fun(_E) -> To ! {From, To, Msg} end, Seq).
    % To ! {From, To, Msg}.

loop() ->
    receive
        {FromPid, ToPid, Msg} ->
            io:format("~nreceive msg from ~p~p to ~p~p, msg ~p, self ~p~n", [FromPid, whereis(FromPid), ToPid, whereis(ToPid), Msg, self()]),
            loop();
        {stop, PidName} ->
            io:format("receive stop name ~p, pid~p, self ~p~n", [PidName, whereis(PidName), self()])
    end.

stop(N) ->
    PList = get_process_name(N, []),
    lists:map(fun(ProcessName) -> ProcessName! {stop, ProcessName} end, PList).

get_process_name(0, List) ->
    List;
get_process_name(N, List) when N>0 ->
    ProcessName = list_to_atom("a_process_"++integer_to_list(N)),
    get_process_name(N-1, [ProcessName|List]).

sleep(N) ->
    receive
    after
        N*1000 ->
            io:format("sleep ~ps~n~n",[N])
    end.
