DROP DATABASE IF EXISTS orderManSys;

CREATE DATABASE IF NOT EXISTS orderManSys;
USE orderManSys;

-- 1 ************************************** Organization

CREATE TABLE IF NOT EXISTS Organization
(
 id             int PRIMARY KEY AUTO_INCREMENT,
 NameOrganization varchar(250) UNIQUE NOT NULL DEFAULT '',
 Location         varchar(250) NOT NULL DEFAULT '',
 TypeOrganization varchar(250) NOT NULL DEFAULT '',
 LastUpdate       timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2 ************************************** public.People

CREATE TABLE IF NOT EXISTS People
(
 id              int PRIMARY KEY AUTO_INCREMENT,
 firstName       varchar(250) NOT NULL DEFAULT '',
 lastName        varchar(250) NOT NULL DEFAULT '',
 patronymic      varchar(250) NOT NULL DEFAULT '',
 age             int NOT NULL DEFAULT 0,
 tel_mobile      varchar(250) NOT NULL DEFAULT '',
 tel_work        varchar(250) NOT NULL DEFAULT '',
 e_mail          varchar(250) NOT NULL DEFAULT '',
 departament     varchar(250) NOT NULL DEFAULT '',
 position        varchar(250) NOT NULL DEFAULT '',
 chief_id        int NOT NULL DEFAULT 1,
 organization_id int NOT NULL DEFAULT 1,
 lastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_117 FOREIGN KEY ( chief_id ) REFERENCES People ( id ),
 CONSTRAINT FK_131 FOREIGN KEY ( organization_id ) REFERENCES Organization ( id ),
 CONSTRAINT check_Age CHECK ( age >=0 AND age < 100 ),
 CONSTRAINT unique_fullname UNIQUE (firstName, lastName, patronymic)
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
 CONSTRAINT unique_order UNIQUE (NameOrder)
)
COMMENT = 'Таблица содержащая заказы';

-- 4 ************************************** prepare.TypeAssembly

CREATE TABLE IF NOT EXISTS TypeAssembly
(
 id           int PRIMARY KEY AUTO_INCREMENT,
 NameAssembly varchar(250) NOT NULL,
 LastUpdate   timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT unique_assembly UNIQUE (NameAssembly)
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
 CONSTRAINT unique_Module UNIQUE (NameModule)
);

-- 6 ************************************** prepare.Goods

CREATE TABLE IF NOT EXISTS Goods
(
 id              bigint PRIMARY KEY AUTO_INCREMENT,
 NameGoods       varchar(250) NOT NULL,
 Pins            int NOT NULL,
 TypeAssembly_id int NOT NULL,
 Description     varchar(250) NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_34 FOREIGN KEY ( TypeAssembly_id ) REFERENCES TypeAssembly ( id ),
 CONSTRAINT unique_Goods UNIQUE (NameGoods)
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
 CONSTRAINT FK_93 FOREIGN KEY ( Module_id ) REFERENCES Module ( id )
);

-- 8 ************************************** purchase.Invoice

CREATE TABLE IF NOT EXISTS Invoice
(
 id          bigint PRIMARY KEY AUTO_INCREMENT,
 NameInvoice varchar(250) NOT NULL,
 DataCreate  date NOT NULL,
 Payment     decimal(20, 6) NOT NULL DEFAULT 0,
 LastUpdate  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT unique_Invoice UNIQUE (NameInvoice)
);

-- 9 ************************************** purchase.CommercialOfferGoods

CREATE TABLE IF NOT EXISTS CommercialOfferGoods
(
 id                  bigint PRIMARY KEY AUTO_INCREMENT,
 GoodsManufaction_id bigint NOT NULL,
 QuantityPurchase    decimal(20, 6) NOT NULL,
 PricePurchase       decimal(20, 6) NOT NULL,
 Currency            varchar(250) NOT NULL,
 PriceSale           decimal(20, 6) NOT NULL,
 DeliveryTime        int NOT NULL,
 MinQuota            boolean NOT NULL,
 Manufaction_id      int NOT NULL,
 Supplier_id         int NOT NULL,
 Manager_id          int NOT NULL,
 Description         text,
 Invoice_id          bigint NOT NULL,
 OrderSalor          varchar(250) NOT NULL DEFAULT '',
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_193 FOREIGN KEY ( GoodsManufaction_id ) REFERENCES Goods ( id ),
 CONSTRAINT FK_196 FOREIGN KEY ( Manufaction_id ) REFERENCES Organization ( id ),
 CONSTRAINT FK_199 FOREIGN KEY ( Supplier_id ) REFERENCES Organization ( id ),
 CONSTRAINT FK_202 FOREIGN KEY ( Manager_id ) REFERENCES People ( id ),
 CONSTRAINT FK_245 FOREIGN KEY ( Invoice_id ) REFERENCES Invoice ( id ),
 CONSTRAINT Check_Price CHECK ( PricePurchase >= 0 )
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
 WarehouseWoorker_Id int NOT NULL,
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_266 FOREIGN KEY ( DeliveryRelation_id ) REFERENCES DeliveryRelation ( id ),
 CONSTRAINT FK_271 FOREIGN KEY ( WarehouseWoorker_id ) REFERENCES People ( id )
)
COMMENT = 'Таблица склада содержит данные поступления товаров с определенной поставки, количество может быть (ошибочно) меньше чем отправляли.';

-- 13 ************************************** store.StockSet

CREATE TABLE IF NOT EXISTS StockSet
(
 id                  bigint PRIMARY KEY AUTO_INCREMENT,
 Stock_Id            bigint NOT NULL,
 QuantitySet         decimal(20, 6) NOT NULL,
 DateSet             date NOT NULL,
 WarehouseWoorker_Id int NOT NULL,
 DateShipment        date DEFAULT '0001-01-01',
 Assembly_id         bigint DEFAULT 0,
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_286 FOREIGN KEY ( Stock_Id ) REFERENCES Stock ( id ),
 CONSTRAINT FK_293 FOREIGN KEY ( WarehouseWoorker_Id ) REFERENCES People ( id ),
 CONSTRAINT FK_300 FOREIGN KEY ( Assembly_Id ) REFERENCES CommercialOfferAssembly ( id )
);

-- 14 ************************************** management.CommercialOfferOrder

CREATE TABLE IF NOT EXISTS CommercialOfferOrder
(
 id                      bigint PRIMARY KEY AUTO_INCREMENT,
 OrderSp_id              bigint NOT NULL,
 GoodsCustomer_id        bigint NOT NULL,
 QuantitySpecification   decimal(20, 6) NOT NULL,
 unit                    varchar(250) NOT NULL,
 NameApproval            boolean NULL DEFAULT false,
 DetailApproval          text NULL,
 Purchase                boolean NULL DEFAULT false,
 DatePurchase            date NULL DEFAULT '0001-01-01',
 ManagerPurchase_id      int NULL DEFAULT 0,
 StockSet_id             bigint NULL DEFAULT 0,
 DateShipmentOrder       date NULL DEFAULT '0001-01-01',
 LastUpdate              timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_134 FOREIGN KEY ( ManagerPurchase_id ) REFERENCES Organization ( id ),
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
 Descryption       text NULL,
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
 NumberCustomer      int NOT NULL,
 NumberSpecification int NULL DEFAULT 0,
 Position            text NULL,
 Note                text NULL,
 LastUpdate          timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_41 FOREIGN KEY ( Goods_Id ) REFERENCES Goods ( id ),
 CONSTRAINT FK_76 FOREIGN KEY ( Module_Id ) REFERENCES Module ( id )
);

-- 17 ************************************** purchase.PurchaseRelation

CREATE TABLE IF NOT EXISTS PurchaseRelation
(
 id                bigint PRIMARY KEY AUTO_INCREMENT,
 CommOfferOrder_id bigint NOT NULL,
 CommOfferGoods_id bigint NOT NULL,
 LastUpdate        timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

 CONSTRAINT FK_239 FOREIGN KEY ( CommOfferOrder_id ) REFERENCES CommercialOfferOrder ( id ),
 CONSTRAINT FK_248 FOREIGN KEY ( CommOfferGoods_id ) REFERENCES CommercialOfferGoods ( id )
);

-- INSERT **************************************

INSERT INTO Organization(
	nameorganization, location, typeorganization)
	VALUES ('', '', ''),
  ('РНИИРС', 'г. Ростов-на-Дону', 'заказчик'),
  ('Алмаз-СП', 'г. Москва', 'исполнитель'),
  ('Avnet', 'Europe', 'производитель');

INSERT INTO People(
	firstname, lastname, patronymic, age, tel_mobile,
	tel_work, e_mail, departament, position, organization_id)
	VALUES
      ('Василий', 'Лозовой', 'Николаевич', 35, '+7(918)5255518',
			'+7(863)2555253','tatian@yandex.ru', 'отдел НКО', 'Начальник', 2),
      ('Роман', 'Воробьев', 'Николаевич', 43, '+7(916)6666668',
			'+7(495)2216921','romakf99@yandex.ru', 'Pcb', 'Начальник', 3),
      ('Alex', '', '', 36, '',
			'','alex@gmail.com', 'sales', 'manager', 4);

INSERT INTO Orders(
	nameorder, datacreate, customer_id, deliveryaddress)
	VALUES ('1 order', now(), 2, 'Ростов-на-Дону');
