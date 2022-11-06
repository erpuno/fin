-module(bpe_row).
-copyright('Maxim Sokhatsky').
-export([doc/0,id/0,new/3]).
-include_lib("bpe/include/bpe.hrl").
-include_lib("nitro/include/nitro.hrl").

doc() -> "This is the actor table row representation in FORM CSS. Used to draw active processes"
         " in <a href=\"actors.htm\">BPE process table</a> but displayed as class=form.".
id() -> #process{}.
current(Proc) -> {_,T} = bpe:current_task(Proc), T.
new(Name,Proc,_) -> 
    Pid = nitro:to_list(Proc#process.id),
    Docs = Proc#process.docs,
    #panel { id=form:atom([tr,Name]), class=td, body=[
        #panel{class=column6,   body = #link{href="act.htm?p="++Pid, body=Pid } },
        #panel{class=column6,   body = nitro:to_list(Proc#process.name) },
        #panel{class=column6,   body = nitro:to_list(current(Proc))},
        #panel{class=column20,  body = nitro:to_list(current(Proc))},
        #panel{class=column20,  body = string:join(lists:map(fun(X)-> nitro:to_list([element(1,X)]) end,Docs),", ") },
        #panel{class=column10,  body = case current(Proc) of "Final" -> [];
                                       _ -> [ #link{postback={complete,Proc#process.id}, class=[button,sgreen],
                                         body= "Go", source=[], validate=[]} ] end }
       ]}.
