-- Функция получения к-ва заказов модуля
CREATE DEFINER=`root`@`localhost` FUNCTION `getCountOrdersByIDModule`(moduleId INT) RETURNS int
BEGIN
	DECLARE countOrders INT;
    SELECT count(OrderSpecification.Order_id) INTO countOrders
		FROM OrderSpecification WHERE OrderSpecification.Module_id = moduleid;
	RETURN countOrders;
END

-- Процедура
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateModuleINOrder`(IN moduleId INT, IN oldGoodsId INT, IN newGoodsId INT, IN newQuantity decimal)
BEGIN
	DECLARE countOrders INT;
    DECLARE OrderSpId INT;
    SELECT getCountOrdersByIDModule(moduleId) INTO countOrders;
    IF countOrders = 1
    THEN
		-- Получаем id спецификации заказа
		SELECT OrderSpecification.id INTO OrderSpId
			FROM OrderSpecification WHERE Module_id = moduleId;
		-- Удаляем старый компонент из спецификации
		DELETE FROM ModuleSpecification
			WHERE ModuleSpecification.Goods_Id = oldGoodsId;
		-- Добавляем новый компонент в спецификацию модуля
		INSERT INTO ModuleSpecification (Goods_Id, Module_Id, Quantity)
			VALUES (newGoodsId, moduleId, newQuantity);
		-- Удаляем из заказа компонентов старый компонент
		DELETE FROM CommercialOfferOrder
			WHERE CommercialOfferOrder.GoodsCustomer_id	= oldGoodsId
				AND CommercialOfferOrder.OrderSp_id = OrderSpId;
		-- Добавляем новый компонент в заказ компонентов
		INSERT INTO CommercialOfferOrder (OrderSp_id, GoodsCustomer_id, QuantitySpecification)
			VALUES (OrderSpId, newGoodsId, newQuantity);
	END IF;
END
