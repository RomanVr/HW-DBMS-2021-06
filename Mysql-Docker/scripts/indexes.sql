-- неиспользуемые индексы
SELECT * FROM sys.schema_unused_indexes;

-- индексы в таблице
SHOW INDEXES FROM Goods;

-- Сделать индекс неаидимым
ALTER TABLE Goods ALTER INDEX IdxNameGoods INVISIBLE;

-- Анализ индексов
id,  select_type, table,   partitions, type,  possible_keys, key,  key_len, ref,  rows,  filtered, Extra
'1', 'SIMPLE',    'Goods', NULL,       'ALL', NULL,          NULL, NULL,    NULL, '242', '0.41',   'Using where'
