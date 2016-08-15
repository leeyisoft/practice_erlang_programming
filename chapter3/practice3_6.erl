-module(practice3_6).

-compile(export_all).

%% 3-6
quicksort([]) ->
    [];
quicksort([H|Tail]) ->
    quicksort(Tail, H, [], []).

quicksort([], A, Smaller, Bigger) ->
    quicksort(Smaller)++[A]++quicksort(Bigger);
quicksort([H|Tail], A, Smaller, Bigger) when H>=A ->
    quicksort(Tail, A, Smaller, [H|Bigger]);
quicksort([H|Tail], A, Smaller, Bigger) ->
    quicksort(Tail, A, [H|Smaller], Bigger).



mergesort([]) ->
    [];
mergesort([T]) ->
    [T];
mergesort(List) ->
    {Left, Right} = lists:split(length(List) div 2, List),
    mergesort(mergesort(Left), mergesort(Right)).

mergesort(Left, Right) ->
    mergesort(Left, Right, []).

mergesort([], [], List) ->
    List;
mergesort([], Right, List) ->
    List++Right;
mergesort(Left, [], List) ->
    List++Left;
mergesort([LHead|LTail], [RHead|_RTail]=Right, List) when LHead<RHead ->
    mergesort(LTail, Right, List++[LHead]);
mergesort(Left, [RHead|RTail], List) ->
    mergesort(Left, RTail, List++[RHead]).

%% end 3-6
