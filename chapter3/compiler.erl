-module(compiler).

-export([compile/1, evaluator/1, pretty_printer/1, simulator/1, simplifier/1]).

-export([list_to_term/1]).

%% 它转换一个exp为堆栈机的系列代码，用于对exp求值；
-spec compile(Exp) -> Str when
    Exp::tuple(),
    Str::string().

%% 它接受一个exp，然后返回它的值；
-spec evaluator(Exp) -> Value when
    Exp::any(),
    Value::term().

%% 它可以把exp转换成一个字符串表示
-spec pretty_printer(Exp) -> ExpStr when
    Exp::any(),
    ExpStr::string().


%% 它为堆栈机实现表达式
-spec simulator(Exp) -> Str when
    Exp::any(),
    Str::string().

%% 这将简化表达式，是0*ez转化为0，1*e为e等
-spec simplifier(Exp) -> Str when
    Exp::any(),
    Str::string().
%% api
%% 解析代码

% compile({num, Num}) when is_integer(Num) ->
%     integer_to_list(Num);
% compile({num, Num}) when is_float(Num) ->
%     float_to_list(Num);
compile({num, Num}) ->
    Num;
compile({Sign, Parm1, Parm2}) ->
    compile(Sign, Parm1, Parm2).

compile(Sign, Parm1, Parm2) when is_atom(Sign) ->
    % "("++compile(Parm1)++compile_sign(Sign)++compile(Parm2)++")".
    ['(',compile(Parm1), compile_sign(Sign), compile(Parm2), ')'].

compile_sign(Sign) when is_atom(Sign) ->
    case Sign of
        % plus -> "+";
        % minus -> "-";
        % multiply -> "*";
        % division -> "/"
        plus -> '+';
        minus -> '-';
        multiply -> '*';
        division -> '/'
    end.

% evaluator(['(',Parm1,Sign,Parm2,')']) ->
%     ok;
evaluator(Exp) ->
    {ok,Scanned,_} = erl_scan:string(Exp++"."),
    {ok,Parsed} = erl_parse:parse_exprs(Scanned),
    {value, Value,_} = erl_eval:exprs(Parsed,[]),
    Value.

pretty_printer(Exp) ->
    [].
simulator(Exp) ->
    [].
simplifier(Exp) ->
    [].
%% end api

list_to_term(String) ->
    {ok, T, _} = erl_scan:string(String++"."),
    case erl_parse:parse_term(T) of
        {ok, Term} ->
            Term;
        {error, Error} ->
            Error
    end.
