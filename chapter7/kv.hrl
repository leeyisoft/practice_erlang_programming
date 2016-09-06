-define(dbg(Str, Args), io:format(Str, Args)).

-record(kv, {key, value}).
