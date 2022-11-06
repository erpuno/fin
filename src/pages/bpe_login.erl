-module(bpe_login).
-copyright('Maxim Sokhatsky').
-export([event/1]).
-include_lib("n2o/include/n2o.hrl").
-include_lib("nitro/include/nitro.hrl").

event(init) ->
    nitro:clear(stand),
    Module = bpe_pass,
    Form = Module:new(Module,Module:id(),[]),
    HTML = form:new(Form, Module:id(), []),
    nitro:insert_bottom(stand, HTML);

event({'Next',_}) ->
    nitro:redirect("actors.htm");

event({'Close',_}) ->
    nitro:redirect("index.html");

event(Event) ->
    ?LOG_INFO("Unknown:~p.~n", [Event]).
