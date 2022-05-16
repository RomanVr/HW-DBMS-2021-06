-- Создать процедуру выборки товаров с использованием различных фильтров: категория, цена,
-- производитель, различные дополнительные параметры Также в качестве параметров передавать
-- по какому полю сортировать выборку, и параметры постраничной выдачи
USE `orderManSys`;
DROP procedure IF EXISTS queryFilter;
DELIMITER $$
USE `orderManSys`$$
CREATE PROCEDURE queryFilter (
	IN nameX CHAR(50),
    IN descripY CHAR(50),
    IN typeAssemblyZ CHAR(50),
    IN sortType CHAR(5),
    IN limitRow INTEGER,
    OUT pageCount INTEGER
)
BEGIN
	DECLARE sortColumn VARCHAR(50);
	IF sortType = 'name' THEN
		SET sortColumn = 'NameGoods';
	END IF;
	SELECT g.id, g.NameGoods, g.Description, t.NameAssembly
		FROM Goods g INNER JOIN TypeAssembly t ON g.TypeAssembly_id = t.id
		WHERE g.NameGoods = nameX or g.Description = descripY or t.NameAssembly = typeAssemblyZ
        ORDER BY sortColumn;
END$$
DELIMITER ;
