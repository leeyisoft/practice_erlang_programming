-module(practice3_3).

-compile(export_all).

%% 3-3

print(N) when N>0 ->
    % [io:format("Number:~p~n", [X]) || X <- chapter3:create(N)].
    print(N, [1]).
print(1, List) ->
    List,
    io:format("Number:~p~n", [1]);
print(N, [H|T]) ->
    print(N-1, [H|[N|T]]),
    io:format("Number:~p~n", [N]).

print_even(N) when N>0 ->
    print_even(N, [2]).

print_even(2, List) ->
    List,
    io:format("Number:~p~n", [2]);
print_even(N, [H|T]) when N rem 2==0 ->
    print_even(N-1, [H|[N|T]]),
    io:format("Number:~p~n", [N]);
print_even(N, List) ->
    print_even(N-1, List).
%% end 3-3
