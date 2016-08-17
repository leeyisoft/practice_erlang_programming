-module(practice3_1).

-compile(export_all).

%%3-1
sum(N) when N>0 ->
    N + sum(N-1);
sum(0) ->
    0.

sum2(0) ->
    0;
sum2(N) ->
    N + sum2(N-1).

sum(N, M) when N==M ->
    M;
sum(N, M) when N<M ->
    N + sum(N+1, M).

factorial(0) ->
    1;
factorial(N) ->
    N * factorial(N-1).

factorial2(0) ->
    1;
factorial2(N) when N>0 ->
    N * factorial(N-1).

%% end 3-1

max(List) ->
    [H|Tail] = List,
    max(Tail, H).

max([], Max) ->
    Max;

max([H|Tail], Max) when H>Max ->
    max(Tail, H);
max([H|Tail], Max) ->
    max(Tail, H).
