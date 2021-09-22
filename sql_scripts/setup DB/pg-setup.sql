CREATE TABLESPACE tablespace_pg LOCATION '/var/lib/postgresql/ts_dir';
CREATE DATABASE orderManSys ENCODING 'UTF8' TABLESPACE tablespace_pg;

CREATE SCHEMA IF NOT EXISTS management;
COMMENT ON SCHEMA management IS 'Схема содержащая таблицы создания Заказа';

CREATE SCHEMA IF NOT EXISTS prepare;
COMMENT ON SCHEMA prepare IS 'Схема содержащая таблицы добавления новых компонентов и создания новых модулей';

COMMENT ON SCHEMA public IS 'Схема по умолчанию для таблиц Организаций и 
Людей';

CREATE SCHEMA IF NOT EXISTS purchase;
COMMENT ON SCHEMA purchase IS 'Схема для таблиц определяющие закупку и поставку компонентов и модулей';

CREATE SCHEMA IF NOT EXISTS store;
COMMENT ON SCHEMA store IS 'Схема, содержащая таблицы для операций с хранением товаров и модулей.';
