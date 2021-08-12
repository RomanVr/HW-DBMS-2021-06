# HW-DBMS-2021-06
## Студент: **Воробьев Роман Николаевич**
## Проект: **ИС управления заказами**
### Описание: Данная информационная сиситема предназначена для управления заказами коллективом сотрудников, целью которых вляется:
- Поставка электронных компонентов
- Поставка печатных плат, изготавливаемых по заданию заказчика
- Поставка модулей с монтажом электронных компонентов на них

## Оглавление
- [1. Общее описаниие, ER-диаграмма](#1)
- [2. Дополнительные Ограничения и Индексы](#2)
- [3. Установка Postgres и подключение](#3)

## <a id="1" />
###  1. Структура организации состоит из отделов:
- Отдел по работе с клиентами
- Отдел закупок электронных компонентов
- Отдел Логистики и ВЭД
- Отдел склада и учета продукции

<code>![ER-diagramm](/OrderManagementSysytem.png "ER-diagramm")</code>

### Данная Система позволяет вести учет:
+ Поступающих заказов и их состава
+ Спецификаций модулей
+ Ценообразование в течении времени работы
+ Хранимых комопонентов и их расходование при выполнении заказов

Автоматизирует такие процессы как:
+ Составление ведомости закупки на основе состава модулей
+ Составление коммерческих предложений в разных вариациях по составу
+ Составление логистических и финансовых отчетов
+ Отслеживание всего заказа на всех его этапах от начала выставления коммерческого предложения до моммента отправки заказчику

## <a id="2" /> 
### 2. Дополнительные Ограничения и Индексы
- table "People"
    - При создании таблицы добавляем ограничение на поле Age, которое ограничивает диапазон возраста.

    ```
    CONSTRAINT check_Age CHECK ( Age >0 AND Age < 100 )
    ```
   - Добавляем индекс для поиска Персоны, вероятней большую выборку дает фамилия, а Имя или Отчество дают равную выборку при том, что Имя чаще хранится иногда бывает Отчество не записано.

    ```
    CREATE INDEX Name ON "public".People USING btree
    (
        LastName,
        FirstName, 
        Patronymic
    );
    ```

- table "Order"
    - Добавляем индекс по Имени Заказа, наиболее частый параметр для поиска.
    ```
    CREATE INDEX NameOrder ON "public"."Order" ( NameOrder );
    ```
- table "Goods"
    - Добавляем индекс по имени Товара со свойством уникальный
    ```
    CREATE UNIQUE INDEX NameGoods ON "public".Goods ( NameGoods ) INCLUDE ( NameGoods );
    ```
- table "CommercialOfferGoods"
    - При создании таблицы указываем ограничение на цену товара - должна быть больше 0.
    ```
    CONSTRAINT Check_Price CHECK ( PricePurchase > 0 )
    ```
## <a id="3" /> 
3. Установка Postgres и подключение
    - Connect to Postgres from Docker![gif](./dockerConn.gif)
    - Connect to Postgres from PG Admin![gif](./pgAdminConn.gif)
4. Создание объектов БД
- [setup](./sql_scripts/pg-setup.sql)
- [create tables](./sql_scripts/create_tables.sql)
- [create users](./sql_scripts/create_users.sql)
