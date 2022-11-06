-module(bpe_create).
-copyright('Maxim Sokhatsky').
-include_lib("nitro/include/nitro.hrl").
-include_lib("form/include/meta.hrl").
-include_lib("bpe/include/bpe.hrl").
-include("act.hrl").
-export([doc/0,id/0,new/3]).

doc() -> "Dialog for creation of BPE processes.".
id() -> #act{}.
new(Name,#act{}, _) ->
  put(process_type_pi_none, "bpe_account"),
  #document { name = form:atom([pi,Name]),
    sections = [ #sec { name=[<<"New process: "/utf8>>] } ],
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
                        default = bpe_account,
                        options = [ #opt{name=bpe_account,checked=true,title = "Client Account"} ]
                       } ] }.
