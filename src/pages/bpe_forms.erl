-module(bpe_forms).
-copyright('Maxim Sokhatsky').
-export([event/1]).
-include_lib("n2o/include/n2o.hrl").
-include_lib("nitro/include/nitro.hrl").

event({client,{form,Module}}) ->
    nitro:insert_bottom(stand, #h3{body=nitro:to_binary(Module)}),
    nitro:insert_bottom(stand, #h5{body=Module:doc(),style="margin-bottom: 10px;"}),
    nitro:insert_bottom(stand, (form:new(Module:new(Module,Module:id(),[]), Module:id()))#panel{class=form});

event(init) ->
    nitro:clear(stand),
    [ self() ! {client,{form,F}} || F <- application:get_env(form, registry, []) ],
    ok;

event({Event,Name}) ->
    nitro:wire(lists:concat(["console.log(\"",io_lib:format("~p",[{Event,Name}]),"\");"]));

event(_Event) -> ok.

