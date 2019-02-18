-module(bank).
-include_lib("kvx/include/metainfo.hrl").
-include("client.hrl").
-include("account.hrl").
-include("card.hrl").
-include("transaction.hrl").
-include("program.hrl").
-compile(export_all).
-export([start/2, stop/1, init/1, metainfo/0]).

start(_StartType, _StartArgs) -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).
stop(_State) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.

metainfo() ->
    #schema{name=bank, tables=[
        #table{name = account,     fields=record_info(fields, account)},
        #table{name = client,      fields=record_info(fields, client)},
        #table{name = card,        fields=record_info(fields, card)},
        #table{name = program,     fields=record_info(fields, program)},
        #table{name = transaction, fields=record_info(fields, transaction)}
    ]}.
