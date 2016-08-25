-module (graph).

-export ([area/1, perimeter/1]).

-include ("graph.hrl").

-define(PI, math:pi()).

%% 求图形面积
% 已知三角形的三边分别是a、b、c,
% 先算出周长的一半s=1/2(a+b+c)
% 则该三角形面积S=根号[s(s-a)(s-b)(s-c)]
% 这个公式叫海伦——秦九昭公式 △＝√[s(s-a)(s-b)(s-c)]
area(Graph) when is_record(Graph, triangle) -> % S = 1/2 * A * H
    A = Graph#triangle.a,
    B = Graph#triangle.b,
    C = Graph#triangle.c,
    if
        (A*A==(B*B+C*C)) or (B*B==(A*A+C*C)) or (C*C==(A*A+B*B)) ->
            S = perimeter(Graph)/2,
            math:sqrt(S*(S-A)*(S-B)*(S-C));
        true ->
            {error, "not is triangle"}
    end;
area(Graph) when is_record(Graph, circle) -> % S = PI*R*R
    ?PI * math:pow(Graph#circle.radius, 2);
area(Graph) when is_record(Graph, rectangle) -> % S = W*H
    Graph#rectangle.width * Graph#rectangle.height.

%% 求图形周长
perimeter(Graph) when is_record(Graph, triangle) -> % P = a+b+c
    A = Graph#triangle.a,
    B = Graph#triangle.b,
    C = Graph#triangle.c,
    if
        (A*A==(B*B+C*C)) or (B*B==(A*A+C*C)) or (C*C==(A*A+B*B)) ->
            A+B+C;
        true ->
            {error, "not is triangle"}
    end;
perimeter(Graph) when is_record(Graph, circle) -> % P = 2*PI*R
    2 * ?PI * Graph#circle.radius;
perimeter(Graph) when is_record(Graph, rectangle) -> % P = 2*(W+H)
    2*(Graph#rectangle.width + Graph#rectangle.height).
