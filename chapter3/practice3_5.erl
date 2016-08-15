-module(practice3_5).

-compile(export_all).

%% 3-5
filter([], _) ->
    [];
filter(List, N) when is_list(List), is_integer(N) ->
    [H|T] = List,
    if
        H=<N ->
            [H|filter(T, N)];
        true ->
            filter(T, N)
    end.

reverse([]) ->
    [];
reverse(List) ->
    reverse(List, []).

reverse([], List) ->
    List;
reverse(List, List2) ->
    [H|T] = List,
    reverse(T, [H|List2]).

concatenate([]) ->
    [];
concatenate(List) ->
    concatenate(List, []).

concatenate([], List) ->
    reverse(List);
concatenate(List, List2) ->
    [Head|Tail] = List,
    concatenate(Tail, concatenate_plus(List2, Head)).

concatenate_plus([],[]) ->
    [];
concatenate_plus([], List) ->
    reverse(List);
concatenate_plus(List, []) ->
    List;
concatenate_plus(List, List2) ->
    [H|Tail] = List,
    concatenate_plus(Tail, [H|List2]).

flatten([]) ->
    [];
flatten(List) ->
    [H|T] = List,
    if
        is_list(H), is_list(T) ->
            concatenate_plus(flatten(T), flatten(H));
        is_list(H) ->
            [T|flatten(H)];
        is_list(T) ->
            concatenate_plus([H], flatten(T))
    end.

%% end 3-5
