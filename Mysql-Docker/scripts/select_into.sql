select в таблицу CommercialOfferOrder вставить записи заказа на компоненты

INSERT INTO
	CommercialOfferOrder (OrderSp_id, GoodsCustomer_id, QuantitySpecification, unit)
	SELECT OrderSpecification.id as OrderSp_id, Goods.id as GoodsCustomer_id, ModuleSpecification.Quantity*OrderSpecification.Quantity as QuantitySpecification, ModuleSpecification.unit as unit
		FROM OrderSpecification
			INNER JOIN Module ON Module.id = OrderSpecification.Module_id
			INNER JOIN ModuleSpecification ON ModuleSpecification.Module_Id = Module.id
			INNER JOIN Goods ON Goods.id = ModuleSpecification.Goods_Id
		WHERE OrderSpecification.Order_id = 2;
