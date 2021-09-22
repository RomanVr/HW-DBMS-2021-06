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
set attname, correlation from pg_stats where tablename='goods';
