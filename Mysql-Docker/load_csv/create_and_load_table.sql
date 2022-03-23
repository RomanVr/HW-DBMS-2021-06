use orderManSys;

CREATE TABLE IF NOT EXISTS test_load (
Handle varchar(255),
Title varchar(255),
Body_HTML text,
Vendor varchar(255),
Type varchar(255),
Tags varchar(255),
Published varchar(255),
Option1_Name varchar(255),
Option1_Value varchar(255),
Option2_Name varchar(255),
Option2_Value varchar(255),
Option3_Name varchar(255),
Option3_Value varchar(255),
Variant_SKU varchar(255),
Variant_Grams varchar(255),
Variant_Inventory_Tracker varchar(255),
Variant_Inventory_Qty int,
Variant_Inventory_Policy  varchar(255),
Variant_Fulfillment_Service	 varchar(255),
Variant_Price	 decimal(20,6),
Variant_Compare_At_Price	 decimal(20,6),
Variant_Requires_Shipping tinyint(1),
Variant_Taxable	 tinyint(1),
Variant_Barcode	 varchar(255),
Image_Src	 varchar(255),
Image_Alt_Text	 varchar(255),
Gift_Card	 varchar(255),
SEO_Title	 varchar(255),
SEO_Description	 varchar(255),
Google_Shopping_Google_Product_Category	 varchar(255),
Google_Shopping_Gender	 varchar(255),
Google_Shopping_Age_Group	 varchar(255),
Google_Shopping_MPN	 varchar(255),
Google_Shopping_AdWords_Grouping	 varchar(255),
Google_Shopping_AdWords_Labels	 varchar(255),
Google_Shopping_Condition	 varchar(255),
Google_Shopping_Custom_Product	 varchar(255),
Google_Shopping_Custom_Label_0	 varchar(255),
Google_Shopping_Custom_Label_1	 varchar(255),
Google_Shopping_Custom_Label_2	 varchar(255),
Google_Shopping_Custom_Label_3	 varchar(255),
Google_Shopping_Custom_Label_4	 varchar(255),
Variant_Image	 varchar(255),
Variant_Weight_Unit  varchar(255)
);

LOAD DATA INFILE '/var/lib/mysql-files/jewelry.csv'
	INTO TABLE `orderManSys`.`test_load`
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 LINES
    (Handle, Title,	Body_HTML, Vendor, Type, Tags, Published, Option1_Name, Option1_Value,
    Option2_Name, Option2_Value, Option3_Name, Option3_Value, Variant_SKU, Variant_Grams,
    Variant_Inventory_Tracker, @Variant_Inventory_Qty, Variant_Inventory_Policy,
    Variant_Fulfillment_Service, @Variant_Price, @VariantAtPrice, @Variant_Requires_Shipping,
    @Variant_Taxable, Variant_Barcode, Image_Src, Image_Alt_Text, Gift_Card, SEO_Title, SEO_Description,
    Google_Shopping_Google_Product_Category, Google_Shopping_Gender, Google_Shopping_Age_Group,
    Google_Shopping_MPN, Google_Shopping_AdWords_Grouping, Google_Shopping_AdWords_Labels,
    Google_Shopping_Condition, Google_Shopping_Custom_Product, Google_Shopping_Custom_Label_0,
    Google_Shopping_Custom_Label_1, Google_Shopping_Custom_Label_2, Google_Shopping_Custom_Label_3,
    Google_Shopping_Custom_Label_4, Variant_Image, Variant_Weight_Unit)
    SET
    Variant_Requires_Shipping = if(@Variant_Requires_Shipping = 'true',1 , NULL),
    Variant_Taxable = if(@Variant_Taxable = 'true', 1, NULL),
    Variant_Compare_At_Price = if(@VariantAtPrice = '', NULL, @VariantAtPrice),
    Variant_Inventory_Qty = if(@Variant_Inventory_Qty = '', NULL, @Variant_Inventory_Qty),
    Variant_Price = if(@Variant_Price='', NULL, @Variant_Price);
