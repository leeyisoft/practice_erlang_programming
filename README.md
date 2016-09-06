# practice\_erlang\_programming


《erlang编程指南》的网站是

http://www.oreilly.com/catalog/9780596518189/

或者

http://erlangprogramming.org/ （貌似已经没有相关内容了）

# 第三章 Erlang顺序编程

## 3-1 表达式求值

### 编写一个函数sum/1，给定一个正整数N，其返还的是1~N之和。

例如：
sum(5) -> 15.

### 编写一个sum/2函数，给定两个整数N和M，其中N=<M，其返回的是N~M的整数和。如果N>M，进程异常终止。

例如： sum(1, 3) -> 6. sum(6, 6) -> 6.

```Eralng
sum(0) ->
    0;
sum(N) when N>0 ->
    N + sum(N-1).

sum(N, M) when N==M ->
    M;
sum(N, M) when N<M ->
    N + sum(N+1, M).
```

## 3-2 创建列表

### 编写一个返还格式为[1,2,..., N-1]的列表的函数。

例如：
create(3) -> [1,2,3].

### 编写一个函数返回格式为[N,N-1,...,2,1]的列表的函数。

例如：
reverse_create(3) -> [3,2,1].

```Eralng
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
```

## 3-3 边界效应

### 编写一个打印出1~N的整数的函数。

提示：使用io:format("Number:~p~n", [N]).

### 编写一个打印出1~N的偶数的函数。

提示：使用保护元。

```Erlang
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

```

## 3-4 使用列表处理数据库

编写创建一个数据库的模块db.erl，它能够存储、检索和删除元素。destroy/1函数删除数据库。考虑到Erlang有垃圾收集器，你不需要做任何事情。然后如果db模块把一切都存储在文件中，那么你也应该删除这个文件。

代码： /chapter3/db.erl

```shell
1>c(db, [debug_info]).
{ok, db}
2>Db = db:new().
[]
3>Db1 = db:write(francesco, london, Db).
[{francesco,london}]
4>Db2 = db:write(lelle, stockholm, Db1).
[{lelle,stockholm},{francesco,london}]
5>db:read(francesco, Db2).
{ok, london}
6>Db3 = db:write(joern, stockholm, Db2).
[{joern,stockholm},{lelle,stockholm},{francesco,london}]
7>db:read(ola, Db3).
{error, instance}
8>db:match(stockholm, Db3).
[joern,lelle]
9>Db4 = db:delete(lelle, Db3).
[{joern,stockholm},{francesco,london}]
10>db:match(stockholm, Db4).
[joern]
```


f().
Db = [].
Db1 = [{francesco,london}].
Db2 = [{lelle,stockholm},{francesco,london}].
Db3 = [{joern,stockholm},{lelle,stockholm},{francesco,london}].
db:delete(lelle, Db3).

## 3-5 操作列表

### 编写一个函数，给定一个整数和一个整数列表，并且返回所有小于或等于该整数的整数。
例如： filter([1,2,3,4,5], 3) -> [1,2,3].

chapter3:filter([1,2,3,4,5], 3).
chapter3:filter([1,2,3,4,5], -1).
chapter3:filter([-1,-2,3,4,5], -1).

### 编写一个函数，给定一个列表，颠倒其中元素的顺序进行排列。
例如： reverse([1,2,3]) -> [3,2,1].

### 编写一个函数，给定一个列表的列表，将他们连接起来。
例如： concatenate([[1,2,3],[],[4,five]]) -> [1,2,3,4,five].
提示： 你需要使用一个帮助函数并且通过多个步骤来串联列表。

chapter3:concatenate([[1,2],[],[3,4], [],[5,6],[7,8],[9,ten]]).
chapter3:concatenate([[2,1],[],[3,4], [],[6,5],[7,8],[9,ten]]).

### 编写一个函数，给定一个嵌套列表的列表，返回一个拉平的列表。
例如：flatten([[1,[2,[3],[]]],[[[4]]], [5,6]]) -> [1,2,3,4,5,6].
提示：使用concatenate来解决flatten。

chapter3:flatten([[1,[2,[3],[]]],[[[4]]], [5,6]]).


## 3-6 列表排序

## 快速排序

chapter3:quicksort([3,1,5,2,6]).

chapter3:quicksort([4,3,1,5,2,6]).

chapter3:quicksort([3,1,5,2,6,10,33]).

自己花费了一个多小时没有搞定，参考了别人的，才明白。
参考了 http://www.oschina.net/code/snippet_97079_3759 代码；

## 合并排序

chapter3:mergesort([3,1,5,2,6,10,33]).
chapter3:mergesort([3,1,5,2]).

参考 http://blog.csdn.net/hjhjava/article/details/46434441 做出来了，有一点儿理解了，估计下次又会忘记怎么做

## 3-7 使用库模块

使用lists库函数实现3-4的数据库处理类别。保持相同的db模块接口，让你的两个模块可以互换。

代码： /chapter3/db2.erl
每个API基本上一行代码就搞定了，唯独 match/2 写的不怎么高效（看了相关手册，没有找到更合适的内置函数处理“获取模式匹配的Value的所有key”，自己用内置函数转换了一下）

## 3-8 表达式求值和编译
代码： /chapter3/compiler.erl (没有完成)
这个练习要求你建立一个操作算术表达式的函数集合。以如下的表达式开始：

```
((2+3)-4)4~((2*3)+(3*4))
```
这完全置于括号内，并会用波形符（~）来表示一元运算符符号。

首先，编写一个解析器，是的它们转换成Erlang的表达式，比如：

```
{minus, {plus, {num, 2}, {num, 3}}, {num, 4}}
```
[
    '(',
    ['(',2,'+',3,')'],
    '-',
    4,
    ')'
]

它表示了((2+3)-4) 。我们叫他exps。现在，编写一些函数：

* compile，它转换一个exp为堆栈机的系列代码，用于对exp求值；
* evaluator，它接受一个exp，然后返回它的值；
* pretty printer，它可以把exp转换成一个字符串表示；
* simulator，它为堆栈机实现表达式；
* simplifier，这将简化表达式，是0*ez转化为0，1*e为e等，（有很多其他的想法！）

你还恶意添加条件来扩展表达式的机会：

```
if ((2+3)-4) then 4 else ~ ((2*3)+(3+4))
```

如果“if”表达式的是为0，则返回“then”值，否则返回“else”值。

你还可以添加诸如一下的局部定义：

```
let c = ((2+3)-4) in ~ ((2*c)+(3*4))
```

或者，你可以添加变量，接着赋值，这样就可以在随后的表达式中使用。

对于所有这些扩展，你可以考虑如何修改你已经编写过的函数。

## 3-9 索引

和原题点出入，列表里面只能够是整数

```shellerlang
index:chpattern([1,1,2,3,4,5]).
```
代码： /chapter3/index.erl

## 3-10 文本处理

### 编写一个函数，它会使用未结构化的文本，并将其转换为填补文本，当你按下一个空白行时，停止填充。
代码： /chapter3/text.erl

```shellerlang
45> c(text).
{ok,text}
46> text:format("text.txt").
```
结果输出到 text_format.txt 文件里面

# 第四章 并发编程

## example4-1 example_echo进程
代码： /chapter4/example_echo.erl
## example4-2 echo进程
代码： /chapter4/example_echo2.erl

```shellerlang
11> c(example_echo2).
{ok,example_echo2}
12> example_echo2:go().
hello
ok
13> self().
<0.33.0>
14> whereis(example_echo2).
<0.81.0>
15> whereis(example_echo).
undefined
16> whereis(example_echo2).
<0.81.0>
17> regs().

** Registered procs on node nonode@nohost **
Name                  Pid          Initial Call                      Reds Msgs
application_controlle <0.7.0>      erlang:apply/2                     404    0
code_server           <0.12.0>     erlang:apply/2                  156718    0
example_echo2                 <0.92.0>     example_echo2:loop/0                         3    0
erl_prim_loader       <0.3.0>      erlang:apply/2                  785482    0
error_logger          <0.6.0>      gen_event:init_it/6                227    0
file_server_2         <0.20.0>     file_server:init/1                3218    0
global_group          <0.19.0>     global_group:init/1                 53    0
global_name_server    <0.15.0>     global:init/1                       45    0
inet_db               <0.18.0>     inet_db:init/1                     234    0
init                  <0.0.0>      otp_ring0:start/2                 2462    0
kernel_safe_sup       <0.29.0>     supervisor:kernel/1                 56    0
kernel_sup            <0.11.0>     supervisor:kernel/1               2016    0
rex                   <0.14.0>     rpc:init/1                          21    0
standard_error        <0.22.0>     erlang:apply/2                       9    0
standard_error_sup    <0.21.0>     supervisor_bridge:standar           34    0
user                  <0.25.0>     group:server/3                      36    0
user_drv              <0.24.0>     user_drv:server/2                15920    0

** Registered ports on node nonode@nohost **
Name                  Id              Command
ok
18> example_echo2 ! stop.
stop

```

## my_timer

代码： /chapter4/my_timer.erl

```shellerlang
29> c(my_timer).
{ok,my_timer}
30> my_timer:send_after(3000, "hello leeyi").
<0.108.0>
31> flush().
ok
32> flush().
Shell got "hello leeyi"
ok
33> flush().
ok
```

## 性能基准测试


代码： /chapter4/myring.erl

* tc(Module, Function, Arguments) -> {Time, Value}

    Types:

    Module = module()
    Function = atom()
    Arguments = [term()]
    Time = integer()
    In microseconds
    Value = term()
    tc/3
    Evaluates apply(Module, Function, Arguments) and measures the elapsed real time as reported by os:timestamp/0.

    Returns {Time, Value}, where Time is the elapsed real time in microseconds, and Value is what is returned from the apply.

    tc/2
    Evaluates apply(Fun, Arguments). Otherwise the same as tc/3.

    tc/1
    Evaluates Fun(). Otherwise the same as tc/2.



```shellerlang
34> c(myring).
{ok,myring}
35> timer:tc(myring, start, [100000]).
{116895,ok} %% 10W 0.1s多
36> timer:tc(myring, start, [1000000]).
{1283310,ok} %% 100W 1.2s多
37> timer:tc(myring, start, [10000000]).
{13522793,ok} %% 1000W 13s多
```

## 4-1 echo 服务器

代码： /chapter4/echo.erl
net_adm:ping(t@ddg).

rpc:call(t@ddg, echo, stop, []).

rpc:call(t@ddg, echo, print, [he]).

## 4-2 进程环

代码： /chapter4/ring.erl

process_1 ! stop.

regs();

registered().

ring:start(3, 5, hello).

```shellerang
(t@LeeMac)1> c(ring).
{ok,ring}
(t@LeeMac)2> ring:start(3, 5, hello).
 ring:start(1, 5, hello).
```
不能够停止，请 Ctr+C 再输入 a终止

# 第五章 进程设计模式

## 客户端服务器模型

代码： /chapter5/frequency.erl

## 进程模式实例
代码： /chapter5/server.erl

## 有限转态机
代码： /chapter5/fsm.erl

## 事件管理器和句柄

代码： /chapter5/event_manager.erl
代码： /chapter5/log_handler.erl
代码： /chapter5/io_handler.erl

```shellerlang
c(event_manager, [debug_info]), c(log_handler, [debug_info]), c(io_handler, [debug_info]).

debugger:start().
(t1@ddg)14> event_manager:start(alarm, [{log_handler, "AlarmLog.log"}]).
ok
(t1@ddg)15> event_manager:send_event(alarm, {raise_alarm, 10, cabinet_open}).
ok
(t1@ddg)16> event_manager:add_handler(alarm, io_handler, 1).
ok
(t1@ddg)17> event_manager:send_event(alarm, {clear_alarm, 10, cabinet_open}).
#1,2016:08:18,11:20:09,clear,10,cabinet_open
ok
(t1@ddg)18> event_manager:send_event(alarm, {event, 156, link_up}).
ok
(t1@ddg)19> event_manager:get_data(alarm, io_handler).
{data,2}
(t1@ddg)20> event_manager:delete_handler(alarm, stats_handler).
{error,instance}
event_manager:delete_handler(alarm, io_handler).
{error,instance}
(t1@ddg)21> event_manager:stop(alarm).
[{io_handler,{count,2}},{log_handler,ok}]


```

## 5-1 一个数据库服务器

代码： /chapter5/my_db.erl

## 5-2 更改频段服务器

代码： /chapter5/my_db.erl
里面“而这以前可以通过多次调用allocate_frequency/0来实现。”这一句没有看懂，貌似也没有什么关系吧

```erlangshell
(t@LeeMac)79> c(frequency2).
{ok,frequency2}
(t@LeeMac)80> frequency2:start().
true
(t@LeeMac)81> frequency2:allocate().
{ok,10}
(t@LeeMac)82> frequency2:allocate().
{ok,11}
(t@LeeMac)83> frequency2:allocate().
{ok,12}
(t@LeeMac)84> frequency2:allocate().
{error,"pid allocated more 3"}
(t@LeeMac)85> frequency2:get_data().
{[13,14,15],[{12,<0.145.0>},{11,<0.145.0>},{10,<0.145.0>}]}
(t@LeeMac)86> frequency2:allocate().
{error,"pid allocated more 3"}

```

## 5-3 交换句柄

代码： /chapter5/event_manager.erl/swap_handlers/3

```erlangshell
event_manager:swap_handlers(alarm, io_handler, log_handler). % 会报错
event_manager:swap_handlers(alarm, log_handler, io_handler).  % 可行
```
原因是：“请把OldHandler:terminate/1的返回值传递到NewHandler:init/调用。”，不知道作者为什么调添加这句话，而不是这么实现 ：
```erlang
event_manager:swap_handlers(Name, OldHandler, NewHandler, NewHandlerInitData)
```

## 5-4 事件统计

代码： /chapter5/stats_handler.erl
貌似就这么简单的实现了
```erlangshell
event_manager:start(alarm, [{log_handler, "AlarmLog.log"}, {stats_handler, []}]).

event_manager:send_event(alarm, {raise_alarm, 10, cabinet_open}).

event_manager:get_data(alarm, io_handler).

31> event_manager:get_data(alarm, log_handler).
{data,<0.83.0>}
32> event_manager:get_data(alarm, stats_handler).
{data,[{{clear_alarm,cabinet_open},2},
       {{alarm,cabinet_open},4},
       {{raise_alarm,cabinet_open},2}]}
33> event_manager:stop(alarm).
[{log_handler,ok},
 {stats_handler,[{{clear_alarm,cabinet_open},2},
                 {{alarm,cabinet_open},4},
                 {{raise_alarm,cabinet_open},2}]}]
```

5-5 FSM电话

代码： /chapter5/fsm.erl

还不太会做，先放一放。

# 第六章 进程错误处理机制

让它崩溃，让别人来处理它。 早崩溃。

## 进程链接和退出信号


代码：chapter6/add_one.erl
代码：chapter6/add_two.erl

* 传播语法

|Reason |正常退出 trap_exit=true     | 非正常退出 trap_exit=false|
|:------------- |:-------------| :-----|
|normal |收到{'EXIT', Pid, normal}  | 没有任何事情发生|
|kill   |当Reason时kill时，则无条件终止|当Reason是kill时，则无条件终止|
|other  |收到{'EXIT', Pid, Other}   | 当Reason是other时，则无条件终止|
```erlangshell
5> c(add_one).
{ok,add_one}
6> process_flag(trap_exit, true).
false
7> self().
<0.33.0>
8> add_one:start().
true
9> self().
<0.33.0>
10> add_one:request(one).

=ERROR REPORT==== 19-Aug-2016::21:04:28 ===
Error in process <0.49.0> with exit value:
{badarith,[{add_one,loop,0,[{file,"add_one.erl"},{line,21}]}]}
timeout
11> self().
<0.33.0>
12> flush().
Shell got {'EXIT',<0.49.0>,
                  {badarith,[{add_one,loop,0,
                                      [{file,"add_one.erl"},{line,21}]}]}}
ok
13> flush().
ok
```

## 系统健壮性

代码：chapter6/frequency.erl

```erlangshell
3> c(frequency, [debug_info]).
{ok,frequency}
4> frequency:start().
true
5> frequency:allocate().
{ok,10}
6> self().
<0.33.0>
7> exit(self(), kill).
** exception exit: killed
8> self().
<0.53.0>
9> frequency:allocate().
{ok,10}
10> frequency:stop().
```

## 监控进程实例

监控进程的唯一任务是启动工作进程并监控。

spawn_link/3 启动成功 返回元组 {ok, Pid}, 失败返回

代码：chapter6/my_supervisor.erl

```erlangshell
Eshell V7.3  (abort with ^G)
1> c(my_supervisor).
{ok,my_supervisor}
2> my_supervisor:start_link(my_supervisor, [{add_two, start, []}]).
ok
3> self().
<0.33.0>
4> whereis(add_two).
<0.42.0>
5> exit(whereis(add_two,), kill).
* 1: syntax error before: ')'
5> exit(whereis(add_two), kill).
true
6> add_two:request(100).
102
7> whereis(add_two).
<0.46.0>
8> self().
<0.33.0>
```

## 6-1 链接Ping Pong 服务器


代码：chapter6/echo.erl

```erlangshell
1> c(echo).
{ok,echo}
2> echo:start().
start self pid: <0.33.0>
true
3> whereis(echo).
<0.40.0>
4> self().
<0.33.0>
5> echo:stop().
ok
6> self().
<0.33.0>
7> whereis(echo).
<0.40.0>
8> flush().
Shell got {'EXIT',<0.33.0>,normal}
ok
9>
```
上面的代码证明：
执行 echo:stop() -> exit(self(), normal).
{'EXIT',<0.33.0>,normal} 没有终止，消息也没有传递到 echo（<0.40.0>）

* 暂时还不知道问题出在了那里？

问题出在下面，“如果 Reason 是 normal，Pid 将不会退出。”

```erlangshell
exit(Pid, Reason) -> true
```
    向进程 Pid 以 Reason 退出原因发出一个退出信号。

    如果进程 Pid 没有捕捉退出，那么进程将会以 Reason 的退出原因退出。如果进程 Pid 有捕捉退出，退出信号将转变为 {'EXIT', From, Reason} 格式的消息投送到进程的消息队列。From 是发送退出信号的进程的 pid。

    如果 Reason 是 normal，Pid 将不会退出。如果进程捕捉了退出，，退出信号将转变为 {'EXIT', From, Reason} 格式的消息投送到进程的消息队列。

    如果 Reason 是 kill，那么将给进程 Pid 发送一条不可捕获的退出信号，进程接收到信号后将以 killed 的原因无条件退出。


## 6-2 一个可靠的互斥信号量


代码：chapter6/mutex2.erl

抄袭的 http://www.oschina.net/code/snippet_144663_4418 ， 自己还不会写，先理解理解吧

```erlangshell
1> c(mutex2).
{ok,mutex2}
2> mutex2:start().
server pid is <0.40.0>.
ok
3> mutex2:wait().
<0.33.0>.
Signal is allocated. Linked.
ok
4> A = spawn(mutex2, wait, []).
<0.43.0>.
<0.43.0>
5> B = spawn(mutex2, wait, []).
<0.45.0>.
<0.45.0>
6> exit(A, 123).
true
7> mutex2:signal().
Client is down. Signal return.<0.43.0> noproc.
Signal return. Unlinked
Signal is allocated. Linked.
ok
Client is down. Signal return.<0.45.0> normal.
8> process_flag(trap_exit, false).
false
9> flush().
ok
10> try link(A)
10> catch error:_ -> 43 end.
43
11> flush().
ok
12> process_flag(trap_exit, true).
false
13> flush().
ok
14> link(A).
true
15> flush().
Shell got {'EXIT',<0.43.0>,noproc}
ok
16> self().
<0.33.0>
```

## 6-3 监控进程

暂时搞不定先放一放，继续后面的。

# 第七章 记录和宏

## 记录

代码：chapter7/tuples1.erl

## 介绍记录

## 操作记录

## 基于记录的函数和模式匹配

代码：chapter7/records1.erl

## 终端的记录

[Using Record in Erlang Shell](http://www.cnblogs.com/me-sa/archive/2011/12/31/erlang0027.html)

(t@LeeMac)23> c(records1).
{ok,records1}
(t@LeeMac)24> records1:joe().
{person,"Joe",21,"999-999"}
(t@LeeMac)25> records1:birthday(#person{age=30}).
* 1: record person undefined
(t@LeeMac)26> records1:birthday(#person{age=30}).
* 1: record person undefined
(t@LeeMac)27> rr(records1).
[person]
(t@LeeMac)28> c(records1).
{ok,records1}
(t@LeeMac)29> rr(records1).
[person]
(t@LeeMac)30> Person = #person{name="Mike", age=30}.
#person{name = "Mike",age = 30,phone = []}
(t@LeeMac)31> Person#person.age+1.
31
(t@LeeMac)32> NewPerson=Person#person{phone=5697}.
#person{name = "Mike",age = 30,phone = 5697}
(t@LeeMac)33> rd(name, {first, surname}).
name
(t@LeeMac)34> NewPerson=Person#person{name=#name{first="Mike", surname="Williams"}}.
** exception error: no match of right hand side value
                    #person{name = #name{first = "Mike",surname = "Williams"},
                            age = 30,phone = []}
(t@LeeMac)35> NewPerson=Person#person{name = #name{first="Mike", surname="Williams"}}.
** exception error: no match of right hand side value
                    #person{name = #name{first = "Mike",surname = "Williams"},
                            age = 30,phone = []}
(t@LeeMac)36> NewPerson2 = Person#person{name = #name{first="Mike", surname="Williams"}}.
#person{name = #name{first = "Mike",surname = "Williams"},
        age = 30,phone = []}
(t@LeeMac)37> FirstName = (NewPerson#person.name)#name.first.
** exception error: {badrecord,name}
(t@LeeMac)38> FirstName = (NewPerson2#person.name)#name.first.
"Mike"
(t@LeeMac)39> rl().
-record(name,{first,surname}).
-record(persion,{name,age = 0,phone = ""}).
-record(person,{name,age = 0,phone = ""}).
ok
(t@LeeMac)40> Person=Person#persion{name=#name{first="Chris", surname="Williams"}}.
** exception error: {badrecord,persion}

## 记录实现

## 参数化宏

## 调试和宏
打开系统调试
```
c(Module, [{d, debug}]).

c(Module, [{i, Dir}]).

```
例如
```
c(macros1, [{d, debug}]).

c(macros1, ['E']).
c(macros1, ['P']).   
```
* ?MODULE
* ?MODULE_STRING
* ?FILE
* ?LINE
* MACHINE % 目前（2016-08-23）一直是  BEAM

```
-undef(Flag).

-ifdef(Flag).

-ifndef(Flag).

-else.

-endif.


```

## include文件

在模块中使用 -include指令，其通常放置在 module和export指令之后
```
-include("File.hrl").
```
其中，文件名两边的双引号是强制性的。包含文件贷后后缀.hrl，但不是强制的。

## 7-1 扩展记录

代码：chapter7/p7_1.erl
通过下面执行，只有 showPerson需要修改
```erlangshell
52> c(p7_1).
{ok,p7_1}
53> rr(p7_1).
[person]
54> records:joe().
** exception error: undefined function records:joe/0
55> records:joe().
records1    p7_1    
55> p7_1:joe().
#person{name = "Joe",age = 21,phone = "999-999",
        address = []}
56> p7_1:birthday(#person{age=3}).
#person{name = undefined,age = 4,phone = [],address = []}
57> p7_1:showPerson(#person{}).
name:undefined age:0 phone:[]
ok
58> p7_1:showPerson(#person{address="hh"}).
name:undefined age:0 phone:[]
ok

61> c(p7_1).                               
{ok,p7_1}
62> p7_1:showPerson(#person{address="hh"}).
name:undefined age:0 phone:[] address:"hh"
```
## 7-2 记录保护元

代码：chapter7/p7_2.erl
通过下面执行，只有 showPerson需要修改
```erlangshell
69> c(p7_2).                                                  
{ok,p7_2}
70> p7_2:boobar({persion,"leeyi"}).
P is not recard: {persion,"leeyi"}
ok
71> p7_2:boobar(#person{name="leeyi"}).
name:"leeyi" age:0 phone:[] address:[]
ok
72> p7_2:boobar(#person{name="leeyi"}).
name:"leeyi" age:0 phone:[] address:[]
```

## 7-3 db.erl练习回顾

代码：chapter7/db.erl

需要先编译了模型，之后才能够用 rr 加载模型的记录

```erlangshell
1> c(db).
{ok,db}
2> rr(db).
[kv]
3> Db = db:new().
[]
4> Db1 = db:write(#kv{key=leeyi, value="aaa", Db).
* 1: syntax error before: ')'
4> Db1 = db:write(#kv{key=leeyi, value="aaa"}, Db).
[#kv{key = leeyi,value = "aaa"}]
5> b().
Db = []
Db1 = [#kv{key = leeyi,value = "aaa"}]
ok
6> Db2 = db:write(#kv{key=leeyi2, value="bbb"}, Db1).
[#kv{key = leeyi2,value = "bbb"},
 #kv{key = leeyi,value = "aaa"}]
7> Db3 = db:write(#kv{key=wangli, value="ccc"}, Db2).
[#kv{key = wangli,value = "ccc"},
 #kv{key = leeyi2,value = "bbb"},
 #kv{key = leeyi,value = "aaa"}]
8> db:match(leeyi, Db3).
[]
9> db:match(bbb, Db3).  
[]
10> db:match("bbb", Db3).
["bbb"]
11> Db4 = db:write(#kv{key=wangli, value="aaa"}, Db3).
[#kv{key = wangli,value = "aaa"},
 #kv{key = wangli,value = "ccc"},
 #kv{key = leeyi2,value = "bbb"},
 #kv{key = leeyi,value = "aaa"}]
12> db:match("aaa", Db4).                             
["aaa","aaa"]
13> c(db).
{ok,db}
14> db:match("aaa", Db4).
[wangli,leeyi]
15> db:match("aaac", Db4).
[]
16> c(db).
{ok,db}
17> db:delete(leeyi2, Db4).
[#kv{key = wangli,value = "aaa"},
 #kv{key = wangli,value = "ccc"},
 #kv{key = leeyi,value = "aaa"}]

```

## 7-4 记录和形状

代码：chapter7/graph.erl

```erlangshell
1> c(graph).
{ok,graph}
2> rr(graph).
[circle,rectangle,triangle]
3> graph:area(#circle{radius=16}).
804.247719318987
4> graph:area(#rectangle{width=10, height=20.1}).
201.0
5> graph:area(#triangle{a=3,b=4,c=5}).     
6.0
6> graph:area(#triangle{a=3,b=4,c=7}).
{error,"not is triangle"}
7>graph:perimeter(#circle{radius=16}).
100.53096491487338
8>graph:perimeter(#rectangle{width=10, height=20.1}).
60.2
9> graph:perimeter(#triangle{a=3,b=4,c=5}).
12
10> graph:perimeter(#triangle{a=3,b=4,c=7}).
{error,"not is triangle"}

```

## 7-5 二叉树记录

第一感觉自己不会写，阅读了 http://www.tuicool.com/articles/Af2IRv 的代码，感觉很轻松，一口气读完了；自己理解这写了一遍

代码：chapter7/binary_tree.erl

```erlangshell


Bt1 = #btree{value = 1,ltree = nil,rtree = nil}.

Bt2 = #btree{value = 4,
                ltree = #btree{value = 3,ltree = nil,rtree = nil},
                rtree = #btree{value = 5,ltree = nil,rtree = nil}}
Bt3 = #btree{value = 4,
                ltree = #btree{value = 6,ltree = nil,rtree = nil},
                rtree = #btree{value = 5,ltree = nil,rtree = nil}}

Bt4 = #btree{value = 4,
                ltree = Bt3,
                rtree = #btree{value = 5,ltree = nil,rtree = nil}}

B1 = binary_tree:insert(#btree{value = 6}, a).
B2 = binary_tree:insert(#btree{value = 2}, B1).
B3 = binary_tree:insert(#btree{value = 10}, B2).
B4 = binary_tree:insert(#btree{value = 5}, B3).

B5 = binary_tree:insert(#btree{value = 1}, B4).

B6 = binary_tree:insert(#btree{value = 3}, B5).

B7 = binary_tree:insert(#btree{value = 8}, B4).
B8 = binary_tree:insert(#btree{value = 7}, B7).
B9 = binary_tree:insert(#btree{value = 9}, B8).


```

## 7-6 参数化宏

代码：chapter7/binary_tree.erl


# 第八章 软件升级

## 升级模块

代码：chapter8/db.erl

```shell
2> self().
<0.33.0>
3> c("chapter8/db").
{ok,db}
4> Db = db:new().
5> Db1 = db:write(francesco, san_francisco, Db).
6> Db2 = db:write(alison, london, Db1).
7> db:read(francesco, Db2).
** exception error: no case clause matching san_francisco
     in function  db:read/2 (chapter8/db.erl, line 14)

```

修改db.erl，之后执行

```shell
c("chapter8/db").       
{ok,db}
13> db:read(francesco, Db2).
{ok,san_francisco}
15> db:module_info(attributes).
[{vsn,['1.0.1']}]
```

## 幕后

在任何时候，一个模块的两个版本都可以加载到运行时系统。我们称它们为旧的和当前的版本。

代码：chapter8/modtest2.erl

```shell
18> c("chapter8/modtest2").
{ok,modtest2}
19> modtest2:main().
true
20> modtest2:do(99).
101
```

修改代码，升级 a/1 函数的定义如下：
```erlang
a(N) ->
    N.
```
重新编译，效果如下：
```shell
18> c("chapter8/modtest2").
{ok,modtest2}
19> modtest2:main().
true
20> modtest2:do(99).
101
21> c("chapter8/modtest2").
{ok,modtest2}
22> modtest2:do(99).
101
```

明显没有发生变化。把 a/1 调用修改为一个完全限定的函数调用：

```erlang
loop() ->
    receive
        {Sender, N} ->
            Sender ! modtest2:a(N)
    end,
    loop().
```

```shell
33> c("chapter8/modtest2").
{ok,modtest2}
34> modtest2:do(99).
99

```


## 载入代码

* 通过调用一个尚未加载的模块中的函数载入代码；
* 使用c(Module)终端命令，compile:file(Module)，或者他的派生函数之一；
* 通过调用code:load_file(Module)显示的加载一个模块，在终端中使用l(Module)；

## 代码服务器

## 清除模块

code:purge(Module) 去掉或者清除模块的旧版本，但是如果任何程序正在运行这些代码，它们将首先被终止，之后删除旧版本代码。调用的结果是，如果有任何程序被终止了该函数返回true，否则返回false。

如果不想终止任何正在运行的旧版本代码的程序，请使用 code:soft_purge(Module)。这个调用只有子啊没有进程运行这些代码时，才会删除该模块的旧版本。如果有任何进程仍在运行这个代码，他会返回false，其他什么也不做。如果成功删除旧模块，他会返回true。

## 升级过程

代码：chapter8/db_server.erl

## 例8-1：软件升级活动

升级前准备活动
```shell
practice_erlang_programming/chapter8 [master●] » mkdir patches
practice_erlang_programming/chapter8 [master●] » cd patches
chapter8/patches [master●] » erlc db.erl 
```

```shell
1> cd("chapter8").
/Users/leeyi/workspace/erl/practice_erlang_programming/chapter8
ok
2> make:all([load]).
Recompile: db
up_to_date
3> db:module_info(attributes).
[{vsn,['1.0.1']}]
5> db_server:start().
true
6> db_server:write(francesco, san_francisco).
{write,francesco,san_francisco}
7> db_server:write(alison, london).          
{write,alison,london}
8> db_server:read(alison).
{ok,london}
9> db_server:read(martin).
{error,instance}
10> code:add_patha("/Users/leeyi/workspace/erl/practice_erlang_programming/chapter8/patches").
true
11> code:load_file(db).
{module,db}
12> code:soft_purge(db).
true
13> db_server:upgrade(dict).
{upgrade,dict}
14> db:module_info(attributes).
[{vsn,['1.0.2']}]
15> db_server:write(martin, cairo).
{write,martin,cairo}
16> db_server:read(francesco).
{ok,san_francisco}
17> db_server:read(martin).
{ok,cairo}
```
