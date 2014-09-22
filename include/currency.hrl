-ifndef(TRANSACTION_HRL).
-define(TRANSACTION_HRL, "currency_hrl").

-include_lib("kvs/include/kvs.hrl").

-record(currency, {?ITERATOR(feed),
        code,
        rate,
        date,
        source, % National Bank, Bloomberg, etc.
        description,
        info}).

-endif.

