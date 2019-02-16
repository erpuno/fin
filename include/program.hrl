-ifndef(PROGRAM_HRL).
-define(PROGRAM_HRL, "program_hrl").

-record(program, {id,next,prev,
        name,
        script,
        filename,
        code,
        description
        }).

-endif.
