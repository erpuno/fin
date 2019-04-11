-module(bank_fs).
-include_lib("kvs/include/user.hrl").
-include("ent.hrl").
-compile(export_all).

boot() -> kvs:join(),
          case kvs:get(folder,"/") of
               {ok,_} -> skip;
               {error,_} -> kvs:next_id("scope",10),
                            kvs:next_id("node",10),
                            bank_fs:init_filesystem(),
                            ent:send_message(#create_company{ver=3,name="softconstruct"}),
                            ok end.


% /
% +-- /users
% |   +-- /admins
% |   +-- /customers
% +-- /companies
%     +-- /softconstruct
%     +-- /synrc

init_filesystem() ->
   kvs:put(#folder{id="/",description="/ns/softconstruct/"}),
   [ ent:send_message(#create_folder{ver=3,folder_id=X}) || X <- ["users","home"] ],
   ok.

fsn(Path) -> case string:join(string:tokens(Path,"/"),"/") of [] -> "/"; E -> E end.
cd(Path)  -> application:set_env(ent,cwd, fsn(Path)).
pwd()     -> application:get_env(ent,cwd, "/").
ls()      -> [ {Type,Ref} || #i{type=Type,ref=Ref} <- kvs:entries(kvs:get(folder, pwd()),i,25) ].

line() -> case ent:ls() of [] -> [];
                            [{X,Y}] -> [{X,Y,0}];
                            L  -> RL = L,
                                  {LT,LN} = lists:last(RL),
                                  [ {Type,Name,1} || {Type,Name} <- lists:droplast(RL) ] ++ [{LT,LN,0}] end.
draw(Prefix,{_T,N,_L}) -> io:format(io_lib:format("~s+-- ~s ~n",[Prefix,"/"++wf:to_list(N)])).
draw2(Prefix,{_T,N,_L},Count) -> io:format(io_lib:format("~s+-- ~s (~s)~n",[Prefix,"/"++wf:to_list(N),wf:to_list(Count)])).
dump() -> io:format("==[fs]==~n"), end_fs:dump("","/",0).
dump(Prefix,Cd,X) -> ent:cd(fsn(Cd)),
                   [ begin PX = lists:concat([Prefix,case X of 0 -> "    "; _ -> "|   " end]),
                           _PL = lists:concat([Prefix,case L of 0 -> "    "; _ -> "|   " end]),
                           Deep = fsn(filename:join(Cd,wf:to_list(N))),
                           case retrieve(T,N,Deep) of
                                {ok,#folder{count=Count}} when Count > 100 -> draw2(PX,{T,N,L},Count);
                                {ok,#user{username=Name}} -> draw2(PX,{T,N,L},Name);
                                _ -> draw(PX,{T,N,L}),
                                     dump(PX,Deep,L)
                                      end,
                           ok
                            end || {T,N,L} <- line() ], ok.

retrieve(user,Id,_Deep) -> kvs:get(user,Id);
retrieve(folder,_Id,Deep) -> kvs:get(folder,Deep).

unfold_folders(Comp) -> lists:foldl(fun (X,A) -> J = lists:concat([A,X,"/"]),
                                              ent:send_message(#create_folder{folder_id=J}),
                                              J end,[],lists:droplast(Comp)).

unfold_dirs(Comp) -> lists:foldl(fun (X,A) -> J = lists:concat([A,X,"/"]),
                                              file:make_dir([J]),
                                              J end,[],lists:droplast(Comp)).
