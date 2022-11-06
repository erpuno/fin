-module(bpe_act).
-copyright('Maxim Sokhatsky').
-include_lib("nitro/include/nitro.hrl").
-include_lib("form/include/meta.hrl").
-include_lib("bpe/include/bpe.hrl").
-include("act.hrl").
-export([event/1]).

event(init) ->
   nitro:clear(tableHead),
   nitro:clear(tableRow),
   Bin = nitro:qc(p),
   Id = try binary_to_list(Bin) catch _:_ -> 0 end,
   case kvs:get("/bpe/proc",Id) of
        {error,not_found} ->
           nitro:update(n, "ERR"),
           nitro:update(desc, "No process found."),
           nitro:update(num, "ERR");
        _ ->
           nitro:insert_top(tableHead, header()),
           nitro:update(n, Bin),
           nitro:update(num, Bin),
   History = bpe:hist(Id),
 [ begin 
     {step,No,Step} = I#hist.id,
     Name = nitro:to_list(No)++"-"++nitro:to_list(Step),
     Trace = bpe_trace:new(form:atom([trace,Name]),I,[]),
     nitro:insert_bottom(tableRow, Trace)
   end 
   || I <- History ]
   end;

event(_) ->
   ok.

header() ->
  #panel{id=header,class=th,body=
    [#panel{class=column6,body="State"},
     #panel{class=column6,body="Documents"}]}.

