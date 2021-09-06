-- 1 ************************************** public.Organization

CREATE TABLE IF NOT EXISTS public.Organization
(
 id             int NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 NameOrganization varchar(250) NOT NULL,
 Location         varchar(250) NOT NULL,
 TypeOrganization varchar(250) NOT NULL,
 LastUpdate       timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_organization PRIMARY KEY ( id ),
 CONSTRAINT unique_organization UNIQUE (NameOrganization)
);

-- 2 ************************************** public.People

CREATE TABLE IF NOT EXISTS public.People
(
 id              int NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 FirstName       varchar(250) NOT NULL,
 LastName        varchar(250) NOT NULL,
 Patronymic      varchar(250) NOT NULL,
 Age             int NOT NULL DEFAULT 0,
 Tel_mobile      varchar(250) NOT NULL,
 Tel_work        varchar(250) NOT NULL,
 "e-mail"          varchar(250) NOT NULL,
 Departament     varchar(250) NOT NULL,
 Position        varchar(250) NOT NULL,
 Chief_id        int NULL,
 Organization_id int NOT NULL DEFAULT 0,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_people PRIMARY KEY ( id ),
 CONSTRAINT FK_117 FOREIGN KEY ( Chief_id ) REFERENCES "public".People ( id ),
 CONSTRAINT FK_131 FOREIGN KEY ( Organization_id ) REFERENCES "public".Organization ( id ),
 CONSTRAINT check_Age CHECK ( Age >=0 AND Age < 100 ),
 CONSTRAINT unique_fullname UNIQUE (FirstName, LastName, Patronymic)
);

CREATE INDEX fkIdx_118 ON "public".People ( Chief_id );
CREATE INDEX fkIdx_132 ON "public".People ( Organization_id );
CREATE INDEX Name ON "public".People USING btree
(
 FirstName,
 LastName,
 Patronymic
);

COMMENT ON TABLE "public".People IS 'Таблица содержащая данные Людей участвующих в процессе';

-- 3 ************************************** management.Order

CREATE TABLE IF NOT EXISTS management.Order
(
 id             bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 NameOrder       varchar(250) NOT NULL,
 DataCreate      date NOT NULL,
 Customer_id     int NOT NULL,
 DeliveryAddress text NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_order PRIMARY KEY ( id ),
 CONSTRAINT FK_21 FOREIGN KEY ( Customer_id ) REFERENCES "public".People ( id ),
 CONSTRAINT unique_order UNIQUE (NameOrder)
);

CREATE INDEX fkIdx_22 ON management.Order ( Customer_id );
CREATE INDEX NameOrder ON management.Order ( NameOrder );

-- 4 ************************************** prepare.TypeAssembly

CREATE TABLE IF NOT EXISTS prepare.TypeAssembly
(
 id           int NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 NameAssembly varchar(250) NOT NULL,
 LastUpdate   timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_typeassemble PRIMARY KEY ( id ),
 CONSTRAINT unique_assembly UNIQUE (NameAssembly)
);

-- 5 ************************************** prepare.Module

CREATE TABLE IF NOT EXISTS prepare.Module
(
 id             int NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 NameModule     varchar(250) NOT NULL,
 Constructor_id int NOT NULL,
 Description    text COLLATE pg_catalog."default",
 LastUpdate     timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_module PRIMARY KEY ( id ),
 CONSTRAINT FK_72 FOREIGN KEY ( Constructor_id ) REFERENCES "public".People ( id ),
 CONSTRAINT unique_Module UNIQUE (NameModule)
);

CREATE INDEX fkIdx_73 ON prepare.Module ( Constructor_id );

-- 6 ************************************** prepare.Goods

CREATE TABLE IF NOT EXISTS prepare.Goods
(
 id              bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 NameGoods       varchar(250) NOT NULL,
 Pins            int NOT NULL,
 TypeAssembly_id int NOT NULL,
 Description     varchar(250) NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_goods PRIMARY KEY ( id ),
 CONSTRAINT FK_34 FOREIGN KEY ( TypeAssembly_id ) REFERENCES prepare.TypeAssembly ( id ),
 CONSTRAINT unique_Goods UNIQUE (NameGoods)
);

CREATE UNIQUE INDEX NameGoods ON prepare.Goods ( NameGoods ) INCLUDE ( NameGoods );
CREATE INDEX fkIdx_35 ON prepare.Goods ( TypeAssembly_id );

-- 7 ************************************** management.OrderSpecification

CREATE TABLE IF NOT EXISTS management.OrderSpecification
(
 id        bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 Order_id  bigint NOT NULL,
 Module_id int NOT NULL,
 Quantity  int NOT NULL,
 Assembly  boolean NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_orderspecification PRIMARY KEY ( id ),
 CONSTRAINT FK_52 FOREIGN KEY ( Order_id ) REFERENCES management.Order ( id ),
 CONSTRAINT FK_93 FOREIGN KEY ( Module_id ) REFERENCES prepare.Module ( id )
);

CREATE INDEX fkIdx_53 ON management.OrderSpecification ( Order_id );
CREATE INDEX fkIdx_94 ON management.OrderSpecification ( Module_id );

-- 8 ************************************** purchase.Invoice

CREATE TABLE IF NOT EXISTS purchase.Invoice
(
 id          bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 NameInvoice varchar(250) NOT NULL,
 DataCreate  date NOT NULL,
 Payment     decimal(20, 6) NOT NULL DEFAULT 0,
 LastUpdate  timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_invoice PRIMARY KEY ( id ),
 CONSTRAINT unique_Invoice UNIQUE (NameInvoice)
);

-- 9 ************************************** purchase.CommercialOfferGoods

CREATE TABLE IF NOT EXISTS purchase.CommercialOfferGoods
(
 id                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
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
 Description         text COLLATE pg_catalog."default",
 Invoice_id          bigint NOT NULL,
 OrderSalor          varchar(250) NOT NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_commercialoffergoods PRIMARY KEY ( id ),
 CONSTRAINT FK_193 FOREIGN KEY ( GoodsManufaction_id ) REFERENCES prepare.Goods ( id ),
 CONSTRAINT FK_196 FOREIGN KEY ( Manufaction_id ) REFERENCES "public".Organization ( id ),
 CONSTRAINT FK_199 FOREIGN KEY ( Supplier_id ) REFERENCES "public".Organization ( id ),
 CONSTRAINT FK_202 FOREIGN KEY ( Manager_id ) REFERENCES "public".People ( id ),
 CONSTRAINT FK_245 FOREIGN KEY ( Invoice_id ) REFERENCES purchase.Invoice ( id ),
 CONSTRAINT Check_Price CHECK ( PricePurchase >= 0 )
);

CREATE INDEX fkIdx_194 ON purchase.CommercialOfferGoods ( GoodsManufaction_id );
CREATE INDEX fkIdx_197 ON purchase.CommercialOfferGoods ( Manufaction_id );
CREATE INDEX fkIdx_200 ON purchase.CommercialOfferGoods ( Supplier_id );
CREATE INDEX fkIdx_203 ON purchase.CommercialOfferGoods ( Manager_id );
CREATE INDEX fkIdx_246 ON purchase.CommercialOfferGoods ( Invoice_id );

-- 10 ************************************** prepare.CommercialOfferAssembly

CREATE TABLE IF NOT EXISTS prepare.CommercialOfferAssembly
(
 id              bigint NOT NULL,
 Contractor_id   int NOT NULL,
 TypeAssembly_id int NOT NULL,
 OrderSp_id      bigint NOT NULL,
 price           decimal(20, 6) NOT NULL,
 LeadTime        int NOT NULL,
 ForOffer        boolean NULL,
 ForPurchase     boolean NULL,
 Invoice_id      bigint NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_coomercialofferassembly PRIMARY KEY ( id ),
 CONSTRAINT FK_156 FOREIGN KEY ( Contractor_id ) REFERENCES "public".Organization ( id ),
 CONSTRAINT FK_159 FOREIGN KEY ( TypeAssembly_id ) REFERENCES prepare.TypeAssembly ( id ),
 CONSTRAINT FK_165 FOREIGN KEY ( OrderSp_id ) REFERENCES management.OrderSpecification ( id ),
 CONSTRAINT FK_242 FOREIGN KEY ( Invoice_id ) REFERENCES purchase.Invoice ( id )
);

CREATE INDEX fkIdx_157 ON prepare.CommercialOfferAssembly ( Contractor_id );
CREATE INDEX fkIdx_160 ON prepare.CommercialOfferAssembly ( TypeAssembly_id );
CREATE INDEX fkIdx_166 ON prepare.CommercialOfferAssembly ( OrderSp_id );
CREATE INDEX fkIdx_243 ON prepare.CommercialOfferAssembly ( Invoice_id );

-- 11 ************************************** purchase.DeliveryRelation

CREATE TABLE IF NOT EXISTS purchase.DeliveryRelation
(
 id                bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 CommOfferGoods_id bigint NOT NULL,
 Quantity          decimal(20, 6) NOT NULL,
 NameDelivery      varchar(250) NOT NULL,
 DateShipment      date NOT NULL,
 DateDelivery      date NOT NULL,
 Destination       varchar(250) NOT NULL,
 LastUpdate        timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_deliveryrelation PRIMARY KEY ( id ),
 CONSTRAINT FK_254 FOREIGN KEY ( CommOfferGoods_id ) REFERENCES purchase.CommercialOfferGoods ( id )
);

CREATE INDEX fkIdx_255 ON purchase.DeliveryRelation ( CommOfferGoods_id );

COMMENT ON TABLE purchase.DeliveryRelation IS 'В таблице содержится перечень товаров, которые отправил поставщик (можно частично)';

-- 12 ************************************** store.Stock

CREATE TABLE IF NOT EXISTS store.Stock
(
 id                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 DeliveryRelation_Id bigint NOT NULL,
 Quantity            decimal(20, 6) NOT NULL,
 DateRevise          date NOT NULL,
 WarehouseWoorker_Id int NOT NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_stock PRIMARY KEY ( id ),
 CONSTRAINT FK_266 FOREIGN KEY ( DeliveryRelation_id ) REFERENCES purchase.DeliveryRelation ( id ),
 CONSTRAINT FK_271 FOREIGN KEY ( WarehouseWoorker_id ) REFERENCES "public".People ( id )
);

CREATE INDEX fkIdx_267 ON store.Stock ( DeliveryRelation_id );
CREATE INDEX fkIdx_272 ON store.Stock ( WarehouseWoorker_id );

COMMENT ON TABLE store.Stock IS 'Таблица склада содержит данные поступления товаров с определенной поставки, количество может быть (ошибочно) меньше чем отправляли.';

-- 13 ************************************** store.StockSet

CREATE TABLE IF NOT EXISTS store.StockSet
(
 id                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 Stock_Id            bigint NOT NULL,
 QuantitySet         decimal(20, 6) NOT NULL,
 DateSet             date NOT NULL,
 WarehouseWoorker_Id int NOT NULL,
 DateShipment        date DEFAULT '0001-01-01',
 Assembly_id         bigint DEFAULT 0,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_stockset PRIMARY KEY ( id ),
 CONSTRAINT FK_286 FOREIGN KEY ( Stock_Id ) REFERENCES store.Stock ( id ),
 CONSTRAINT FK_293 FOREIGN KEY ( WarehouseWoorker_Id ) REFERENCES "public".People ( id ),
 CONSTRAINT FK_300 FOREIGN KEY ( Assembly_Id ) REFERENCES prepare.CommercialOfferAssembly ( id )
);

CREATE INDEX fkIdx_287 ON store.StockSet ( Stock_id );
CREATE INDEX fkIdx_294 ON store.StockSet ( WarehouseWoorker_id );
CREATE INDEX fkIdx_301 ON store.StockSet ( Assembly_id );

-- 14 ************************************** management.CommercialOfferOrder

CREATE TABLE IF NOT EXISTS management.CommercialOfferOrder
(
 id                      bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
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
 LastUpdate              timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_commercialoffer PRIMARY KEY ( id ),
 CONSTRAINT FK_134 FOREIGN KEY ( ManagerPurchase_id ) REFERENCES "public".Organization ( id ),
 CONSTRAINT FK_296 FOREIGN KEY ( StockSet_id ) REFERENCES store.StockSet ( id ),
 CONSTRAINT FK_84 FOREIGN KEY ( GoodsCustomer_id ) REFERENCES prepare.Goods ( id ),
 CONSTRAINT FK_90 FOREIGN KEY ( OrderSp_id ) REFERENCES management.OrderSpecification ( id )
);

CREATE INDEX fkIdx_135 ON management.CommercialOfferOrder ( ManagerPurchase_id );
CREATE INDEX fkIdx_297 ON management.CommercialOfferOrder ( StockSet_id );
CREATE INDEX fkIdx_85 ON management.CommercialOfferOrder ( GoodsCustomer_id );
CREATE INDEX fkIdx_91 ON management.CommercialOfferOrder ( OrderSp_id );

-- 15 ************************************** store.TableSupplyModule

CREATE TABLE IF NOT EXISTS store.TableSupplyModule
(
 id                bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 OrderSp_id        bigint NOT NULL,
 DateShipment      date NULL DEFAULT '0001-01-01',
 DateOfCompletion  date NULL DEFAULT '0001-01-01',
 Assembly_id       bigint NOT NULL,
 Quantity          decimal(20, 6) NOT NULL,
 Descryption       text NULL,
 DateShipmentOrder date NULL DEFAULT '0001-01-01',
 LastUpdate        timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_tablesupplaymodule PRIMARY KEY ( id ),
 CONSTRAINT FK_307 FOREIGN KEY ( OrderSp_id ) REFERENCES management.OrderSpecification ( id ),
 CONSTRAINT FK_312 FOREIGN KEY ( Assembly_id ) REFERENCES prepare.CommercialOfferAssembly ( id )
);

CREATE INDEX fkIdx_308 ON store.TableSupplyModule ( OrderSp_id );
CREATE INDEX fkIdx_313 ON store.TableSupplyModule ( Assembly_id );

-- 16 ************************************** prepare.ModuleSpecification

CREATE TABLE IF NOT EXISTS prepare.ModuleSpecification
(
 id                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 Goods_Id            bigint NOT NULL,
 Module_Id           int NOT NULL,
 Quantity            decimal(20, 6) NOT NULL,
 unit                varchar(250) NOT NULL,
 NumberCustomer      int NOT NULL,
 NumberSpecification int NULL DEFAULT 0,
 Position            text NULL,
 Note                text NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_modulespecification PRIMARY KEY ( id ),
 CONSTRAINT FK_41 FOREIGN KEY ( Goods_Id ) REFERENCES prepare.Goods ( id ),
 CONSTRAINT FK_76 FOREIGN KEY ( Module_Id ) REFERENCES prepare.Module ( id )
);

CREATE INDEX fkIdx_42 ON prepare.ModuleSpecification ( Goods_id );
CREATE INDEX fkIdx_77 ON prepare.ModuleSpecification ( Module_id );

-- 17 ************************************** purchase.PurchaseRelation

CREATE TABLE IF NOT EXISTS purchase.PurchaseRelation
(
 id                bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
  minvalue 1
  start 1
 ),
 CommOfferOrder_id bigint NOT NULL,
 CommOfferGoods_id bigint NOT NULL,
 LastUpdate        timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_purchase PRIMARY KEY ( id ),
 CONSTRAINT FK_239 FOREIGN KEY ( CommOfferOrder_id ) REFERENCES management.CommercialOfferOrder ( id ),
 CONSTRAINT FK_248 FOREIGN KEY ( CommOfferGoods_id ) REFERENCES purchase.CommercialOfferGoods ( id )
);

CREATE INDEX fkIdx_240 ON purchase.PurchaseRelation ( CommOfferOrder_id );
CREATE INDEX fkIdx_249 ON purchase.PurchaseRelation ( CommOfferGoods_id );
