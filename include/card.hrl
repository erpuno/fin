
-ifndef(CARD_HRL).
-define(CARD_HRL, "card_hrl").

-include_lib("kvs/include/kvs.hrl").

-record(card, {?ITERATOR(feed),
        
        client
        }).

-endif.
