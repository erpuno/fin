-module(bank_kvx).
-compile(export_all).
-include("ent.hrl").
-include_lib("kvx/include/metainfo.hrl").

metainfo() -> #schema { name = kvx,
                        tables = lists:flatten([ bank()]) }.

bank() ->
       [
        #table{name = 'account',     fields=record_info(fields, account)},
        #table{name = 'client',      fields=record_info(fields, client)},
        #table{name = 'card',        fields=record_info(fields, card)},
        #table{name = 'transaction', fields=record_info(fields, transaction)}
    ].

