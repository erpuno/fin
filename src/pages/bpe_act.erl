-module(bpe_act).
-copyright('Maxim Sokhatsky').
-include_lib("nitro/include/nitro.hrl").
-include_lib("form/include/meta.hrl").
-include_lib("bpe/include/bpe.hrl").
-compile(export_all).
-record(pi, {code='Spawnproc'}).

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
 [ begin nitro:insert_bottom(tableRow,
io:format("I: ~p",[I]),
   bpe_trace:new(form:atom([trace,nitro:to_list(I#hist.id)]),I))
   end 
   || I <- History ]
   end;

event(E) ->
   io:format("Event:process:~p~n.",[E]),
   ok.

header() ->
  #panel{id=header,class=th,body=
    [#panel{class=column6,body="State"},
     #panel{class=column6,body="Documents"}]}.

doc() -> "Dialog for creation of BPE processes.".
id() -> #pi{}.
new(Name,{pi,_Code}, _) ->
  #document { name = form:atom([pi,Name]), sections = [
      #sec { name=[<<"New process: "/utf8>>] } ],
    buttons  = [ #but { id=form:atom([pi,decline]),
                        title= <<"Discard"/utf8>>,
                        class=cancel,
                        postback={'Discard',[]} },
                 #but { id=form:atom([pi,proceed]),
                        title = <<"Create"/utf8>>,
                        class = [button,sgreen],
                        sources = [process_type],
                        postback = {'Spawn',[]}}],
    fields = [ #field { name=process_type,
                        id=process_type,
                        type=select,
                        title= "Type",
                        tooltips = [],
                        options = [ #opt{name=fin_account,checked=true,title = "Client Account [FIN.ERP.UNO]"},
                                    #opt{name=bpe_account,title = "Unknown"} ],
                        postback = {'TypeSelect'}
                       } ] }.
