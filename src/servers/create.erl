-module(create).
-include_lib("kvs/include/user.hrl").
-include("fs/acl.hrl").
-include("api.hrl").
-include("fs/scope.hrl").
-include("fs/node.hrl").
-include("fs/fs.hrl").
-compile(export_all).

exec(#create_company{ver=Ver,name=Name,description=Desc}) ->
    Home  = filename:join(["home",Name]),
    Users = filename:join(["home",Name,"users"]),
    Scope = filename:join(["home",Name,"scopes"]),
    case kvs:get(folder,ent:fsn(Home)) of
         {ok,_} -> {error,exist};
         {error,not_found} -> [ exec(#create_folder{ver=Ver,folder_id=ent:fsn(X)}) || X <- [Home,Users,Scope] ],
                              {ok,Home} end;

exec(#create_user{ver=Ver,logins=Logins}) ->
    {ok,[ case kvs:get(user,X) of
               {ok,_} -> {error,[exists,X]};
               {error,not_found} -> User = kvs:next_id("user",1),
                                    kvs:put(#user{id=User,username=X}),
                                    kvs:add(#i{id=kvs:next_id("scope",1),feed_id="users",type=user,ref=User})
         end || X <- Logins]};

exec(#create_folder{ver=Ver,folder_id=Path,description=Description}) ->
    Comp = string:tokens(Path,"/"),
    Folder = lists:droplast(Comp),
    Parent = case string:join(Folder,"/") of [] -> "/"; E -> E end,
    case kvs:get(folder,ent:fsn(Path)) of
         {ok,_} -> {error,exist};
         {error,not_found} -> kvs:put(#folder{id=ent:fsn(Path),description=Description}),
                              kvs:add(#i{id=kvs:next_id("scope",1),type=folder,ref=lists:last(Comp),feed_id=Parent}) end;


exec(#create_node{ver=Vsn,title=Title,description=Desc,scope_id=ScopeId}) ->
    NodeId = kvs:next_id("node",1),
    Node = #node{id = NodeId, name=Title,description=Desc,feed_id=ScopeId},
    Res = kvs:add(Node),
    io:format("Create Node: ~p~n~p",[Res,Node]),
    {ok,NodeId};

exec(A) ->
    io:format("A: ~p~n",[A]),
    {error,unknown}.
