-ifndef(ACCOUNT_HRL).
-define(ACCOUNT_HRL, "account_hrl").
-include_lib("kvs/include/kvs.hrl").

-record(account, {?ITERATOR(feed),
        origin,
        type,
        iban,
        program = undefined,
        customer,
        name,
        amount=0,
        transactions,
        state = open,
        startDate={2015,1,1},
        terminationDate={2015,1,1}
       }).

-endif.
