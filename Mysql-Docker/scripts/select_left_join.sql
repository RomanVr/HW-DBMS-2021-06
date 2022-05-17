-- Выбор сводной коммерческого предложения всех компонентов в одном заказе
SELECT Module.NameModule, Goods.NameGoods, CommercialOfferOrder.QuantitySpecification, CommercialOfferOrder.unit, CommercialOfferOrder.Purchase, CommercialOfferOrder.DatePurchase
	FROM CommercialOfferOrder
		LEFT JOIN CommercialOfferGoods ON CommercialOfferOrder.ComOfferGoods_id = CommercialOfferGoods.id
        INNER JOIN Goods ON CommercialOfferOrder.GoodsCustomer_id = Goods.id
        INNER JOIN OrderSpecification ON CommercialOfferOrder.OrderSp_id = OrderSpecification.id
        INNER JOIN Module ON  Module.id = OrderSpecification.Module_id
	WHERE OrderSpecification.Order_id = 1;
