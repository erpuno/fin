-ifndef(NODE_HRL).
-define(NODE_HRL, true).

-include_lib("kvs/include/kvs.hrl").

-record(node, { ?ITERATOR(conv),
                type=[],
                condition=[],
                name=[],
                description=[],
                scope_id=[],
                extra=[] }).

-endif.
