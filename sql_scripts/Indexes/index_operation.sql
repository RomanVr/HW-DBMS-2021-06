explain  select * from prepare.goods where id = 1;
select count(*) from prepare.goods;

select * from prepare.goods;

-----------------------------------------------------------
Create or replace function my_random_string(length integer) returns text as $$
declare
  chars text[] := '{А,Б,В,Г,Д,Е,Ж,З,И,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ч,Ш,Щ,Э,Ю,Я,а,б,в,г,д,е,ж,з,и,к,л,м,н,о,п,р,с,т,у,ф,х,ч,щ,ю,я}';
  result text := '';
  i integer := 0;
begin
  if length < 0 then
    raise exception 'Given length cannot be less than 0';
  end if;
  for i in 1..length loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$ LANGUAGE plpgsql;

---------------------------------------------------
Create or replace function my_random_number(start integer, stop integer) returns integer as $$
declare
  result integer := 1;
begin
  result := floor(random()*(stop-start)+start) + 1;
  return result;
end;
$$ LANGUAGE plpgsql;
---------------------------------------------------
insert into prepare.goods (namegoods, pins, typeassembly_id, description)
	select my_random_string(15), my_random_number(1, 48), 1, my_random_string(10)
	from generate_series(1, 10000);

set enable_indexscan=off;

-- степень упорядоченности данных
select attname, correlation from pg_stats where tablename='goods';


-- полнотекстовый поиск
select namegoods, to_tsvector(namegoods) from prepare.goods;
select namegoods, to_tsvector(namegoods), to_tsvector(namegoods)@@to_tsquery('0402') from prepare.goods;

alter table prepare.goods add column namegoods_lexeme tsvector;

update prepare.goods
	set namegoods_lexeme = to_tsvector(namegoods);

explain (analyze) select * from prepare.goods where namegoods_lexeme @@ to_tsquery('0402');

drop index if exists search_index_namegoods;
CREATE INDEX search_index_namegoods ON prepare.goods USING GIN (namegoods_lexeme);
analyze prepare.goods;

explain (analyze) select * from prepare.goods where namegoods_lexeme @@ to_tsquery('0402');


-- Частичный индекс

explain  select * from prepare.goods where pins < 3;
explain  select * from prepare.goods where pins > 60;

create index pins_great2 on prepare.goods(pins) where pins > 2;

explain  select * from prepare.goods where pins > 60;

-- Составной индекс
explain select * from prepare.goods
	where namegoods='STW48NM60N' and description = 'микросхема';

CREATE INDEX namegoods_descrip ON prepare.goods (namegoods, description);
