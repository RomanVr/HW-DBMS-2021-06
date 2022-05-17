USE `orderManSys`;
DROP procedure IF EXISTS queryFilter;
DELIMITER $$
USE `orderManSys`$$
CREATE PROCEDURE queryFilter (
	IN sort_column VARCHAR(50),
	IN columnX VARCHAR(50),
	IN columnY VARCHAR(50),
  IN limit_count INTEGER,
  IN offset_count INTEGER)
BEGIN
    SET @sqlQuery = 'SELECT g.id, g.NameGoods, g.Description, t.NameAssembly
		FROM Goods g INNER JOIN TypeAssembly t ON g.TypeAssembly_id = t.id';
    IF columnX  != '' THEN
		SET @sqlQuery = CONCAT(@sqlQuery, ' WHERE g.NameGoods LIKE \'%', columnX, '%\'');
	ELSEIF columnY != '' THEN
		SET @sqlQuery = CONCAT(@sqlQuery, ' WHERE g.Description = \'', columnY, '\'');
	END IF;

    SET @sqlQuery = CONCAT(@sqlQuery, ' ORDER BY ', sort_column, ' ASC');
    SET @sqlQuery = CONCAT(@sqlQuery, ' LIMIT ', limit_count, ', ', offset_count);

    PREPARE stmp FROM @sqlQuery;
    EXECUTE stmp;

END$$
DELIMITER ;

CALL queryFilter('NameGoods', '', 'микросхема', 3, 10);
