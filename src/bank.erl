-module(bank).
-compile(export_all).
-behaviour(application).
-behaviour(supervisor).
-include("ent.hrl").
-include_lib("kvs/include/metainfo.hrl").
-export([start/2, stop/1, init/1]).

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_,_) ->
    cowboy:start_tls(http, [{port, port()},
        {certfile, code:priv_dir(bank)++"/ssl/fullchain.pem"},
        {keyfile, code:priv_dir(bank)++"/ssl/privkey.pem"},
        {cacertfile, code:priv_dir(bank)++"/ssl/fullchain.pem"}],
        #{env => #{dispatch => points()} }),
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

port() -> application:get_env(n2o,port,8041).
points() ->
    cowboy_router:compile([{'_', [
    {"/ws/[...]", n2o_cowboy2, []},
    {"/app/[...]", cowboy_static, {dir, code:priv_dir(bank)++"/static", []}} ]}]).

metainfo() -> #schema { name = kvs, tables = tables() }.
tables() -> [ #table{name=folder, container=true, fields=record_info(fields,folder)},
              #table{name=scope,  container=true, fields=record_info(fields,scope)},
              #table{name=i,                      fields=record_info(fields,i)},
              #table{name=acl,                    fields=record_info(fields,acl)},
              #table{name=node,                   fields=record_info(fields,node)}
            ].

send_message(Message) -> (element(2,Message)):exec(Message).

fsn(Path) -> bank_fs:fsn(Path).
cd(Path)  -> bank_fs:cd(bank_fs:fsn(Path)).
pwd()     -> bank_fs:pwd().
ls()      -> bank_fs:ls().
