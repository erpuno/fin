-ifndef(API_HRL).
-define(API_HRL, true).

-define(API(Mod), module=Mod, type=[], obj=[], ver=1, id=[]).

-record(create_user,    {?API(create), folder_id=[], title=[], logins=[]}).
-record(create_folder,  {?API(create), company_id=[], obj_type=[], folder_id=[], title=[], description=[]}).
-record(create_company, {?API(create), phone=[], site=[], description=[], name=[]}).
-record(create_node,    {?API(create), scope_id=[], obj_type=[], obj_id=[], title=[],
                                       description=[], version=[] }).

-record(charge, {}).
-record(withdraw, {}).
-record(open, {}).
-record(close,{}).
-record(transfer, {}).

-endif.
