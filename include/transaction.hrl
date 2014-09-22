
-ifndef(TRANSACTION_HRL).
-define(TRANSACTION_HRL, "transaction_hrl").

-include_lib("kvs/include/kvs.hrl").

-record(transaction, {?ITERATOR(feed),
        timestamp,
        beneficiary,
        subsidiary,
        amount,
        currency,
        description,
        info}).

-endif.
