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



-- INSERT **************************************

INSERT INTO Organization(
	nameorganization, location, typeorganization)
	VALUES ('', '', ''),
  ('РНИИРС', 'г. Ростов-на-Дону', 'заказчик'),
  ('Алмаз-СП', 'г. Москва', 'исполнитель'),
  ('Avnet', 'Europe', 'производитель');
