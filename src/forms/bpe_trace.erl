-module(bpe_trace).
-copyright('Maxim Sokhatsky').
-compile(export_all).
-include_lib("bpe/include/bpe.hrl").
-include_lib("nitro/include/nitro.hrl").

doc() -> "This is the actor trace row (step) representation. "
         "Used to draw trace of the processes".
id() -> #hist{task={task,'Init'}}.
new(Name,Hist) ->
    Task = case element(#hist.task,Hist) of [] -> (id())#hist.task; X -> X end,
    Docs = element(#hist.docs,Hist),
    io:format("Docs: ~p",[Docs]),
    #panel { id=form:atom([tr,nitro:to_list(Name)]),
             class=td,
             body=[
        #panel{class=column6,   body = Task },
        #panel{class=column20,  body = string:join(lists:map(fun(X)-> nitro:to_list([element(1,X)]) end,Docs),", ")}
       ]}.
