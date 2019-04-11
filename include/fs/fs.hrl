-ifndef(FS_HRL).
-define(FS_HRL, true).

-include_lib("kvs/include/kvs.hrl").

-record(folder, { ?CONTAINER,        description=[], link=[] }).
-record(i,      { ?ITERATOR(folder), type=[], ref=[] }).

-endif.
