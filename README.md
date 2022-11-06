FIN: Тарифікаційний менеджер
============================

[![Hex pm](http://img.shields.io/hexpm/v/fin.svg?style=flat)](https://hex.pm/packages/fin)
[![Actions Status](https://github.com/erpuno/fin/workflows/mix/badge.svg)](https://github.com/erpuno/fin/actions)

FIN — це універсальний менеджер облікових записів, які містять історію тарифікованих транзакції. Облікові записи управляються BPMN процесами, активності яких визначені Erlang функціями. FIN, як приклад <a href="https://erp.uno">ERP.UNO</a> може бути використаний як прототип для побудови білінгових систем, банків та інших облікових систем.


Запуск
------

Бізнес-процеси підприємства BPE визначають інфраструктуру для оркестрування виробничих процесів згідно стандарту BPMN, та систем на основі декларативних правил. BPE зберігає транзакційно усі кроки бізнес-процесів у сучасній системі даних KVS на базі RocksDB.

```
$ mix deps.get
$ iex -S mix
$ open http://localhost:8041/app/index.html
```

Це навчальний приклад освітнього підготовчого курсу для інтернів, який використовується для здодобуття навичок програмування систем на бібліотеках <a href="https://n2o.dev">N2O.DEV</a>.

Аутентифікація
--------------

![image](https://user-images.githubusercontent.com/144776/200148867-67025100-560e-4dc5-bcdd-dacf88e50c83.png)

Процеси
-------

![image](https://user-images.githubusercontent.com/144776/200149087-e2a2af6a-bd5c-4006-b6fe-f3b95f12b11f.png)

Форми
-----

![image](https://user-images.githubusercontent.com/144776/200148896-b09d25b6-2c67-4d1d-b851-aaadc9164c82.png)

Транзакції
----------

![image](https://user-images.githubusercontent.com/144776/200149114-dcd21f61-28a4-4aa9-a020-bcb2f70b7a1f.png)

Автори
-------

* Максим Сохацький


