
-ifndef(ACCOUNT_HRL).
-define(ACCOUNT_HRL, "account_hrl").

-include_lib("db/include/creation.hrl").
-include_lib("kvs/include/kvs.hrl").

-record(account, {?ITERATOR(feed),
        program,
        client,
        state}).

-endif.
