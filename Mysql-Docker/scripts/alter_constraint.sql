ALTER TABLE CommercialOfferOrder
	ADD ComOfferGoods_id bigint NOT NULL DEFAULT 0;

ALTER TABLE CommercialOfferOrder
	ADD CONSTRAINT FK_501
	FOREIGN KEY (ComOfferGoods_id)
    REFERENCES CommercialOfferGoods ( id );
