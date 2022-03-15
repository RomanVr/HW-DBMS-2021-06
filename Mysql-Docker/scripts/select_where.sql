-- Запрос на поиск человека по части его имени
SELECT "Id", firstname, lastname, patronymic, age, tel_mobile, tel_work, "e-mail", departament, "Position", chief_id, organization_id, lastupdate
	FROM people
	WHERE firstname like '%р%';

-- Устанавливаем отвественного менеджера за расчет коммерческого предложения
UPDATE commercialofferorder
	SET managerpurchase_id=2, lastupdate=now()
    WHERE commercialofferorder.ordersp_id = 1;

-- Удаляем модуль из спецификации заказа и расчета коммерческого предложения
DELETE FROM commercialofferorder
	USING orderspecification
		WHERE commercialofferorder.ordersp_id = orderspecification.id and orderspecification.module_id = 1;

-- Выводим данные компонента для его редактирования
SELECT Goods.NameGoods, Goods.Pins, TypeAssembly.NameAssembly, Goods.Description
	FROM Goods
    INNER JOIN TypeAssembly ON TypeAssembly.id = Goods.TypeAssembly_id
    WHERE Goods.id = 1;
