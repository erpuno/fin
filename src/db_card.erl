-module(db_card).
-include_lib("kvs/include/metainfo.hrl").
-include_lib("db/include/transaction.hrl").
-compile(export_all).

metainfo() ->
    #schema{name = db, tables = 
                [
                 #table{name = card, fields=record_info(fields, card)}
                ]
           }.
