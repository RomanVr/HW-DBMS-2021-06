-- 1 ************************************** "public".Organization

CREATE TABLE IF NOT EXISTS "public".Organization
(
 "Id"             int NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 NameOrganization varchar(100) NOT NULL,
 Location         varchar(100) NOT NULL,
 TypeOrganization varchar(50) NOT NULL,
 LastUpdate       timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_organization PRIMARY KEY ( "Id" ),
 CONSTRAINT unique_organization UNIQUE (NameOrganization)
);

-- 2 ************************************** "public".People

CREATE TABLE IF NOT EXISTS "public".People
(
 "Id"              int NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 FirstName       varchar(50) NOT NULL,
 LastName        varchar(50) NOT NULL,
 Patronymic      varchar(50) NOT NULL,
 Age             int NULL,
 Tel_mobile      varchar(50) NOT NULL,
 Tel_work        varchar(50) NOT NULL,
 "e-mail"        varchar(50) NOT NULL,
 Departament     varchar(50) NOT NULL,
 "Position"      varchar(50) NOT NULL,
 Chief_Id        int NULL,
 Organization_Id int NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_people PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_117 FOREIGN KEY ( Chief_Id ) REFERENCES "public".People ( "Id" ),
 CONSTRAINT FK_131 FOREIGN KEY ( Organization_Id ) REFERENCES "public".Organization ( "Id" ),
 CONSTRAINT check_Age CHECK ( Age >0 AND Age < 100 ),
 CONSTRAINT unique_fullname UNIQUE (FirstName, LastName, Patronymic)
);

CREATE INDEX fkIdx_118 ON "public".People ( Chief_Id );
CREATE INDEX fkIdx_132 ON "public".People ( Organization_Id );
CREATE INDEX Name ON "public".People USING btree
(
 FirstName,
 LastName,
 Patronymic
);

COMMENT ON TABLE "public".People IS 'Таблица содержащая данные Людей участвующих в процессе';

-- 3 ************************************** management."Order"

CREATE TABLE IF NOT EXISTS management."Order"
(
 "Id"              bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 NameOrder       varchar(100) NOT NULL,
 DataCreate      date NOT NULL,
 Customer_Id     int NOT NULL,
 DeliveryAddress text NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_order PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_21 FOREIGN KEY ( Customer_Id ) REFERENCES "public".People ( "Id" ),
 CONSTRAINT unique_order UNIQUE (NameOrder)
);

CREATE INDEX fkIdx_22 ON management."Order" ( Customer_Id );
CREATE INDEX NameOrder ON management."Order" ( NameOrder );

-- 4 ************************************** prepare.TypeAssembly

CREATE TABLE IF NOT EXISTS prepare.TypeAssembly
(
 "Id"           int NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 NameAssembly varchar(50) NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_typeassemble PRIMARY KEY ( "Id" ),
 CONSTRAINT unique_assembly UNIQUE (NameAssembly)
);

-- 5 ************************************** prepare."Module"

CREATE TABLE IF NOT EXISTS prepare."Module"
(
 "Id"             int NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 NameModule     varchar(100) NOT NULL,
 Constructor_Id int NOT NULL,
 Description    text COLLATE pg_catalog."default",
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_module PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_72 FOREIGN KEY ( Constructor_Id ) REFERENCES "public".People ( "Id" ),
 CONSTRAINT unique_Module UNIQUE (NameModule)
);

CREATE INDEX fkIdx_73 ON prepare."Module" ( Constructor_Id );

-- 6 ************************************** prepare.Goods

CREATE TABLE IF NOT EXISTS prepare.Goods
(
 "Id"              bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 NameGoods       varchar(200) NOT NULL,
 Pins            int NOT NULL,
 TypeAssembly_Id int NOT NULL,
 Description     varchar(50) NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_goods PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_34 FOREIGN KEY ( TypeAssembly_Id ) REFERENCES prepare.TypeAssembly ( "Id" ),
 CONSTRAINT unique_Goods UNIQUE (NameGoods)
);

CREATE UNIQUE INDEX NameGoods ON prepare.Goods ( NameGoods ) INCLUDE ( NameGoods );

CREATE INDEX fkIdx_35 ON prepare.Goods ( TypeAssembly_Id );

-- 7 ************************************** management.OrderSpecification

CREATE TABLE IF NOT EXISTS management.OrderSpecification
(
 "Id"        bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 Order_Id  bigint NOT NULL,
 Module_Id int NOT NULL,
 Quantity  int NOT NULL,
 Assembly  boolean NOT NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_orderspecification PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_52 FOREIGN KEY ( Order_Id ) REFERENCES management."Order" ( "Id" ),
 CONSTRAINT FK_93 FOREIGN KEY ( Module_Id ) REFERENCES prepare."Module" ( "Id" )
);

CREATE INDEX fkIdx_53 ON management.OrderSpecification ( Order_Id );
CREATE INDEX fkIdx_94 ON management.OrderSpecification ( Module_Id );

-- 8 ************************************** purchase.Invoice

CREATE TABLE IF NOT EXISTS purchase.Invoice
(
 "Id"          bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 NameInvoice varchar(50) NOT NULL,
 DataCreate  date NOT NULL,
 Payment     double precision NOT NULL,
 LastUpdate  timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_invoice PRIMARY KEY ( "Id" ),
 CONSTRAINT unique_Invoice UNIQUE (NameInvoice)
);

-- 9 ************************************** purchase.CommercialOfferGoods

CREATE TABLE IF NOT EXISTS purchase.CommercialOfferGoods
(
 "Id"                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 GoodsManufaction_Id bigint NOT NULL,
 QuantityPurchase    double precision NOT NULL,
 PricePurchase       double precision NOT NULL,
 Currency            varchar(50) NOT NULL,
 PriceSale           double precision NOT NULL,
 DeliveryTime        int NOT NULL,
 MinQuota            boolean NOT NULL,
 Manufaction_Id      int NOT NULL,
 Supplier_Id         int NOT NULL,
 Manager_Id          int NOT NULL,
 Description         text NULL,
 Invoice_Id          bigint NOT NULL,
 OrderSalor          varchar(50) NOT NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_commercialoffergoods PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_193 FOREIGN KEY ( GoodsManufaction_Id ) REFERENCES prepare.Goods ( "Id" ),
 CONSTRAINT FK_196 FOREIGN KEY ( Manufaction_Id ) REFERENCES "public".Organization ( "Id" ),
 CONSTRAINT FK_199 FOREIGN KEY ( Supplier_Id ) REFERENCES "public".Organization ( "Id" ),
 CONSTRAINT FK_202 FOREIGN KEY ( Manager_Id ) REFERENCES "public".People ( "Id" ),
 CONSTRAINT FK_245 FOREIGN KEY ( Invoice_Id ) REFERENCES purchase.Invoice ( "Id" ),
 CONSTRAINT Check_Price CHECK ( PricePurchase > 0 )
);

CREATE INDEX fkIdx_194 ON purchase.CommercialOfferGoods ( GoodsManufaction_Id );
CREATE INDEX fkIdx_197 ON purchase.CommercialOfferGoods ( Manufaction_Id );
CREATE INDEX fkIdx_200 ON purchase.CommercialOfferGoods ( Supplier_Id );
CREATE INDEX fkIdx_203 ON purchase.CommercialOfferGoods ( Manager_Id );
CREATE INDEX fkIdx_246 ON purchase.CommercialOfferGoods ( Invoice_Id );

-- 10 ************************************** prepare.CommercialOfferAssembly

CREATE TABLE IF NOT EXISTS prepare.CommercialOfferAssembly
(
 "Id"              bigint NOT NULL,
 Contractor_Id   int NOT NULL,
 TypeAssembly_Id int NOT NULL,
 OrderSp_Id      bigint NOT NULL,
 price           double precision NOT NULL,
 LeadTime        int NOT NULL,
 ForOffer        boolean NULL,
 ForPurchase     boolean NULL,
 Invoice_Id      bigint NULL,
 LastUpdate      timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_coomercialofferassembly PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_156 FOREIGN KEY ( Contractor_Id ) REFERENCES "public".Organization ( "Id" ),
 CONSTRAINT FK_159 FOREIGN KEY ( TypeAssembly_Id ) REFERENCES prepare.TypeAssembly ( "Id" ),
 CONSTRAINT FK_165 FOREIGN KEY ( OrderSp_Id ) REFERENCES management.OrderSpecification ( "Id" ),
 CONSTRAINT FK_242 FOREIGN KEY ( Invoice_Id ) REFERENCES purchase.Invoice ( "Id" )
);

CREATE INDEX fkIdx_157 ON prepare.CommercialOfferAssembly ( Contractor_Id );
CREATE INDEX fkIdx_160 ON prepare.CommercialOfferAssembly ( TypeAssembly_Id );
CREATE INDEX fkIdx_166 ON prepare.CommercialOfferAssembly ( OrderSp_Id );
CREATE INDEX fkIdx_243 ON prepare.CommercialOfferAssembly ( Invoice_Id );

-- 11 ************************************** purchase.DeliveryRelation

CREATE TABLE IF NOT EXISTS purchase.DeliveryRelation
(
 "Id"                bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 CommOfferGoods_Id bigint NOT NULL,
 Quantity          double precision NOT NULL,
 NameDelivery      varchar(50) NOT NULL,
 DateShipment      date NOT NULL,
 DateDelivery      date NOT NULL,
 Destination       varchar(50) NOT NULL,
 LastUpdate        timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_deliveryrelation PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_254 FOREIGN KEY ( CommOfferGoods_Id ) REFERENCES purchase.CommercialOfferGoods ( "Id" )
);

CREATE INDEX fkIdx_255 ON purchase.DeliveryRelation ( CommOfferGoods_Id );

COMMENT ON TABLE purchase.DeliveryRelation IS 'В таблице содержится перечень товаров, которые отправил поставщик (можно частично)';

-- 12 ************************************** store.Stock

CREATE TABLE IF NOT EXISTS store.Stock
(
 "Id"                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 DeliveryRelation_Id bigint NOT NULL,
 Quantity            double precision NOT NULL,
 DateRevise          date NOT NULL,
 WarehouseWoorker_Id int NOT NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_stock PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_266 FOREIGN KEY ( DeliveryRelation_Id ) REFERENCES purchase.DeliveryRelation ( "Id" ),
 CONSTRAINT FK_271 FOREIGN KEY ( WarehouseWoorker_Id ) REFERENCES "public".People ( "Id" )
);

CREATE INDEX fkIdx_267 ON store.Stock ( DeliveryRelation_Id );
CREATE INDEX fkIdx_272 ON store.Stock ( WarehouseWoorker_Id );

COMMENT ON TABLE store.Stock IS 'Таблица склада содержит данные поступления товаров с определенной поставки, количество может быть (ошибочно) меньше чем отправляли.';

-- 13 ************************************** store.StockSet

CREATE TABLE IF NOT EXISTS store.StockSet
(
 "Id"                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 Stock_Id            bigint NOT NULL,
 QuantitySet         double precision NOT NULL,
 DateSet             date NOT NULL,
 WarehouseWoorker_Id int NOT NULL,
 DateShipment        date NULL,
 Assembly_Id         bigint NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_stockset PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_286 FOREIGN KEY ( Stock_Id ) REFERENCES store.Stock ( "Id" ),
 CONSTRAINT FK_293 FOREIGN KEY ( WarehouseWoorker_Id ) REFERENCES "public".People ( "Id" ),
 CONSTRAINT FK_300 FOREIGN KEY ( Assembly_Id ) REFERENCES prepare.CommercialOfferAssembly ( "Id" )
);

CREATE INDEX fkIdx_287 ON store.StockSet ( Stock_Id );
CREATE INDEX fkIdx_294 ON store.StockSet ( WarehouseWoorker_Id );
CREATE INDEX fkIdx_301 ON store.StockSet ( Assembly_Id );

-- 14 ************************************** management.CommercialOfferOrder

CREATE TABLE IF NOT EXISTS management.CommercialOfferOrder
(
 "Id"                      bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 OrderSp_Id              bigint NOT NULL,
 GoodsCustomer_Id        bigint NOT NULL,
 QuantitySpecification   double precision NOT NULL,
 unit                    varchar(50) NOT NULL,
 NameApproval            boolean NULL,
 DetailApproval          text NULL,
 Purchase                boolean NULL,
 DatePurchase            date NULL,
 ManagerPurchase_Id      int NULL,
 StockSet_Id             bigint NULL,
 DateShipmentOrder       date NULL,
 LastUpdate              timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_commercialoffer PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_134 FOREIGN KEY ( ManagerPurchase_Id ) REFERENCES "public".Organization ( "Id" ),
 CONSTRAINT FK_296 FOREIGN KEY ( StockSet_Id ) REFERENCES store.StockSet ( "Id" ),
 CONSTRAINT FK_84 FOREIGN KEY ( GoodsCustomer_Id ) REFERENCES prepare.Goods ( "Id" ),
 CONSTRAINT FK_90 FOREIGN KEY ( OrderSp_Id ) REFERENCES management.OrderSpecification ( "Id" )
);

CREATE INDEX fkIdx_135 ON management.CommercialOfferOrder ( ManagerPurchase_Id );
CREATE INDEX fkIdx_297 ON management.CommercialOfferOrder ( StockSet_Id );
CREATE INDEX fkIdx_85 ON management.CommercialOfferOrder ( GoodsCustomer_Id );
CREATE INDEX fkIdx_91 ON management.CommercialOfferOrder ( OrderSp_Id );

-- 15 ************************************** store.TableSupplyModule

CREATE TABLE IF NOT EXISTS store.TableSupplyModule
(
 "Id"                bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 OrderSp_Id        bigint NOT NULL,
 DateShipment      date NULL,
 DateOfCompletion  date NULL,
 Assembly_Id       bigint NOT NULL,
 Quantity          double precision NOT NULL,
 Descryption       text NULL,
 DateShipmentOrder date NULL,
 LastUpdate        timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_tablesupplaymodule PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_307 FOREIGN KEY ( OrderSp_Id ) REFERENCES management.OrderSpecification ( "Id" ),
 CONSTRAINT FK_312 FOREIGN KEY ( Assembly_Id ) REFERENCES prepare.CommercialOfferAssembly ( "Id" )
);

CREATE INDEX fkIdx_308 ON store.TableSupplyModule ( OrderSp_Id );
CREATE INDEX fkIdx_313 ON store.TableSupplyModule ( Assembly_Id );

-- 16 ************************************** prepare.ModuleSpecification

CREATE TABLE IF NOT EXISTS prepare.ModuleSpecification
(
 "Id"                  bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 Goods_Id            bigint NOT NULL,
 Module_Id           int NOT NULL,
 Quantity            double precision NOT NULL,
 unit                varchar(50) NOT NULL,
 NumberCustomer      int NOT NULL,
 NumberSpecification int NULL,
 "Position"          varchar(200) NULL,
 Note                text NULL,
 LastUpdate          timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_modulespecification PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_41 FOREIGN KEY ( Goods_Id ) REFERENCES prepare.Goods ( "Id" ),
 CONSTRAINT FK_76 FOREIGN KEY ( Module_Id ) REFERENCES prepare."Module" ( "Id" )
);

CREATE INDEX fkIdx_42 ON prepare.ModuleSpecification ( Goods_Id );
CREATE INDEX fkIdx_77 ON prepare.ModuleSpecification ( Module_Id );

-- 17 ************************************** purchase.PurchaseRelation

CREATE TABLE IF NOT EXISTS purchase.PurchaseRelation
(
 "Id"                bigint NOT NULL GENERATED ALWAYS AS IDENTITY (
 minvalue 1
 start 1
 ),
 CommOfferOrder_Id bigint NOT NULL,
 CommOfferGoods_Id bigint NOT NULL,
 LastUpdate        timestamp NOT NULL DEFAULT now(),

 CONSTRAINT PK_purchase PRIMARY KEY ( "Id" ),
 CONSTRAINT FK_239 FOREIGN KEY ( CommOfferOrder_Id ) REFERENCES management.CommercialOfferOrder ( "Id" ),
 CONSTRAINT FK_248 FOREIGN KEY ( CommOfferGoods_Id ) REFERENCES purchase.CommercialOfferGoods ( "Id" )
);

CREATE INDEX fkIdx_240 ON purchase.PurchaseRelation ( CommOfferOrder_Id );
CREATE INDEX fkIdx_249 ON purchase.PurchaseRelation ( CommOfferGoods_Id );
