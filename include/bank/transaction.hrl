-ifndef(TRANSACTION_HRL).
-define(TRANSACTION_HRL, "transaction_hrl").

-record(transaction, {id,next,prev,
        timestamp,
        beneficiary,
        subsidiary,
        amount,
        tax,
        ballance,
        currency,
        description,
        info,
        prevdate,	% предыдущая дата транзакции
		rate,		% процентная ставка и налог
		item		% #item
        }).

-record(item, {
        timestamp,	% дата
        type, 		% тип движения
		day,		% количество дней
        amount		% сумма
}).

-endif.
