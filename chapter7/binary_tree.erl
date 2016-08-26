-module (binary_tree).

-export ([sum/1, max/1, is_sorted/1, is_leaf/1, insert/2]).
-export ([test/0]).

-record (btree, {value, ltree=nil, rtree=nil}).

%% 求和
sum(#btree{value=Value, ltree=nil, rtree=nil}) ->
    Value;
sum(#btree{value=Value, ltree=LTree, rtree=nil}) ->
    Value+sum(LTree);
sum(#btree{value=Value, ltree=nil, rtree=RTree}) ->
    Value+sum(RTree);
sum(#btree{value=Value, ltree=LTree, rtree=RTree}) ->
    Value+sum(LTree)+sum(RTree).

%% 求最大值
max(#btree{value=Value, ltree=nil, rtree=nil}) ->
    Value;
max(#btree{value=Value, ltree=LTree, rtree=nil}) ->
    erlang:max(Value, max(LTree));
max(#btree{value=Value, ltree=nil, rtree=RTree}) ->
    erlang:max(Value, max(RTree));
max(#btree{value=Value, ltree=LTree, rtree=RTree}) ->
    erlang:max(Value, erlang:max(max(LTree), max(RTree))).

%% 是否是叶子节点
is_leaf(#btree{value=_Value, ltree=nil, rtree=nil}) ->
    true;
is_leaf(_) ->
    false.

%% 是否是有序的二叉树
is_sorted(#btree{value=_Value, ltree=nil, rtree=nil}) ->
    true;
is_sorted(#btree{value=Value, ltree=#btree{value=LValue, ltree=nil, rtree=nil}, rtree=nil}) ->
    if
        Value>=LValue ->
            true;
        true ->
            false
    end;
is_sorted(#btree{value=Value, ltree=LTree, rtree=nil}) ->
    #btree{value=LValue} = LTree,
    if
        Value>=LValue ->
            is_sorted(LTree);
        true ->
            false
    end;
is_sorted(#btree{value=Value, rtree=#btree{value=RValue, ltree=nil, rtree=nil}, ltree=nil}) ->
    if
        Value>=RValue ->
            false;
        true ->
            true
    end;
is_sorted(#btree{value=Value, rtree=RTree, ltree=nil}) ->
    #btree{value=RValue} = RTree,
    if
        Value>=RValue ->
            is_sorted(RTree);
        true ->
            true
    end;
is_sorted(#btree{value=Value, ltree=LTree, rtree=RTree}) ->
    #btree{value=LValue} = LTree,
    #btree{value=RValue} = RTree,
    LSorted = is_sorted(LTree),
    RSorted = is_sorted(RTree),
    if
        LSorted and RSorted and (RValue>=Value) and (Value>=LValue) ->
            true;
        true ->
            false
    end.


insert(#btree{value=_Value}=T, Tree) when not is_record(Tree, btree) ->
    T;
insert(#btree{value=Value}=T, #btree{value=ParentValue, ltree=nil, rtree=nil}=Tree) ->
    if
        Value =< ParentValue  ->
            Tree#btree{ltree = T};
        true ->
            Tree#btree{rtree = T}
    end;
insert(#btree{value=Value}=T, #btree{value=ParentValue, ltree=LTree, rtree=nil}=Tree) ->
    #btree{value=LChildValue} = LTree,
    if
        Value =< ParentValue   ->
            % Tree#btree{ltree = insert(T, LTree)};
            if
                Value =< LChildValue ->
                    Tree#btree{ltree = insert(T, LTree)};
                true ->
                    Tree#btree{ltree = #btree{value=Value, ltree=LTree}}
            end;
        true ->
            Tree#btree{rtree = T}
    end;
insert(#btree{value=Value}=T, #btree{value=ParentValue, ltree=nil, rtree=RTree}=Tree) ->
    #btree{value=RChildValue} = RTree,
    if
        Value =< ParentValue   ->
            Tree#btree{ltree = T};
        true ->
            % Tree#btree{rtree = insert(T, RTree)}
            if
                Value =< RChildValue ->
                    Tree#btree{rtree = #btree{value=Value, rtree=RTree}};
                true ->
                    Tree#btree{rtree = insert(T, RTree)}
            end
    end;
insert(#btree{value=Value}=T, #btree{value=ParentValue, ltree=LTree, rtree=RTree}=Tree) ->
    #btree{value=LChildValue} = LTree,
    #btree{value=RChildValue} = RTree,
    if
        Value =< ParentValue   ->
            % Tree#btree{ltree = insert(T, LTree)};
            if
                Value =< LChildValue ->
                    Tree#btree{ltree = insert(T, LTree)};
                true ->
                    Tree#btree{ltree = #btree{value=Value, ltree=LTree}}
            end;
        true ->
            % Tree#btree{rtree = insert(T, RTree)}
            if
                Value =< RChildValue ->
                    Tree#btree{rtree = #btree{value=Value, rtree=RTree}};
                true ->
                    Tree#btree{rtree = insert(T, RTree)}
            end
    end.

test() ->
    B1 = binary_tree:insert(#btree{value = 6}, a),
    B2 = binary_tree:insert(#btree{value = 2}, B1),
    B3 = binary_tree:insert(#btree{value = 7}, B2),
    B4 = binary_tree:insert(#btree{value = 5}, B3),
    io:format("B4 is ~p ~n", [B4]),
    Bt = #btree{value = 4,
                    ltree = #btree{value = 3,ltree = nil,rtree = nil},
                    rtree = #btree{
                        value = 5,ltree = nil,
                        rtree = #btree{value = 6,ltree = nil,rtree = nil}
                    }
                },
    io:format("Bt is_sorted ~p ~n", [is_sorted(Bt)]),
    Bt2 = #btree{value = 4,
                    ltree = #btree{value = 3,ltree = nil,rtree = nil},
                    rtree = #btree{
                        value = 5,ltree = nil,
                        rtree = #btree{value = 1,ltree = nil,rtree = nil}
                    }
                },
    io:format("Bt2 is_sorted ~p ~n", [is_sorted(Bt2)]),

    % Btree1 = #btree{value=1},
    Btree2 = #btree{value=4,
      ltree=#btree{value=3},
      rtree=#btree{value=5}},
    % Btree3 = #btree{value=3, % Btree3是有序的
    %   ltree=#btree{value=2},
    %   rtree=Btree2},
    % Btree4 = #btree{value=1,
    %   ltree=#btree{value=2},
    %   rtree=#btree{value=3}},
    % Btree5 = insert(1, Btree3), % Btree5也是有序的
    % io:format("~p~n", [Btree2]),
    max(Btree2).
