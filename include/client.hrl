-ifndef(CLIENT_HRL).
-define(CLIENT_HRL, "client_hrl").
-include_lib("kvs/include/kvs.hrl").

-record(client, {?ITERATOR(feed),
        bank,
        iban,
        local,
        type,
        status,
        program,
        amount,
        default_account,
        accounts,
        default_card,
        cards,
        phone,
        tax,
        names,
        surnames,
        display_name,
        registration }).

-endif.
