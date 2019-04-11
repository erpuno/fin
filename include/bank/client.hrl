-ifndef(CLIENT_HRL).
-define(CLIENT_HRL, "client_hrl").

-record(client, {id,next,prev,
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
