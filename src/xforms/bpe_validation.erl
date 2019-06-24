-module(bpe_validation).
-author('Maxim Sokhatsky <maxim@synrc.com>').
-compile(export_all).
-include_lib("bank/include/bank/otp.hrl").
-include_lib("bank/include/bank/phone.hrl").
-include_lib("bank/include/bank/sid.hrl").
-include_lib("bank/include/bank/transaction.hrl").
-include_lib("bank/include/bank/currency.hrl").
-include_lib("bank/include/bank/client.hrl").
-include_lib("bank/include/bank/account.hrl").
-include_lib("bank/include/bank/card.hrl").
-include_lib("form/include/meta.hrl").
-include_lib("bpe/include/bpe.hrl").

doc(phone)               -> #phone{};
doc(client_cards)        -> #client{};
doc(account)             -> #account{}.

translate(Code) -> translate(Code,wf:lang()).
translate(Code,ua) -> actUA:translate(Code);
translate(Code,ru) -> actRU:translate(Code);
translate(Code,__) -> actEN:translate(Code).

getBank() -> application:get_env(n2o,bank,"PB").

dateToInt({Y,M,D}) -> dateToInt(Y,M,D).
dateToInt(Y, M, D) ->
    Mon = if  M < 10 -> [$0 | wf:to_list(M)];
              true -> wf:to_list(M)
          end,
    Day = if  D < 10 -> [$0 | wf:to_list(D)];
              true -> wf:to_list(D)
          end,
    list_to_integer(wf:to_list(Y)++Mon++Day).

timeToInt({H,M,S}) -> timeToInt(H, M, S).
timeToInt(H, M, S) ->
    Hour = if  H < 10 -> [$0 | wf:to_list(H)];
               true -> wf:to_list(H)
           end,
    Min = if  M < 10 -> [$0 | wf:to_list(M)];
              true -> wf:to_list(M)
          end,
    Sec = if  S < 10 -> [$0 | wf:to_list(S)];
              true -> wf:to_list(S)
          end,
    Hour++Min++Sec.

valid(#phone{}=Phone, #process{options= Options}) ->
    Lang = proplists:get_value(lang, Options),
    Bank = proplists:get_value(bank, Options),
    validate_values([{{phone, Lang},Phone}, {{p24auth,Bank,Lang},Phone}]);

valid({otp,OTP=#otp{}}, #process{options= Options}) -> validate(validation({otp, proplists:get_value(lang, Options)}),OTP);

valid({send,Phone=#phone{},OTP=#otp{}},Proc) ->service(otp,send_otp,[Phone,OTP,Proc#process.id],Proc);

valid({check, Phone=#phone{}, OTP=#otp{}},Proc) -> service(otp,check_otp,[Phone,OTP,Proc#process.id],Proc);

valid(_,_) -> false.

% FORMS Field Input Corectness Validations for Erlang and JavaScript validations/0
validations() ->  [
    validation(name),
    validation(phone),
    validation(date),
    validation(otp),
    validation({money,2}),
    validation(money)
].

validation({bonus, EkbId, Lang}) ->
    #validation {
        name = bonusCode,
        msg = translate({?MODULE, bonusMsg}, Lang),
        options = [{bonusCode,EkbId,translate({?MODULE, bonusError}, Lang)}] };


validation({name, Lang}) -> #validation {
    name = name,
    msg = translate({?MODULE, nameMsg}, Lang),
    options = [ {charQuantity, {0, 120}, translate({?MODULE, nameLength}, Lang)} ] };

validation({money, Lang}) -> #validation {
    name = money,
    msg = translate({?MODULE, moneyMsg}, Lang),
    options = [{minMax,{2,999999999999},"money_minmax"},
               {regexp,"^[0-9]{1,}(\.[0-9]{1,2}){0,1}$","money_format"},
               {charQuantity, {1,18}, "field_limit"}] };

validation({money,Min, Max, Lang}) ->
    MaxBin = list_to_binary(io_lib:format("~w",[money(Max)])),
    MinBin = list_to_binary(io_lib:format("~w",[money(Min)])),
    #validation {
        name = money,
        msg = [translate({?MODULE, sumMsg}, Lang), MaxBin, "."],
        options = [{regexp,"^[0-9]{1,}(\.[0-9]{1,2}){0,1}$", translate({?MODULE, sumRegExp}, Lang)},
                   {minMax,{Min,Max},[translate({?MODULE, sumMinMax1}, Lang), MinBin, translate({?MODULE, sumMinMax2}, Lang), MaxBin, "."]},
                   {charQuantity, {1,18},translate({?MODULE, sumLength}, Lang)}] };

validation({moneyRegular, Min, Max, MaxRegular, Lang}) ->
    MaxBin = list_to_binary(io_lib:format("~w",[money(Max)])),
    MinBin = list_to_binary(io_lib:format("~w",[money(Min)])),
    #validation {
        name = moneyRegular,
        options = [{regexp,"^[0-9]{1,}(\.[0-9]{1,2}){0,1}$", translate({?MODULE, sumRegExp}, Lang)},
                   {minMax,{Min,Max},[translate({?MODULE, sumMinMax1}, Lang), MinBin, translate({?MODULE, sumMinMax2}, Lang), MaxBin, "."]},
                   {minMax,{Min,MaxRegular}, translate({?MODULE, sumMaxRegular}, Lang)},
                   {charQuantity, {1,18},translate({?MODULE, sumLength}, Lang)}]
    };

validation({moneyDivisibleBy, Divisor, Lang}) ->
    #validation {
        name = money,
        options = [{divisibleBy,Divisor, translate({?MODULE,sumDivisibleBy}, Lang)}]
    };

validation({phone, Lang}) -> #validation {
    name = phone,
    extract = fun(X) -> X#phone.number end,
    msg = translate({?MODULE, phoneMsg}, Lang),
    options = [{regexp,"^[+][0-9]{1,}$", translate({?MODULE, phoneRegExp}, Lang)} ] };

validation({auth, Bank, Lang}) -> #validation {
    name = auth,
    extract = fun(X) -> X#phone.auth end,
    msg = translate({?MODULE, auth, Bank}, Lang),
    options = [{auth,"", [{<<"0003">>,translate({?MODULE, auth, <<"0003">>}, Lang)}]} ] };

validation({date, MinDate, MaxDate, _Lang}) ->
  Min =  integer_to_binary(MinDate),
  Max =  integer_to_binary(MaxDate),
  #validation {
    name = date, msg = <<"Введено неверное значение!"/utf8>>,
    options = [ {regexp,"^{([0-9]{4}),([0-9]{1,2}),([0-9]{1,2})}$",<<"Введена некорректная дата!"/utf8>>},
                {checkDate, "", <<"Введена некорректная дата!"/utf8>>},
                {minMax,{MinDate,MaxDate},<<"Дата должна находиться в пределах "/utf8, Min/binary, " - ", Max/binary,"!">>} ] };

validation({dateRegular, MinDate, MaxDate, _Lang}) ->
  Min =  integer_to_binary(MinDate),
  Max =  integer_to_binary(MaxDate),
  #validation {
    name = date, msg = <<"Введено неверное значение!"/utf8>>,
    options = [ {regexp,"^{([0-9]{4}),([0-9]{1,2}),([0-9]{1,2})}$",<<"Введена некорректная дата!"/utf8>>},
                {regCheckDate, "", <<"Введена некорректная дата регулярного платежа!"/utf8>>},
                {minMax,{MinDate,MaxDate},<<"Дата должна находиться в пределах "/utf8, Min/binary, " - ", Max/binary,"!">>} ] };

validation({otp, Lang}) -> #validation {
    name = otp,
    extract = fun(X) -> X#otp.code end,
    msg = translate({?MODULE, otpMsg}, Lang),
    options = [{regexp,"^[0-9]{1,}$",translate({?MODULE, otpMsg}, Lang)},
               {charQuantity, {4,4},translate({?MODULE, otpLength}, Lang)}] };

validation({card, Lang}) -> #validation{
    name= card,
    msg=  translate({?MODULE, cardMsg}, Lang),
    options= [ {cardRadio, "", translate({?MODULE, cardSelect1}, Lang)},
               {card, "", translate({?MODULE, cardSelect2}, Lang)} ]
};

validation({cardNoTax, CardNoTax,Lang}) -> #validation{
    name= card,
    msg=  translate({?MODULE, cardMsg}, Lang),
    options= [ {cardRadio, "", translate({?MODULE, cardSelect1}, Lang)},
               {card, "", translate({?MODULE, cardSelect2}, Lang)},
               {checkRef,CardNoTax, translate({?MODULE, usedCard4TaxFree}, Lang)} ]
};

validation({cardRegular, Curr, Lang}) -> #validation{
    name= card,
    msg=  translate({?MODULE, cardMsg}, Lang),
    options= [ {cardRadio, "", translate({?MODULE, cardSelect1}, Lang)},
               {card, "", translate({?MODULE, cardSelect2}, Lang)},
               {equalCurr, Curr, translate({?MODULE, cardSelect3}, Lang)}]
};

validation({terminationRadio, _Lang}) -> #validation{
  name= terminationRadio,
  msg=  <<"Bad!"/utf8>>,
  options= [ {reason, "", <<"There is no termination reason!"/utf8>>},
             {myReason, "", <<"There is no termination reason!"/utf8>>} ]
};

validation(true) -> #validation{
    name= true,
    msg= <<"true">>,
    options = [ {allwaysTrue,"",<<"allways true">>} ]
};

validation({amt, Name, Min, Max, RegExp, Lang}) ->
    MaxBin = list_to_binary(io_lib:format("~w",[money(Max)])),
    MinBin = list_to_binary(io_lib:format("~w",[money(Min)])),
    #validation {
        name = Name,
        msg = [translate({?MODULE, sumMsg}, Lang), MaxBin, "."],
        options = [{regexp,RegExp, translate({?MODULE, sumRegExp}, Lang)},
            {minMax,{Min,Max},[translate({?MODULE, sumMinMax1}, Lang), MinBin, translate({?MODULE, sumMinMax2}, Lang), MaxBin, "."]},
            {charQuantity, {1,18},translate({?MODULE, sumLength}, Lang)}] };

validation({prc, Name, Min, Max, Lang}) ->
    MaxBin = wf:to_binary(Max),
    MinBin = wf:to_binary(Min),
    #validation{
        name=Name,
        msg= [translate({?MODULE, sumMsg}, Lang), MaxBin, "."],
        options = [ {regexp,"^[0-9]{1,3}$", translate({?MODULE, prcRegExp}, Lang)},
                    {minMax,{Min,Max},[translate({?MODULE, prcMinMax1}, Lang), MinBin, translate({?MODULE, prcMinMax2}, Lang), MaxBin, "."]},
                    {charQuantity, {1,3},translate({?MODULE, prcLength}, Lang)} ]};

validation({rpayDate, Name, MinDate, MaxDate, Lang}) ->
    Min =  integer_to_binary(MinDate),
    Max =  integer_to_binary(MaxDate),
    #validation {
        name = Name, msg = <<"Incorrect value!"/utf8>>,
        options = [ {regexp,"^{([0-9]{4}),([0-9]{1,2}),([0-9]{1,2})}$",translate({?MODULE, badDate}, Lang)},
                    {regCheckDate, "", translate({?MODULE, badDateRP}, Lang)},
                    {minMax,{MinDate,MaxDate},translate({?MODULE, badDateMinMax,Min,Max}, Lang) } ]};

validation(_) -> #validation{}.

validate_values(Values) ->
    Errors = lists:foldl(
        fun({Name,Value},Acc) ->
            case validate(validation(Name),Value) of
                true -> Acc;
                {false,Message} -> [{false,Message}|Acc]
            end
        end, [], Values),
    case Errors of
        [] -> true;
         _ -> Errors
    end.

validate(#validation{name= Name, extract=Extract, msg=OveralMsg, options=Options}, Value0) ->
    Value  = Extract(Value0),
    case process_options(Options,Value) of
        true -> true;
        {false,[Validation,_,default]} -> {false,[Name,Validation,OveralMsg]};
        {false,[Validation,_,MSG]} -> {false,[Name,Validation,MSG]} end;
validate(_,_) -> {false,"Unknown validation"}.

process_options([],_Value) -> true;
process_options([Option={A,B,C}|Options],Value) ->
    case validate_option(Option,Value) of
        true ->
            wf:info(?MODULE,"Field Validation ~p ~nCheck Value ~p ~nStatus: true~n",[Option,Value]),
            process_options(Options,Value);
        false -> {false,[A,B,C]};
        {false,Code} -> {false,[A,B,proplists:get_value(Code,C,default)]} end.

validate_option({p24auth,_,_}, []) -> true;
validate_option({p24auth,_,_}, [{number, Number},{password,Pass},{ip,IP}]) ->
    case service(p24auth, p24Auth, [Number,Pass,IP],[]) of
        success -> true;
        {error, Code} -> {false,Code};
        _ -> {false,default} end;
validate_option({p24auth,_,_}, _) -> false;

validate_option({allwaysTrue,_,_},_) -> true;

validate_option({bonusCode, EkbId,_}, Value) ->
    service(bonus,checkBonus,[EkbId, Value],[]);

validate_option({regexp, Regexp,_}, Value) ->
    case re:run(wf:to_list(Value), Regexp) of
        {match, _} -> true;
        _ -> false end;

validate_option({charQuantity, {Min,Max},_}, Value) ->
    io:format("~n~n >>>>>>>>>>> charQuantity: ~p ~n~n",[Value]),
    Len = length(case Value of
              _ when is_integer(Value) -> integer_to_list(Value);
              _ when is_list(Value) -> Value;
              _ when is_binary(Value) -> binary_to_list(Value);
              _ when is_float(Value) ->  lists:flatten(io_lib:format("~.2f", [Value]));
              _ -> lists:flatten(io_lib:format("~w",[Value])) end),
    Min =< Len andalso Len =< Max;

validate_option({ minMax,{Min,Max},_}, Value0) ->
    Value = try money(wf:to_list(Value0))
          catch _:_ -> {Y,M,D} = term(Value0),
                  dateToInt(Y, M, D) end,
    case {Min,Max} of
         {[],[]}   -> true;
         {[],Max}  -> Value =< Max;
         {Min,[]}  -> Min =< Value;
         {_,_} -> Min=<Value andalso Value =< Max end;

validate_option({divisibleBy,Divisor,_}, Value) ->
    Money = money(Value),
    trunc(Money) == Money andalso Money /=0 andalso (trunc(Money) rem Divisor) == 0;

validate_option({card,_,_}, {#card{}, _RadioBtn}) -> true;      % рекорд #card{} принимается
validate_option({card,_,_}, {noCard,  _RadioBtn}) -> true;      % атом 'noCard' тоже принимается
validate_option({card,_,_}, { _bad ,  _RadioBtn}) -> false;     % всё остальное не принимается
validate_option({cardRadio, _, _}, {_Card, RadioBtn}) ->
  case RadioBtn of
    {false, false, false} -> false;
    _ -> true
  end;

validate_option({equalCurr, Curr, _}, {#card{currency = Curr}, _}) -> true;
validate_option({equalCurr, _, _}, {_,_}) -> false;
validate_option({checkRef, true, _}, _) -> true;
validate_option({checkRef,    _, _}, _) -> false;

validate_option({ checkDate,_,_}, Date) ->
    DateN = term(Date),
    calendar:valid_date(DateN);

validate_option({ regCheckDate,_,_}, Date) ->
    DateN = term(Date),
    {_Y, _M, D} = Date,
    case D of
        _ when D > 28 -> false;
        _ -> calendar:valid_date(DateN)
    end;

validate_option({radio,_,_}, Tuple) ->
  lists:member(true, tuple_to_list(Tuple));

validate_option({myReason,_,_}, {6,<<>>}) -> false;
validate_option({myReason,_,_}, {_,_}) -> true;
validate_option({reason,_,_}, {0,_}) -> false;
validate_option({reason,_,_}, {_,_}) -> true.

dev() -> application:set_env(act,services,services_fake).
ops() -> application:set_env(act,services,services_real).
pb () -> application:set_env(act,services,pb).

f(S, Args) -> lists:flatten(io_lib:format(S, Args)).

money([]) -> 0;
money(Money) when is_list(Money) -> try list_to_integer(Money) catch _:_ -> list_to_float(f("~s",[Money])) end;
money(Money) when is_float(Money) -> list_to_float(f("~.2f",[Money]));
money(Money) when is_integer(Money) -> Money.

term(String) when is_binary(String) -> binary_to_term(String);
term(String) when is_list(String) ->
  try {ok, Tokens, _} = erl_scan:string(String++"."),
        {ok, B} = erl_parse:parse_term(Tokens),
        B catch _:_ -> binary_to_term(String) end.

service(_,_,_,_) -> [].
