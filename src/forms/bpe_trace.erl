-module(bpe_trace).
-copyright('Maxim Sokhatsky').
-export([doc/0,id/0,new/3]).
-include_lib("bpe/include/bpe.hrl").
-include_lib("nitro/include/nitro.hrl").

doc() -> "This is the actor trace row (step) representation. "
         "Used to draw trace of the processes".
id() -> #hist{task=#sequenceFlow{source="Init"}}.
new(Name,Hist,_) ->
    Task = case Hist#hist.task of [] -> (id())#hist.task; X -> X end,
    Docs = Hist#hist.docs,
    #panel { id=form:atom([tr,nitro:to_list(Name)]), class=td, body=[
        #panel{class=column6,   body = name(Task) },
        #panel{class=column20,  body = string:join(lists:map(fun(X)-> nitro:to_list([element(1,X)]) end,Docs),", ")}
       ]}.

name(#sequenceFlow{source=Task}) -> nitro:to_list(Task);
name(_) -> [].
