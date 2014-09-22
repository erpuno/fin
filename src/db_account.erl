-module(db_account).
-include_lib("kvs/include/metainfo.hrl").
-include_lib("db/include/account.hrl").
-compile(export_all).

metainfo() ->
    #schema{name = db, tables = 
                [
                 #table{name = account, fields=record_info(fields, account)}
                ]
           }.
