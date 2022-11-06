-module(fin_open).
-include_lib("bpe/include/bpe.hrl").
-export([def/0,action/2]).

def() -> #process{}.
action(_,_) -> #result{}.

