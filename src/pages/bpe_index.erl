-module(bpe_index).
-copyright('Maxim Sokhatsky').
-compile(export_all).
-include_lib("n2o/include/n2o.hrl").
-include_lib("bpe/include/bpe.hrl").
-include_lib("nitro/include/nitro.hrl").

header() ->
  #panel{id=header,class=th,body=
    [#panel{class=column6,body="No"},
     #panel{class=column10,body="Name"},
     #panel{class=column6,body="Module"},
     #panel{class=column20,body="State"},
     #panel{class=column20,body="Documents"},
     #panel{class=column20,body="Manage"}
     ]}.

event(init) ->
    nitro:clear(tableHead),
    nitro:clear(tableRow),
    nitro:insert_top(tableHead, header()),
    nitro:clear(frms),
    nitro:clear(ctrl),
    Module = bpe_act,
    nitro:insert_bottom(frms, form:new(Module:new(Module,Module:id(), []), Module:id(), [])),
    nitro:insert_bottom(ctrl, #link{id=creator, body="New",postback=create, class=[button,sgreen]}),
    nitro:hide(frms),
  [ nitro:insert_top(tableRow, bpe_row:new(form:atom([row,I#process.id]),I,[]))
 || I <- kvs:all("/bpe/proc") ],
    ok;

event({complete,Id}) ->
    bpe:start(bpe:load(Id),[]),
    io:format("Next: ~p~n",[bpe:next(Id)]),
    nitro:update(form:atom([tr,row,Id]),
                bpe_row:new(form:atom([row,Id]),bpe:load(Id),[]));

event(create) ->
    nitro:hide(ctrl),
    nitro:show(frms);

event({'Spawn',_}) ->
    Atom = nitro:to_atom(nitro:q(process_type_pi_none)),
    Id = case bpe:start(Atom:def(), []) of
              {error,I} -> I;
              {ok,I} -> I end,
    nitro:insert_after(header, bpe_row:new(form:atom([row,Id]),bpe:proc(Id),[])),
    nitro:hide(frms),
    nitro:show(ctrl),
    ?LOG_INFO("BPE: ~p.~n", [Id]);

event({'TypeSelect'}) ->
%    [ io:format("Process Dictionary: ~p : ~p~n",[X,erlang:get(X)]) || X <- erlang:get_keys()],
    io:format("~p",["Type Select"]);

event({'Discard',[]}) ->
    nitro:hide(frms),
    nitro:show(ctrl);

event({Event,Name}) ->
    nitro:wire(lists:concat(["console.log(\"",io_lib:format("~p",[{Event,Name}]),"\");"])),
    ?LOG_INFO("Event:~p.~n", [{Event,Name}]);

event(Event) ->
    ?LOG_INFO("Unknown:~p.~n", [Event]).
