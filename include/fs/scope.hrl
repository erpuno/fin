-ifndef(SCOPE_HRL).
-define(SCOPE_HRL, true).

-include_lib("kvs/include/kvs.hrl").

-record(scope, { ?CONTAINER,
                 title       = [],
                 description = [],
                 owner_id    = [],
                 folder_id   = [],
                 status      = [],
                 params      = [],
                 nodes       = [],
                 type   = [],
                 company_id  = [] }).

-endif.
