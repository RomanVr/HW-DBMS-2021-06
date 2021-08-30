-- Создание заказа для расчета коммерческого предложения по компонентам
INSERT INTO management.commercialofferorder(ordersp_id, goodscustomer_id, quantityspecification, unit)
	SELECT orderspecification."Id", goods."Id" as goodscustomer_id, (orderspecification.quantity * modulespecification.quantity) as quantity, modulespecification.unit 
	FROM management."Order"
			inner join management.orderspecification on "Order"."Id" = orderspecification.order_id
			inner join "prepare".modulespecification on orderspecification.module_id = modulespecification.module_id
			inner join "prepare".goods on modulespecification.goods_id = goods."Id";

-- Запрос на поиск человека по части его имени 
SELECT "Id", firstname, lastname, patronymic, age, tel_mobile, tel_work, "e-mail", departament, "Position", chief_id, organization_id, lastupdate
	FROM public.people
	WHERE firstname ilike '%ч%'
	OR 	  lastname ilike '%ч%'
	OR	  patronymic ilike '%ч%';

-- Устанавливаем отвественного менеджера за расчет коммерческого предложения
UPDATE management.commercialofferorder
	SET managerpurchase_id=2, lastupdate=now()
	FROM management.commercialofferorder as co
		INNER JOIN management.orderspecification ON orderspecification."Id" = co.ordersp_id
	WHERE orderspecification.order_id = 1;

-- Удаляем модуль из спецификации заказа и расчета коммерческого предложения
DELETE management.commercialofferorder FROM management.commercialofferorder
		USING management.orderspecification
		INNER JOIN management.orderspecification ON orderspecification."Id" = commercialofferorder.ordersp_id
	WHERE orderspecification.module_id = 1;
