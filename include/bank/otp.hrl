-ifndef(OTP_HRL).
-define(OTP_HRL, "otp").

-record(otp, {
    id,
    code=[],
    user_ip,
    operation=login,
    params=[],
    lang = ua,
    attempt=0
}).

-endif.
