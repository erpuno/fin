-module(db_config).
-description('DB Bank Accounting').
-copyright('Synrc Research Center s.r.o.').
-include_lib("kvs/include/metainfo.hrl").
-include_lib("kvs/include/config.hrl").
-include("client.hrl").
-include("account.hrl").
-include("card.hrl").
-include("transaction.hrl").
-include("program.hrl").
-compile(export_all).

metainfo() ->
    #schema{name=db, tables=[
        #table{name = account,     fields=record_info(fields, account)},
        #table{name = client,      fields=record_info(fields, client)},
        #table{name = card,        fields=record_info(fields, card)},
        #table{name = program,     fields=record_info(fields, program)},
        #table{name = transaction, fields=record_info(fields, transaction)},
        #table{name = config,      fields=record_info(fields, config)}
    ]}.
