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
- [4. Создание объектов БД](#4)
- [5. DML: вставка, обновление, удаление, выборка данных](#5)

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
## <a id="4" /> 
4. Создание объектов БД
- [setup](./sql_scripts/pg-setup.sql)
- [create tables](./sql_scripts/create_tables.sql)
- [create users](./sql_scripts/create_users.sql)
## <a id="5" />
5. DML: вставка, обновление, удаление, выборка данных
- Вставка данных
```
INSERT INTO public.organization(
	nameorganization, location, typeorganization)
	VALUES ('РНИИРС', 'г. Ростов-на-Дону', 'заказчик'),
  ('Алмаз-СП', 'г. Москва', 'исполнитель') RETURNING "Id";
```
- Вставка данных COPY
```
COPY prepare.goods (namegoods, pins, typeassembly_id, description) 
FROM '/home/roman/Otus/HW-DBMS-2021-06/data/insert_goods_3.csv' 
DELIMITER E'\\t' CSV QUOTE '\"' ESCAPE '''';"";
```
- Вставка данных с использованием SELECT
```
-- Создание заказа для расчета коммерческого предложения по компонентам
INSERT INTO management.commercialofferorder(ordersp_id, goodscustomer_id, quantityspecification, unit)
	SELECT orderspecification."Id", goods."Id" as goodscustomer_id, (orderspecification.quantity * modulespecification.quantity) as quantity, modulespecification.unit 
	FROM management."Order"
			inner join management.orderspecification on "Order"."Id" = orderspecification.order_id
			inner join "prepare".modulespecification on orderspecification.module_id = modulespecification.module_id
			inner join "prepare".goods on modulespecification.goods_id = goods."Id";
```
- Запрос с использованием регулярного выражения
```
-- Запрос на поиск человека по части его имени 
SELECT "Id", firstname, lastname, patronymic, age, tel_mobile, tel_work, "e-mail", departament, "Position", chief_id, organization_id, lastupdate
	FROM public.people
	WHERE firstname ~* '(р|о)о';
```
- Запрос с UPDATE FROM
```
-- Устанавливаем отвественного менеджера за расчет коммерческого предложения
UPDATE management.commercialofferorder
	SET managerpurchase_id=2, lastupdate=now()
	FROM management.commercialofferorder as co
		INNER JOIN management.orderspecification ON orderspecification."Id" = co.ordersp_id
	WHERE orderspecification.order_id = 1;
  ```
  - DELETE с использованием USING
  ```
  -- Удаляем модуль из спецификации заказа и расчета коммерческого предложения
DELETE FROM management.commercialofferorder
	USING management.orderspecification 
		WHERE commercialofferorder.ordersp_id = orderspecification."Id" and orderspecification.module_id = 1;
```
