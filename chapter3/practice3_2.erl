-module(practice3_2).

-compile(export_all).

%% 3-2
create(N) when N>0 ->
    create(N, [1]).

create(1, List) ->
    List;
create(N, [H|T]) ->
    create(N-1, [H|[N|T]]).


reverse_create(N) when N>0 ->
    reverse_create(N, [N]).

reverse_create(1, List) ->
    List;
reverse_create(N, [H|T]) ->
    reverse_create(N-1, [H|[H-N+1|T]]).

%% end 3-2
