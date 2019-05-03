-ifndef(FS_HRL).
-define(FS_HRL, true).

-include_lib("kvs/include/kvs.hrl").

-record(folder, {  id=[] :: term(),
                   top=[] :: [] | integer(),
                   rear=[] :: [] | integer(),
                   count=0 :: integer(),
                   description=[], link=[] }).
-record(i,      { ?ITERATOR(folder), type=[], ref=[] }).

-endif.
