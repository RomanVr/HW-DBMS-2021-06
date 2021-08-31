COPY prepare.goods (namegoods, pins, typeassembly_id, description) 
FROM '/home/roman/Otus/HW-DBMS-2021-06/data/insert_goods_3.csv' 
DELIMITER E'\\t' CSV QUOTE '\"' ESCAPE '''';"";
