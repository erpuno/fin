-ifndef(PHONE_HRL).
-define(PHONE_HRL, "phone").

-record(phone, {id,
    number = "380676631870",
    auth = []              %% проплист формата [{number,"3804546546"},{password,"SomePassword"}]
}).

-endif.
