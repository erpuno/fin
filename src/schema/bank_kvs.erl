-module(bank_kvs).
-compile(export_all).
-include_lib("kvs/include/metainfo.hrl").
-include("fs/acl.hrl").
-include("fs/scope.hrl").
-include("fs/node.hrl").
-include("fs/fs.hrl").

metainfo() -> #schema { name = kvs,
                        tables = lists:flatten([ fs()]) }.

fs() -> [ #table { name='folder', container=true, fields=record_info(fields,folder)},
          #table { name='scope',  container=true, fields=record_info(fields,scope)},
          #table { name='i',                      fields=record_info(fields,i)},
          #table { name='acl',                    fields=record_info(fields,acl)},
          #table { name='node',                   fields=record_info(fields,node)}
       ].
