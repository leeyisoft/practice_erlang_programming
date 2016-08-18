-module (frequency2).

-export ([start/0, stop/0, allocate/0, deallocate/1]).

-export ([init/0]).

-export ([get_data/0, deallocate_for_admin/2]).
%% These are the start functions used to create and
%% initialize the server.
start() ->
    register(?MODULE, spawn(?MODULE, init, [])).

init() ->
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

% hard coded

get_frequencies() ->
    [10, 11, 12, 13, 14, 15].

%% the client functions

stop() ->
    call(stop).

allocate() ->
    call(allocate).

deallocate(Freq) ->
    call({deallocate, Freq}).

deallocate_for_admin(Freq, Pid) ->
    call({deallocate, Freq, Pid}).

get_data() ->
    call(getdata).

%% We hide all message passing and the message
%% protocol in a functional interface.
call(Message) ->
    ?MODULE ! {request, self(), Message},
    receive
        {reply, Reply} -> Reply
    end.

%% the main loop
loop(Frequencies) ->
    receive
        {request, Pid, allocate} ->
            {NewFrequencies, Reply} = allocate(Frequencies, Pid),
            reply(Pid, Reply),
            loop(NewFrequencies);
        {request, Pid, {deallocate, Freq}} ->
            {NewFrequencies, Reply} = deallocate(Frequencies, {Freq, Pid}),
            reply(Pid, Reply),
            loop(NewFrequencies);
        {request, Pid, {deallocate, Freq, AssignedPid}} ->
            {NewFrequencies, Reply} = deallocate(Frequencies, {Freq, AssignedPid}),
            reply(Pid, Reply),
            loop(NewFrequencies);
        {request, Pid, getdata} ->
            reply(Pid, Frequencies),
            loop(Frequencies);
        {request, Pid, stop} ->
            {Free, _Allocated} = Frequencies,
            if
                Free=:=[] ->
                    reply(Pid, ok);
                true ->
                    reply(Pid, {error, "Frequencies is not empty."}),
                    loop(Frequencies)
            end
    end.

reply(Pid, Reply) ->
    Pid ! {reply, Reply}.

%% the internal helop functions used to allocate and
%% deallocate frequencies.
allocate({[], Allocated}, _Pid) ->
    {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}=Freqs, Pid) ->
    PidLen = length(lists:filter(fun({_Freq, P}) -> P=:=Pid  end, Allocated)),
    if
        PidLen>=3 ->
            {Freqs, {error, "pid allocated more 3"}};
        true ->
            {{Free, [{Freq,Pid}|Allocated]}, {ok, Freq}}
    end.

deallocate({Free, Allocated}, {Freq, Pid}) ->
    AFreq = lists:keyfind(Freq, 1, Allocated),

    case AFreq of
        {Freq, PidFind} ->
            if
                Pid=:=PidFind ->
                    NewAllocated = lists:keydelete(Freq, 1, Allocated),
                    {{[Freq|Free], NewAllocated}, ok};
                true ->
                    {{Free, Allocated}, {error, forbidden}}
            end;
        false ->
            {{Free, Allocated}, {error, no_allocate}}
    end.
