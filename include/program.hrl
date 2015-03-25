-ifndef(PROGRAM_HRL).
-define(PROGRAM_HRL, "program_hrl").
-include_lib("kvs/include/kvs.hrl").

-record(program, {?ITERATOR(feed),
        name,
        script,
        filename,
        code,
        description
        }).

-endif.
