DROP DATABASE IF EXISTS orderManSys;

CREATE DATABASE IF NOT EXISTS orderManSys;
USE orderManSys;

-- 1 ************************************** Organization

CREATE TABLE IF NOT EXISTS Organization
(
 id               int PRIMARY KEY AUTO_INCREMENT,
 NameOrganization varchar(250) NOT NULL DEFAULT '',
 Location         varchar(250) NOT NULL DEFAULT '',
 TypeOrganization varchar(250) NOT NULL DEFAULT '',
 LastUpdate       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 
 UNIQUE INDEX IdxNameOrg (NameOrganization)
);

-- 2 ************************************** public.People

CREATE TABLE IF NOT EXISTS People
(
 id              int PRIMARY KEY AUTO_INCREMENT,
 firstName       varchar(250) NOT NULL DEFAULT '',
 lastName        varchar(250) NOT NULL DEFAULT '',
 patronymic      varchar(250) NOT NULL DEFAULT '',
 ofBirth         date NOT NULL,
 gender          varchar(250) NOT NULL DEFAULT '',
 department      varchar(250) NOT NULL DEFAULT '',
 position        varchar(250) NOT NULL DEFAULT '',
 chief_id        int NOT NULL DEFAULT 1,
 organization_id int NOT NULL DEFAULT 1,
 attributes      JSON NOT NULL,
 lastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_117 FOREIGN KEY ( chief_id ) REFERENCES People ( id ),
 CONSTRAINT FK_131 FOREIGN KEY ( organization_id ) REFERENCES Organization ( id ),
 
 INDEX fkIdx_118 (Chief_id),
 INDEX fkIdx_132 (Organization_id),
 UNIQUE INDEX fullName USING btree (FirstName, LastName, Patronymic)
)
COMMENT = 'Таблица содержащая данные Людей участвующих в процессе';

-- 3 ************************************** management.Order

CREATE TABLE IF NOT EXISTS Orders
(
 id              bigint PRIMARY KEY AUTO_INCREMENT,
 nameOrder       varchar(250) NOT NULL DEFAULT '',
 dataCreate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
 customer_id     int NOT NULL DEFAULT 1,
 deliveryAddress text NOT NULL,
 lastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_21 FOREIGN KEY ( Customer_id ) REFERENCES People ( id ),
 
 INDEX fkIdx_22 ( Customer_id ),
 UNIQUE INDEX IdxNameOrder ( NameOrder )
)
COMMENT = 'Таблица содержащая заказы';

-- 4 ************************************** prepare.TypeAssembly

CREATE TABLE IF NOT EXISTS TypeAssembly
(
 id           int PRIMARY KEY AUTO_INCREMENT,
 NameAssembly varchar(250) NOT NULL,
 LastUpdate   timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 UNIQUE INDEX IdxNameAssembly (NameAssembly)
);

-- 5 ************************************** prepare.Module

CREATE TABLE IF NOT EXISTS Module
(
 id             int PRIMARY KEY AUTO_INCREMENT,
 NameModule     varchar(250) NOT NULL,
 Constructor_id int NOT NULL DEFAULT 1,
 Description    text,
 LastUpdate     timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_72 FOREIGN KEY ( Constructor_id ) REFERENCES People ( id ),
 
 UNIQUE INDEX IdxModuleName (NameModule),
 INDEX fkIdx_73 ( Constructor_id )
);

-- 6 ************************************** prepare.Goods

CREATE TABLE IF NOT EXISTS Goods
(
 id              bigint PRIMARY KEY AUTO_INCREMENT,
 NameGoods       varchar(250) NOT NULL,
 Pins            int NOT NULL,
 TypeAssembly_id int NOT NULL,
 Description     varchar(250) NOT NULL DEFAULT '',
 LastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_34 FOREIGN KEY ( TypeAssembly_id ) REFERENCES TypeAssembly ( id ),
  
 UNIQUE INDEX IdxNameGoods ( NameGoods ),
 INDEX fkIdx_35 ( TypeAssembly_id )
);

-- 7 ************************************** management.OrderSpecification

CREATE TABLE IF NOT EXISTS OrderSpecification
(
 id          bigint PRIMARY KEY AUTO_INCREMENT,
 Order_id    bigint NOT NULL,
 Module_id   int NOT NULL,
 Quantity    int NOT NULL,
 Assembly    boolean NOT NULL DEFAULT false,
 LastUpdate  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_52 FOREIGN KEY ( Order_id ) REFERENCES Orders ( id ),
 CONSTRAINT FK_93 FOREIGN KEY ( Module_id ) REFERENCES Module ( id ),
 
 INDEX fkIdx_53 ( Order_id ),
 INDEX fkIdx_94 ( Module_id )
);

-- 8 ************************************** purchase.Invoice

CREATE TABLE IF NOT EXISTS Invoice
(
 id          bigint PRIMARY KEY AUTO_INCREMENT,
 NameInvoice varchar(250) NOT NULL,
 DataCreate  date NOT NULL,
 Payment     decimal(20, 6) NOT NULL DEFAULT 0,
 LastUpdate  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 
 UNIQUE INDEX IdxNameInvoice ( NameInvoice )
);

-- 9 ************************************** purchase.CommercialOfferGoods

CREATE TABLE IF NOT EXISTS CommercialOfferGoods
(
 id                  bigint PRIMARY KEY AUTO_INCREMENT,
 GoodsManufacture_id bigint NOT NULL,
 QuantityPurchase    decimal(20, 6) NOT NULL,
 PricePurchase       decimal(20, 6) NOT NULL,
 Currency            varchar(250) NOT NULL,
 PriceSale           decimal(20, 6) NOT NULL,
 DeliveryTime        int NOT NULL,
 MinQuota            boolean NOT NULL,
 Manufacture_id      int NOT NULL,
 Supplier_id         int NOT NULL,
 Manager_id          int NOT NULL,
 Description         text,
 Invoice_id          bigint NOT NULL DEFAULT 1,
 OrderSailor         varchar(250) NOT NULL DEFAULT '',
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_193 FOREIGN KEY ( GoodsManufacture_id ) REFERENCES Goods ( id ),
 CONSTRAINT FK_196 FOREIGN KEY ( Manufacture_id ) REFERENCES Organization ( id ),
 CONSTRAINT FK_199 FOREIGN KEY ( Supplier_id ) REFERENCES Organization ( id ),
 CONSTRAINT FK_202 FOREIGN KEY ( Manager_id ) REFERENCES People ( id ),
 CONSTRAINT FK_245 FOREIGN KEY ( Invoice_id ) REFERENCES Invoice ( id ),
 CONSTRAINT Check_Price CHECK ( PricePurchase >= 0 ),
 
 INDEX fkIdx_co_goods ( GoodsManufacture_id )
);

-- 10 ************************************** prepare.CommercialOfferAssembly

CREATE TABLE IF NOT EXISTS CommercialOfferAssembly
(
 id              bigint PRIMARY KEY AUTO_INCREMENT,
 Contractor_id   int NOT NULL,
 TypeAssembly_id int NOT NULL,
 OrderSp_id      bigint NOT NULL,
 price           decimal(20, 6) NOT NULL,
 LeadTime        int NOT NULL,
 ForOffer        boolean NULL,
 ForPurchase     boolean NULL,
 Invoice_id      bigint NULL,
 LastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_156 FOREIGN KEY ( Contractor_id ) REFERENCES Organization ( id ),
 CONSTRAINT FK_159 FOREIGN KEY ( TypeAssembly_id ) REFERENCES TypeAssembly ( id ),
 CONSTRAINT FK_165 FOREIGN KEY ( OrderSp_id ) REFERENCES OrderSpecification ( id ),
 CONSTRAINT FK_242 FOREIGN KEY ( Invoice_id ) REFERENCES Invoice ( id )
);

-- 11 ************************************** purchase.DeliveryRelation

CREATE TABLE IF NOT EXISTS DeliveryRelation
(
 id                bigint PRIMARY KEY AUTO_INCREMENT,
 CommOfferGoods_id bigint NOT NULL,
 Quantity          decimal(20, 6) NOT NULL,
 NameDelivery      varchar(250) NOT NULL,
 DateShipment      date NOT NULL,
 DateDelivery      date NOT NULL,
 Destination       varchar(250) NOT NULL,
 LastUpdate        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_254 FOREIGN KEY ( CommOfferGoods_id ) REFERENCES CommercialOfferGoods ( id )
)
COMMENT = 'В таблице содержится перечень товаров, которые отправил поставщик (можно частично)';

-- 12 ************************************** store.Stock

CREATE TABLE IF NOT EXISTS Stock
(
 id                  bigint PRIMARY KEY AUTO_INCREMENT,
 DeliveryRelation_Id bigint NOT NULL,
 Quantity            decimal(20, 6) NOT NULL,
 DateRevise          date NOT NULL,
 WarehouseWorker_Id  int NOT NULL,
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_266 FOREIGN KEY ( DeliveryRelation_id ) REFERENCES DeliveryRelation ( id ),
 CONSTRAINT FK_271 FOREIGN KEY ( WarehouseWorker_id ) REFERENCES People ( id )
)
COMMENT = 'Таблица склада содержит данные поступления товаров с определенной поставки, количество может быть (ошибочно) меньше чем отправляли.';

-- 13 ************************************** store.StockSet

CREATE TABLE IF NOT EXISTS StockSet
(
 id                  bigint PRIMARY KEY AUTO_INCREMENT,
 Stock_Id            bigint NOT NULL,
 QuantitySet         decimal(20, 6) NOT NULL,
 DateSet             date NOT NULL,
 WarehouseWorker_Id  int NOT NULL,
 DateShipment        date DEFAULT '0001-01-01',
 Assembly_id         bigint NOT NULL DEFAULT 1,
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_286 FOREIGN KEY ( Stock_Id ) REFERENCES Stock ( id ),
 CONSTRAINT FK_293 FOREIGN KEY ( WarehouseWorker_Id ) REFERENCES People ( id ),
 CONSTRAINT FK_300 FOREIGN KEY ( Assembly_Id ) REFERENCES OrderSpecification ( id )
);

-- 14 ************************************** management.CommercialOfferOrder

CREATE TABLE IF NOT EXISTS CommercialOfferOrder
(
 id                      bigint PRIMARY KEY AUTO_INCREMENT,
 OrderSp_id              bigint NOT NULL,
 GoodsCustomer_id        bigint NOT NULL,
 QuantitySpecification   decimal(20, 6) NOT NULL,
 unit                    varchar(250) NOT NULL,
 ComOfferGoods_id		 bigint NOT NULL DEFAULT 1,
 NameApproval            boolean NULL DEFAULT false,
 DetailApproval          text NULL,
 Purchase                boolean NULL DEFAULT false,
 DatePurchase            date NULL DEFAULT '0001-01-01',
 ManagerPurchase_id      int NULL DEFAULT 1,
 StockSet_id             bigint NULL DEFAULT 1,
 DateShipmentOrder       date NULL DEFAULT '0001-01-01',
 LastUpdate              timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_134 FOREIGN KEY ( ManagerPurchase_id ) REFERENCES Organization ( id ),
 CONSTRAINT FK_501 FOREIGN KEY ( ComOfferGoods_id ) REFERENCES CommercialOfferGoods ( id ),
 CONSTRAINT FK_296 FOREIGN KEY ( StockSet_id ) REFERENCES StockSet ( id ),
 CONSTRAINT FK_84 FOREIGN KEY ( GoodsCustomer_id ) REFERENCES Goods ( id ),
 CONSTRAINT FK_90 FOREIGN KEY ( OrderSp_id ) REFERENCES OrderSpecification ( id )
);

-- 15 ************************************** store.TableSupplyModule

CREATE TABLE IF NOT EXISTS TableSupplyModule
(
 id                bigint PRIMARY KEY AUTO_INCREMENT,
 OrderSp_id        bigint NOT NULL,
 DateShipment      date NULL DEFAULT '0001-01-01',
 DateOfCompletion  date NULL DEFAULT '0001-01-01',
 Assembly_id       bigint NOT NULL,
 Quantity          decimal(20, 6) NOT NULL,
 Description       text NULL,
 DateShipmentOrder date NULL DEFAULT '0001-01-01',
 LastUpdate        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_307 FOREIGN KEY ( OrderSp_id ) REFERENCES OrderSpecification ( id ),
 CONSTRAINT FK_312 FOREIGN KEY ( Assembly_id ) REFERENCES CommercialOfferAssembly ( id )
);

-- 16 ************************************** prepare.ModuleSpecification

CREATE TABLE IF NOT EXISTS ModuleSpecification
(
 id                  bigint PRIMARY KEY AUTO_INCREMENT,
 Goods_Id            bigint NOT NULL,
 Module_Id           int NOT NULL,
 Quantity            decimal(20, 6) NOT NULL,
 unit                varchar(250) NOT NULL,
 NumberCustomer      int NOT NULL DEFAULT 0,
 NumberSpecification int NOT NULL DEFAULT 0,
 Position            text,
 Note                text,
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_41 FOREIGN KEY ( Goods_Id ) REFERENCES Goods ( id ),
 CONSTRAINT FK_76 FOREIGN KEY ( Module_Id ) REFERENCES Module ( id )
);

-- 17 ************************************** purchase.PurchaseRelation

-- CREATE TABLE IF NOT EXISTS PurchaseRelation
-- (
--  id                bigint PRIMARY KEY AUTO_INCREMENT,
--  CommOfferOrder_id bigint NOT NULL,
--  CommOfferGoods_id bigint NOT NULL,
--  LastUpdate        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

--  CONSTRAINT FK_239 FOREIGN KEY ( CommOfferOrder_id ) REFERENCES CommercialOfferOrder ( id ),
--  CONSTRAINT FK_248 FOREIGN KEY ( CommOfferGoods_id ) REFERENCES CommercialOfferGoods ( id )
-- );

-- INSERT **************************************

INSERT INTO Organization(
	nameorganization, location, typeorganization)
	VALUES ('', '', ''),
  ('РНИИРС', 'г. Ростов-на-Дону', 'заказчик'),
  ('Алмаз-СП', 'г. Москва', 'исполнитель'),
  ('Avnet', 'Europe', 'производитель');

INSERT INTO People(
	firstname, lastname, patronymic, ofBirth, attributes, department, position, organization_id)
	VALUES
      ('', '', '', '1900-01-01', '{}', '', '', 1),
      ('Василий', 'Лозовой', 'Николаевич', '1982-04-08', '{"tel_mobile": "+7(918)5255518",
			"tel_work": "+7(863)2555253", "e_mail": "tatian@yandex.ru"}', 'отдел НКО', 'Начальник', 2),
      ('Роман', 'Воробьев', 'Николаевич', '1978-06-22', '{"tel_mobile": "+7(916)6666668",
			"tel_work": "+7(495)2216921", "e_mail": "romakf99@yandex.ru"}', 'Pcb', 'Начальник', 3),
      ('Alex', '', '', '1986-05-09', '{"e_mail": "alex@gmail.com"}', 'sales', 'manager', 4);

INSERT INTO Orders(
	nameorder, datacreate, customer_id, deliveryaddress)
	VALUES
		('', now(), 1, ''),
		('1 order', now(), 2, 'Ростов-на-Дону');

INSERT INTO TypeAssembly (nameassembly)
    VALUES (''), ('SMT'), ('DIP'), ('Сборка');
    
INSERT INTO Module(
	namemodule, constructor_id)
	VALUES
	('468181.666', 2),
	('468352.070', 2),
	('468716.001', 2),
	('468214.100', 2),
	('436637.043', 2);

INSERT INTO `orderManSys`.`Goods` (`NameGoods`, `Pins`, `TypeAssembly_id`) 
	VALUES ('\'\'', 0, '1');
    
INSERT INTO Invoice(
	nameinvoice, datacreate)
	VALUES 
    ('','0001-01-01'),
    ('Av001', '2020-05-06');

INSERT INTO `orderManSys`.`CommercialOfferGoods` 
	(`GoodsManufacture_id`, `QuantityPurchase`, `PricePurchase`, `Currency`, `PriceSale`, `DeliveryTime`, `MinQuota`, `Manufacture_id`, `Supplier_id`, `Manager_id`, `Description`)
    VALUES ('1', '0', '0', '\'\'', '0', '0', '0', '1', '1', '1', '\'\'');

INSERT INTO `orderManSys`.`DeliveryRelation` 
	(`CommOfferGoods_id`, `Quantity`, `NameDelivery`, `DateShipment`, `DateDelivery`, `Destination`) 
    VALUES ('1', '0', '\'\'', '0001-01-01', '0001-01-01', '\'\'');

INSERT INTO `orderManSys`.`Stock` 
	(`DeliveryRelation_Id`, `Quantity`, `DateRevise`, `WarehouseWorker_Id`) 
    VALUES ('1', '0', '2022-03-15', '1');

INSERT INTO OrderSpecification(
	Order_id, Module_id, Quantity, Assembly)
	VALUES
    (1, 1, 0, 0),
    (2, 1, 12, 1),
    (2, 2, 5, 1),
    (2, 3, 23, 1);
    
INSERT INTO `orderManSys`.`StockSet` 
	(`Stock_Id`, `QuantitySet`, `DateSet`, `WarehouseWorker_Id`, `DateShipment`, `Assembly_id`) VALUES 
    ('1', '0', '0001-01-01', '1', '0001-01-01', '1');

SET GLOBAL local_infile=1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW GLOBAL VARIABLES LIKE 'secure_file_priv';

SELECT @@GLOBAL.secure_file_priv;

LOAD DATA INFILE '/var/lib/mysql-files/data_for_copy/copy_goods.csv'
	INTO TABLE `orderManSys`.`Goods`
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\n'
    (NameGoods, Pins, TypeAssembly_id, Description);

LOAD DATA INFILE '/var/lib/mysql-files/data_for_copy/copy_module_spec.csv'
	INTO TABLE `orderManSys`.`ModuleSpecification`
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\n'
    (Goods_Id, Module_Id, Quantity, unit, NumberCustomer);
    
LOAD DATA INFILE '/var/lib/mysql-files/data_for_copy/commercial_offer_goods.csv'
	INTO TABLE `orderManSys`.`CommercialOfferGoods`
    FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    (GoodsManufacture_id,QuantityPurchase,PricePurchase,
	 Currency,PriceSale,DeliveryTime,MinQuota,Manufacture_id,
     Supplier_id,Manager_id,Invoice_id);
    