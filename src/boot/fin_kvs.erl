-module(fin_kvs).
-export([metainfo/0,fin/0]).
-include("bank/phone.hrl").
-include("ent.hrl").
-include_lib("kvs/include/metainfo.hrl").
-include_lib("form/include/meta.hrl").

metainfo() -> #schema { name = fin, tables = fin() }.

fin() ->
       [
        #table{name = phone,         fields=record_info(fields, phone), instance = #phone{} },
        #table{name = field,         fields=record_info(fields, field), instance = #field{} },
        #table{name = 'account',     fields=record_info(fields, account), instance = #account{} },
        #table{name = 'client',      fields=record_info(fields, client), instance = #client{}},
        #table{name = 'card',        fields=record_info(fields, card), instance = #card{}},
        #table{name = 'transaction', fields=record_info(fields, transaction), instance = #transaction{}}
    ].

