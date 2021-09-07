INSERT INTO public.organization(
	nameorganization, location, typeorganization)
	VALUES ('', '', ''),
  ('РНИИРС', 'г. Ростов-на-Дону', 'заказчик'),
  ('Алмаз-СП', 'г. Москва', 'исполнитель'),
  ('Avnet', 'Europe', 'производитель') RETURNING id;

INSERT INTO public.people(
	firstname, lastname, patronymic, age, tel_mobile,
	tel_work, "e-mail", departament, position, organization_id)
	VALUES ('', '', '', 0, '',
			'','', '', '', 1),
      ('Василий', 'Лозовой', 'Николаевич', 35, '+7(918)5255518',
			'+7(863)2555253','tatian@yandex.ru', 'отдел НКО', 'Начальник', 2),
      ('Роман', 'Воробьев', 'Николаевич', 43, '+7(916)6666668',
			'+7(495)2216921','romakf99@yandex.ru', 'Pcb', 'Начальник', 3),
      ('Alex', '', '', 36, '',
			'','alex@gmail.com', 'sales', 'manager', 4) RETURNING id;

INSERT INTO prepare.typeassembly (nameassembly) VALUES ('SMT'), ('DIP'), ('Сборка') RETURNING id;

INSERT INTO prepare.Module(
	namemodule, constructor_id)
	VALUES
	('468181.666', 2),
	('468352.070', 2),
	('468716.001', 2),
	('468214.100', 2),
	('436637.043', 2)
  RETURNING id;

INSERT INTO management.Order(
	nameorder, datacreate, customer_id, deliveryaddress)
	VALUES ('1 order', now(), 2, 'Ростов-на-Дону') RETURNING id;

-- !!! Run copy goods and module_specification !!!

INSERT INTO management.orderspecification(
	order_id, module_id, quantity, assembly)
	VALUES
	(1, 1, 25, true),
	(1, 2, 10, true),
	(1, 3, 33, true),
	(1, 4, 17, true),
	(1, 5, 9, true) RETURNING id;
