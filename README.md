# practice\_erlang\_programming


《erlang编程指南》的网站是

http://www.oreilly.com/catalog/9780596518189/

或者

http://erlangprogramming.org/ （貌似已经没有相关内容了）

# 第三章
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
