USE `orderManSys`;
DROP procedure IF EXISTS get_orders;
DELIMITER $$
USE `orderManSys`$$
CREATE PROCEDURE get_orders (
	IN_start_period datetime, 
    IN_end_period datetime,
    IN_column_group VARCHAR(50))
BEGIN
    SET @sql_select = CONCAT('SELECT ', IN_column_group, ', sum(co.PricePurchase) SumPurchase FROM CommercialOfferGoods co ');
    SET @sql_where = CONCAT('WHERE co.LastUpdate >= \'', IN_start_period, '\' AND co.LastUpdate <= \'', IN_end_period, '\'');
	SET @sql_group = CONCAT(' GROUP BY ', IN_column_group);
	SET @sql_query = CONCAT(@sql_select, @sql_where, @sql_group);
	PREPARE stmp FROM @sql_query;
    EXECUTE stmp;
END$$
DELIMITER ;

CALL get_orders('2020-01-01:00-00-00', '2021-01-01:00-00-00', 'Currency');
