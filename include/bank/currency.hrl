-ifndef(TRANSACTION_HRL).
-define(TRANSACTION_HRL, "currency_hrl").

-record(currency, {id,next,prev,
        code,
        rate,
        date,
        source, % National Bank, Bloomberg, etc.
        description,
        info}).

-endif.

