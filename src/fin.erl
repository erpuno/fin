-module(fin).
-compile(export_all).
-behaviour(application).
-behaviour(supervisor).
-export([start/2, stop/1, init/1]).
stop(_)    -> ok.
init([])   -> {ok, { {one_for_one, 5, 10}, []} }.
start(_,_) -> kvs:join(),
              cowboy:start_clear(http,
                       [{port, application:get_env(n2o, port, 8041)}],
                       #{env => #{dispatch => n2o_cowboy:points()}}),
              supervisor:start_link({local, ?MODULE}, ?MODULE, []).

