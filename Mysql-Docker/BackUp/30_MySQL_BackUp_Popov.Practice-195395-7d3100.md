#   MySQL. Backup & Restore.

##  Prepare VM for Demo
```bash
cd ~/Otus/DBMS/MySQL/30_MySQL_BackUp/demo
chmod 400 ub_vks.pem
ssh -i ub_vks.pem ubuntu@10.10.10.10
sudo bash
# apt-get update && apt-get install -y curl wget lsb-release nano mc && apt-get clean all
# sudo apt update && sudo apt install -y mc && sudo apt-get clean all
sudo apt install -y mc
```

##  Install mysql-server
```bash
sudo apt update && sudo apt install -y mysql-server && sudo apt clean all
```

##  Config mysql-server
### Securing the MySQL server deployment
```bash
sudo mysql_secure_installation
```
### Config auth method
```
sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';
FLUSH PRIVILEGES;
SELECT user,authentication_string,plugin,host FROM mysql.user;
exit
```

##  Installing Percona XtraBackup from Repositories
(https://www.percona.com/doc/percona-xtrabackup/8.0/installation/apt_repo.html)
```bash
# percona-xtrabackup-24
cd /tmp
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb && \
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb && \
sudo percona-release enable-only tools release && \
sudo apt update && \
sudo apt install -y percona-xtrabackup-80 qpress
```

##  Connect MySQL
```bash
# mysql -h localhost -P 3306 -u root -p
sudo mysql
show databases;
```

##  Import Example Databases
(https://dev.mysql.com/doc/index-other.html)
```
cd /tmp
curl -O https://downloads.mysql.com/docs/world-db.zip
unzip world-db.zip
more /tmp/world-db/world.sql

sudo mysql
source /tmp/world-db/world.sql;
show databases;
use world;
show tables;

select count(*) from city; -4079
select * from city limit 0,10;
```

##  MySQLDump
(https://dev.mysql.com/doc/refman/8.0/en/backup-and-recovery.html)
```bash
sudo mkdir -p /tmp/backups/mysqldump/base
sudo chmod -R 777 /tmp/backups/
cd /tmp/backups/mysqldump
#mysqldump -d world --host=localhost --port=3306 --user=root --password | more
```
### Backup

#### Dump examples
```bash
sudo mysqldump --databases mysql world > base/backup_base_1.sql
more base/backup_base_1.sql

sudo mysqldump world > base/backup_base_2.sql
more base/backup_base_2.sql    

sudo mysqldump world city > base/backup_base_3.sql
more base/backup_base_3.sql  

sudo mysqldump -d world city country > base/backup_base_4.sql
more base/backup_base_4.sql

sudo mysqldump -d world | more //Withuot data
sudo mysqldump -R -d world | more //Dump stored routines (functions and procedures)

sudo mysqldump world --tab=base //Delimited-Text Format
sudo mysql
--SHOW VARIABLES LIKE "secure_file_priv";
--SELECT @@secure_file_priv;

sudo mysqldump world --tab=/var/lib/mysql-files/ --fields-terminated-by=';'
sudo ls -lh /var/lib/mysql-files/
sudo more /var/lib/mysql-files/city.sql
sudo more /var/lib/mysql-files/city.txt

# Dump только триггеров, процедур и событий
sudo mysqldump --no-create-info --no-data --triggers --routines --events world > base/backup_base_5.sql

# Dump части таблицы
sudo mysqldump world city --where="id > 3500" > base/backup_base_6.sql
more base/backup_base_6.sql
```

### Restore

#### Restore Database
```sql
sudo mysqladmin create world2
sudo mysql world2 < base/backup_base_2.sql

sudo mysql
show databases;
select count(*) from world.city;
select count(*) from world2.city;
use world2;
show tables;

mysql> create database if not exists world2;
mysql> use world2;
mysql> source base/backup_base_2.sql;
```

#### Simple way restore one table
```
sudo mysql world < base/backup_base_3.sql
```
#### Correct way restore one table
```sql
sudo mysql world
show tables;
select count(*) from city; //4079
drop table city;
show tables;

sed -n -e '/DROP TABLE.*`city`/,/UNLOCK TABLES/p' base/backup_base_2.sql > base/table_city.sql
more base/table_city.sql
sudo mysql world < base/table_city.sql

sudo mysql world
show tables;
select count(*) from city;
```

#### Full backup
(https://dev.mysql.com/doc/refman/8.0/en/backup-policy.html)
--single-transaction - консистентный дамп, Никакие изменения, которые происходят с таблицами InnoDB во время дампа, не будут включены в дамп. Таким образом, дамп - это моментальный снимок баз данных в момент запуска дампа, независимо от того, сколько времени занимает процесс дампа.
--flush-logs ротация bin-логов
```
sudo rm -rf /tmp/backups/mysqldump/base/*
ls -lh /tmp/backups/mysqldump/base/

sudo mysqldump --all-databases --single-transaction \
    > base/backup_base_1.sql
more base/backup_base_1.sql
sudo ls -lh /var/lib/mysql

sudo mysqldump --all-databases --single-transaction --flush-logs \
    > base/backup_base_2.sql
more base/backup_base_2.sql
sudo ls -lh /var/lib/mysql

sudo mysqldump --all-databases --single-transaction --flush-logs \
    --delete-master-logs > base/backup_base_3.sql
sudo ls -lh /var/lib/mysql

sudo mysqldump world --single-transaction \
    > base/backup_base_1.sql
sudo mysqldump world --single-transaction | gzip \
    > base/backup_base_1.sql.gz
sudo ls -lh base
gunzip < base/backup_base_1.sql.gz | sudo mysql world2
```

#### MySQLBinlog
```bash
sudo ls -lh /var/lib/mysql
#sudo mysqlbinlog -v --base64-output=DECODE-ROWS /var/lib/mysql/binlog.000007
sudo mysql world
select * from city where id = 3665;
update city set name = 'Shahty12345' where id = 3665;

sudo mysqlbinlog -v --base64-output=DECODE-ROWS /var/lib/mysql/binlog.000005 | more
sudo cp /var/lib/mysql/binlog.000005 base

sudo mysqldump --all-databases --single-transaction --flush-logs \
    --delete-master-logs > base/backup_base_4.sql

sudo mysqlbinlog -v --base64-output=DECODE-ROWS /var/lib/mysql/binlog.000006 | more

sudo ls -lh /var/lib/mysql
sudo mysqlbinlog -v base/binlog.000005 | more //at 156

sudo mysql world
update city set name = 'Shahty67890' where id = 3665;
select * from city where id = 3665;

sudo mysqlbinlog base/binlog.000007 \
    --start-position=235 \
    --stop-position=497 \
    --start-datetime="2021-11-01 01:00:00"
    --stop-datetime="2021-11-10 01:00:00"
    > base/bl_city.sql

sudo mysqlbinlog base/binlog.000005 \
    > base/bl_city.sql

sudo more base/bl_city.sql

sudo mysqlbinlog base/binlog.000005 | sudo mysql world

sudo mysql world
select * from city where id = 3665;

sudo mysql
--SHOW VARIABLES LIKE "binlog%";
--binlog_format | ROW
```

##  MySQLPump
mysqlpump

##  xtrabackup
(https://www.percona.com/doc/percona-xtrabackup/8.0/backup_scenarios/full_backup.html)

### Backup
```bash
mkdir -p /tmp/backups/xtrabackup/{base,inc1,inc2,partial,stream}
sudo chmod -R 777 /tmp/backups/
cd /tmp/backups/xtrabackup

#xtrabackup --backup --target-dir=/tmp/backups/xtrabackup/base --host=localhost --port=3306 --user=root --password=example 
sudo xtrabackup --backup --no-server-version-check --target-dir=/tmp/backups/xtrabackup/base 

sudo du -sh /var/lib/mysql
sudo du -sh /tmp/backups/xtrabackup/base

sudo ls -lh /var/lib/mysql
sudo ls -lh /tmp/backups/xtrabackup/base/
sudo more /tmp/backups/xtrabackup/base/xtrabackup_binlog_info
sudo more /tmp/backups/xtrabackup/base/xtrabackup_info
# sudo more /tmp/backups/xtrabackup/base/xtrabackup_logfile
sudo more /tmp/backups/xtrabackup/base/xtrabackup_checkpoints

sudo mysql world

# select * from city where CountryCode = 'RUS';
select * from city where id in (3629,3704);
update city set name = 'Sochi' where id = 3629;
update city set name = 'Balashikha' where id = 3704;
select * from city where id in (3629,3704);

sudo xtrabackup --backup --no-server-version-check \
    --target-dir=/tmp/backups/xtrabackup/inc1 \
    --incremental-basedir=/tmp/backups/xtrabackup/base 

sudo du -sh /tmp/backups/xtrabackup/*
sudo more /tmp/backups/xtrabackup/inc1/xtrabackup_info

sudo mysql world
select * from city where id = 3665;
update city set name = 'Shahty' where id = 3665;
select * from city where id in (3629,3665,3704);

sudo xtrabackup --backup --no-server-version-check \
    --target-dir=/tmp/backups/xtrabackup/inc2 \
    --incremental-basedir=/tmp/backups/xtrabackup/inc1

sudo du -sh /tmp/backups/xtrabackup/*
sudo more /tmp/backups/xtrabackup/inc2/xtrabackup_info

ls -lh /tmp/backups/xtrabackup/inc1/
ls -lh /tmp/backups/xtrabackup/inc2/
```

### Restore

#### Ooops
```bash
sudo mysql
show databases;
select count(*) from world.city; //4079

sudo systemctl stop mysql

sudo su
rm -rf /var/lib/mysql/*
ls -lh /var/lib/mysql
exit
```

sudo systemctl start mysql
sudo systemctl status mysql

#### Prepare
```bash
sudo ls -lh /tmp/backups/xtrabackup/base
sudo xtrabackup --prepare --apply-log-only --target-dir=/tmp/backups/xtrabackup/base
sudo ls -lh /tmp/backups/xtrabackup/base
sudo xtrabackup --prepare --apply-log-only --target-dir=/tmp/backups/xtrabackup/base \
    --incremental-dir=/tmp/backups/xtrabackup/inc1
sudo ls -lh /tmp/backups/xtrabackup/base
```

#### Restore
```bash
sudo xtrabackup --copy-back --target-dir=/tmp/backups/xtrabackup/base \
    --datadir=/var/lib/mysql

sudo ls -lh /var/lib/mysql

sudo systemctl start mysql
tail -n 50 /var/log/mysql/error.log

sudo chown -R mysql.mysql /var/lib/mysql
sudo ls -lh /var/lib/mysql
sudo systemctl start mysql
sudo systemctl status mysql

sudo mysql
show databases;
select count(*) from world.city; //4079
select * from world.city where id in (3629,3665,3704);
```

#### Restore Incremental
```bash
sudo xtrabackup --prepare --apply-log-only --target-dir=/tmp/backups/xtrabackup/base \
    --incremental-dir=/tmp/backups/xtrabackup/inc2
sudo ls -lh /tmp/backups/xtrabackup/base

sudo systemctl stop mysql
sudo su
rm -rf /var/lib/mysql/*
ls -lh /var/lib/mysql
exit

sudo xtrabackup --copy-back --target-dir=/tmp/backups/xtrabackup/base \
    --datadir=/var/lib/mysql

sudo ls -lh /var/lib/mysql
sudo chown -R mysql.mysql /var/lib/mysql
sudo systemctl start mysql
sudo systemctl status mysql

sudo mysql
select * from world.city where id in (3629,3665,3704);
```

#### Partial Backup & Restore

##### Table
```bash
sudo xtrabackup --backup --no-server-version-check \
    --datadir=/var/lib/mysql \
    --target-dir=/tmp/backups/xtrabackup/partial --tables="^world.ci.*"
# sudo xtrabackup --backup --tables-file=/tmp/tables.txt
# sudo xtrabackup --backup --databases="mysql world"

sudo ls -lh partial
sudo ls -lh partial/world

sudo mysqldump -d world city > partial/city.sql
sudo more partial/city.sql

sudo mysql world
select count(*) from city; //4079
drop table city;
exit

sudo xtrabackup --prepare --export --target-dir=/tmp/backups/xtrabackup/partial
sudo ls -lh partial/world

sudo mysql world < partial/city.sql
sudo mysql world
desc city;
select count(*) from city;

alter table city discard tablespace;
exit

sudo cp partial/world/city.ibd /var/lib/mysql/world
sudo chown -R mysql.mysql /var/lib/mysql/world/city.ibd

sudo mysql world
alter table city import tablespace;
select count(*) from city;
select * from world.city where id in (3629,3665,3704);
```

##### Single DataBase
```bash
sudo mkdir -p /tmp/backups/world
sudo chmod -R 777 /tmp/backups/world
cd /tmp/backups/
```
###### Backup
```bash
sudo mysqldump -R -d world > world/backup_world-db.sql

sudo mysql -N -B <<'EOF' > world/backup_world-db_alter_discard_tables.sql
SELECT 'SET FOREIGN_KEY_CHECKS=0;' UNION SELECT CONCAT('ALTER TABLE ', table_name, ' DISCARD TABLESPACE;') AS _ddl FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='world';
EOF

sudo mysql -N -B <<'EOF' > world/backup_world-db_alter_import_tables.sql
SELECT CONCAT('ALTER TABLE ', table_name, ' IMPORT TABLESPACE;') AS _ddl FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='world';
EOF

sudo xtrabackup --backup --no-server-version-check \
    --databases="world" \
    --datadir=/var/lib/mysql \
    --target-dir=/tmp/backups/world 

sudo ls -lh world
```
###### Ooops
```bash
sudo mysqladmin drop world
sudo mysql world -e "show databases;"
sudo ls -lh /var/lib/mysql/
```
###### Restore
```bash
sudo xtrabackup --prepare --export --target-dir=/tmp/backups/world

sudo mysqladmin create world
sudo mysql world -e "show databases;"
sudo ls -lh /var/lib/mysql/

sudo mysql world < world/backup_world-db.sql
sudo mysql world -e "show tables;"
sudo mysql world -e "select count(*) from city;"

#ALTER TABLES DISCARD TABLESPACE;
sudo mysql world < world/backup_world-db_alter_discard_tables.sql

sudo cp -a world/world/. /var/lib/mysql/world/
sudo chown -R mysql.mysql /var/lib/mysql/world
sudo ls -lh /var/lib/mysql/world

#ALTER TABLES IMPORT TABLESPACE;
sudo mysql world < world/backup_world-db_alter_import_tables.sql

sudo mysql world -e "show tables;"
sudo mysql world -e "select count(*) from city;"
sudo mysql world -e "select count(*) from country;"
sudo mysql world -e "select count(*) from countrylanguage;"
```

#### Stream into file
```bash
sudo xtrabackup --backup --no-server-version-check \
    --stream=xbstream \
    --target-dir=/tmp/backups/xtrabackup/stream \
    > stream/backup.xbstream

sudo ls -lh stream

sudo xtrabackup --backup --no-server-version-check \
    --stream=xbstream --compress \
    --target-dir=/tmp/backups/xtrabackup/stream \
    > stream/backup_cmprs.xbstream

sudo ls -lh stream

sudo xtrabackup --backup --no-server-version-check \
    --stream=xbstream \
    --target-dir=/tmp/backups/xtrabackup/stream \
    | gzip - | openssl des3 -salt -k "password" \
    > stream/backup_des.xbstream.gz.des3

sudo ls -lh stream

# scp -i ub_vks.pem ubuntu@10.10.10.10:/tmp/backups/xtrabackup/stream/backup_des.xbstream.gz.des3 \
#    ~/Otus/DBMS/MySQL/30_MySQL_BackUp/Demo/
# scp -i ub_vks.pem ubuntu@10.10.10.10:/tmp/backups/mysqldump/world-db.sql \
#    ~/Otus/DBMS/MySQL/30_MySQL_BackUp/Demo/

openssl des3 -salt -k "password" -d -in stream/backup_des.xbstream.gz.des3 \
    -out stream/backup_des.xbstream.gz
gzip -d stream/backup_des.xbstream.gz 

cd stream
xbstream -x < backup_des.xbstream
cd ..
sudo ls -lh stream
```

#### Stream on another server
```bash
cd ~/Otus/DBMS/MySQL/30_MySQL_BackUp/demo/
ssh -i ub_vks.pem ubuntu@10.10.10.10 sudo xtrabackup --backup --no-server-version-check --stream=xbstream --compress --target-dir=/tmp/backups/xtrabackup/stream > ~/Otus/DBMS/MySQL/30_MySQL_BackUp/demo/backup.xbstream

sudo xtrabackup --backup --no-server-version-check \
    --stream=xbstream --compress \
    --target-dir=/tmp/backups/xtrabackup/stream \
    | ssh ubuntu@10.80.1.2 "xbstream -x -C backup"

cd ~/Otus/DBMS/MySQL/30_MySQL_BackUp/demo/
ssh -i ub_vks.pem ubuntu@10.80.1.2

# on listener
sudo mkdir /tmp/backups
sudo chmod -R 777 /tmp/backups/
cd /tmp/backups/
ls -lh 
nc -l 9999 | cat - > ./backup.xbstream

# on MySQL Server
sudo xtrabackup --backup --no-server-version-check \
    --stream=xbstream \
    --target-dir=/tmp/backups/xtrabackup/stream \
    | nc 10.80.1.2 9999

# on listener
ls -lh 
xbstream -x < backup.xbstream
```