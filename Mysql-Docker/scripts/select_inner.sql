-- Выбор спецификации конкретного модуля
SELECT Module.NameModule, Goods.NameGoods, ModuleSpecification.Quantity, ModuleSpecification.unit, TypeAssembly.NameAssembly
	FROM Module
		INNER JOIN ModuleSpecification ON Module.id = ModuleSpecification.Module_Id
        INNER JOIN Goods ON ModuleSpecification.Goods_Id = Goods.id
        INNER JOIN TypeAssembly ON TypeAssembly.id = Goods.TypeAssembly_id
	WHERE Module.NameModule LIKE '436637.043';
