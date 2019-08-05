-module(fin).
-compile(export_all).
-behaviour(application).
-behaviour(supervisor).
-export([start/2, stop/1, init/1]).
stop(_)    -> ok.
init([])   -> {ok, { {one_for_one, 5, 10}, []} }.
start(_,_) -> kvs:join(),
              cowboy:start_tls(http, n2o_cowboy:env(fin), #{env => #{dispatch => n2o_cowboy2:points()} }),
              supervisor:start_link({local, ?MODULE}, ?MODULE, []).
