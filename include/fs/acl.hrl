-ifndef(ACL_HRL).
-define(ACL_HRL, true).

-record(privs,  { create = 0, view = 0, modify = 0, delete = 0 }).
-record(access, { owner  = <<>>,  priv = #privs{} }).
-record(acl,    { node   = <<>>,  list = [] }).

-endif.
