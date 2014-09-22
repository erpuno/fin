
-ifndef(CLIENT_HRL).
-define(CLIENT_HRL, "client_hrl").

-include_lib("kvs/include/kvs.hrl").

-record(client, {?ITERATOR(feed), ?CREATION,
        bank,
        phone,
        tax,
        names,
        surnames,
        display_name,
        registration,
        version,
        system
        }).

personilized(#client{phone=Phone,tax=Tax}) -> ok.

-endif.
