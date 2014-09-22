
-ifndef(ACCOUNT_HRL).
-define(ACCOUNT_HRL, "account_hrl").

-include_lib("kvs/include/kvs.hrl").

-record(account, {?ITERATOR(feed), ?CREATION,
        program,
        client,
        state
        }).

-endif.
