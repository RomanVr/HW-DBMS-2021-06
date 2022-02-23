DROP DATABASE IF EXISTS orderManSys;

CREATE DATABASE IF NOT EXISTS orderManSys;
USE orderManSys;

-- 1 ************************************** Organization

CREATE TABLE IF NOT EXISTS Organization
(
 id             int PRIMARY KEY AUTO_INCREMENT,
 NameOrganization varchar(250) UNIQUE NOT NULL DEFAULT '',
 Location         varchar(250) NOT NULL DEFAULT '',
 TypeOrganization varchar(250) NOT NULL DEFAULT '',
 LastUpdate       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2 ************************************** public.People

CREATE TABLE IF NOT EXISTS People
(
 id              int PRIMARY KEY AUTO_INCREMENT,
 firstName       varchar(250) NOT NULL DEFAULT '',
 lastName        varchar(250) NOT NULL DEFAULT '',
 patronymic      varchar(250) NOT NULL DEFAULT '',
 age             int NOT NULL DEFAULT 0,
 tel_mobile      varchar(250) NOT NULL DEFAULT '',
 tel_work        varchar(250) NOT NULL DEFAULT '',
 e_mail          varchar(250) NOT NULL DEFAULT '',
 departament     varchar(250) NOT NULL DEFAULT '',
 position        varchar(250) NOT NULL DEFAULT '',
 chief_id        int NOT NULL DEFAULT 1,
 organization_id int NOT NULL DEFAULT 1,
 lastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_117 FOREIGN KEY ( chief_id ) REFERENCES People ( id ),
 CONSTRAINT FK_131 FOREIGN KEY ( organization_id ) REFERENCES Organization ( id ),
 CONSTRAINT check_Age CHECK ( age >=0 AND age < 100 ),
 CONSTRAINT unique_fullname UNIQUE (firstName, lastName, patronymic)
)
COMMENT = 'Таблица содержащая данные Людей участвующих в процессе';

-- 3 ************************************** management.Order

CREATE TABLE IF NOT EXISTS Orders
(
 id              bigint PRIMARY KEY AUTO_INCREMENT,
 nameOrder       varchar(250) NOT NULL DEFAULT '',
 dataCreate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 customer_id     int NOT NULL DEFAULT 1,
 deliveryAddress text NOT NULL,
 lastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_21 FOREIGN KEY ( Customer_id ) REFERENCES People ( id ),
 CONSTRAINT unique_order UNIQUE (NameOrder)
)
COMMENT = 'Таблица содержащая заказы';

-- INSERT **************************************

INSERT INTO Organization(
	nameorganization, location, typeorganization)
	VALUES ('', '', ''),
  ('РНИИРС', 'г. Ростов-на-Дону', 'заказчик'),
  ('Алмаз-СП', 'г. Москва', 'исполнитель'),
  ('Avnet', 'Europe', 'производитель');

INSERT INTO People(
	firstname, lastname, patronymic, age, tel_mobile,
	tel_work, e_mail, departament, position, organization_id)
	VALUES
      ('Василий', 'Лозовой', 'Николаевич', 35, '+7(918)5255518',
			'+7(863)2555253','tatian@yandex.ru', 'отдел НКО', 'Начальник', 2),
      ('Роман', 'Воробьев', 'Николаевич', 43, '+7(916)6666668',
			'+7(495)2216921','romakf99@yandex.ru', 'Pcb', 'Начальник', 3),
      ('Alex', '', '', 36, '',
			'','alex@gmail.com', 'sales', 'manager', 4);

INSERT INTO Orders(
	nameorder, datacreate, customer_id, deliveryaddress)
	VALUES ('1 order', now(), 2, 'Ростов-на-Дону');
