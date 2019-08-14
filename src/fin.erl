-module(fin).
-compile(export_all).
-behaviour(application).
-behaviour(supervisor).
-export([start/2, stop/1, init/1]).
stop(_)    -> ok.
init([])   -> {ok, { {one_for_one, 5, 10}, []} }.
start(_,_) -> kvs:join(),
              X = cowboy:start_tls(http, env(fin), #{env => #{dispatch => n2o_cowboy2:points()} }),
              io:format("Cowboy: ~p~n",[X]),
              supervisor:start_link({local, ?MODULE}, ?MODULE, []).

env(App) -> [{port,       application:get_env(n2o,port,8041)},
             {certfile,   code:priv_dir(App)++"/ssl/certfile.pem"},
             {keyfile,    code:priv_dir(App)++"/ssl/keyfile.pem"},
             {cacertfile, code:priv_dir(App)++"/ssl/cacertfile.pem"}].

