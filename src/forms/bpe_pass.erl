-module(bpe_pass).
-copyright('Maxim Sokhatsky').
-include_lib("form/include/meta.hrl").
-include("bank/phone.hrl").
-export([doc/0,id/0,new/3]).

doc() -> "One-time password PIN control used in banks,".
id() -> #phone{}.
new(Name,_Phone,_) ->
    #document { name = form:atom([otp,Name]),
    sections = [ #sec { name=[<<"Input the credentials: "/utf8>> ] } ],
    buttons  = [ #but { id=decline,
                        name=decline,
                        title= <<"Cancel"/utf8>>,
                        class=[cancel],
                        postback={'Close',[]} },
                 #but { id=proceed,
                        name=proceed,
                        title = <<"Proceed"/utf8>>,
                        class = [button,sgreen],
                        sources = [user,otp],
                        postback = {'Next',form:atom([otp,otp,Name])}}],
    fields = [ #field { id=number,
                        name=number,
                        type=string,
                        title= <<"Login:"/utf8>>,
                        labelClass=label},
               #field { id=auth,
                        name=auth,
                        type=string,
                        title= <<"Pass:"/utf8>>,
                        labelClass=label}]}.
