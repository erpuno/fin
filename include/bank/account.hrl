-ifndef(ACCOUNT_HRL).
-define(ACCOUNT_HRL, "account_hrl").

-record(account, {id,next,prev,
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
