-module(fin_charge).
-include_lib("bpe/include/bpe.hrl").
-export([def/0,action/2]).

def() -> #process{}.
action(_,_) -> #result{}.

