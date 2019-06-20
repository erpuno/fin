-module(bank).
-compile(export_all).
-behaviour(application).
-behaviour(supervisor).
-export([start/2, stop/1, init/1]).
stop(_)    -> ok.
init([])   -> {ok, { {one_for_one, 5, 10}, []} }.
start(_,_) -> kvs:join(), kvx:join(),
              cowboy:start_tls(http, n2o_cowboy:env(?MODULE),
              #{env => #{dispatch => n2o_cowboy2:points()} }),
              supervisor:start_link({local, ?MODULE}, ?MODULE, []).
send_message(Message) -> (element(2,Message)):exec(Message).
fsn(Path)  -> bank_fs:fsn(Path).
cd(Path)   -> bank_fs:cd(bank_fs:fsn(Path)).
pwd()      -> bank_fs:pwd().
ls()       -> bank_fs:ls().
