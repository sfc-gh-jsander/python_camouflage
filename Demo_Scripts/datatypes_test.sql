-- This is a demo script to test and showcase how ff3-1 encryption / decryption can be applied to data types 
-- other than just strings and integers, but also to decimals (in this example number (38,8) ) and that decimals
-- and integers can even use the same decimal masking policy. Integers are compatible with decimals, but will be converted 
-- to decimals if the same masking polciy is applied such as the case is here. 
-- It is also possible to apply a masking policy that only encrypts/decrypts integers to an integer column and 
-- another masking policy to the decimal column(s) with the appropiate number format if desired. 
-- The data type float can also be encrypted / decrypted and also has its own set of masking policies and encrypt/decrypt UDFs.


use role ff3_standard;

use database ff3_test_db;
use schema ff3_test_schema;
use warehouse ff3_test_wh;


CREATE or replace TABLE ff3_datatypes_source1 (
  name varchar(255) default NULL,
  phone varchar(100) default NULL,
  email varchar(255) default NULL,
  postalZip varchar(10) default NULL,
  integernumber integer NULL,
  floatnumber float NULL,
  decimalnumber number(38,8) NULL
);

--Populate source table with demo data
INSERT INTO ff3_datatypes_source1 (name,phone,email,postalZip,integernumber,floatnumber,decimalnumber)
VALUES
  ('Keegan Melendez','(0088) 11345912','sapien@protonmail.edu','31242',1,2.754,6.54),
  ('Daniel Black','(0964) 05573972','ullamcorper.viverra@hotmail.org','98-353',4,343.4,45.8),
  ('Malachi Bass','(047) 36000411','dictum@protonmail.net','52545',5,1.7,698.543),
  ('Gabriel Mcknight','(071) 35811204','duis.elementum@outlook.com','10912',7,884.53,86.987),
  ('Tate Hicks','(079) 44284558','ut.aliquam@outlook.net','26465',4,54545.01,19.2);



  CREATE or replace TABLE ff3_datatypes_target1 (
  keyid varchar(255) default NULL,
  name varchar(255) default NULL,
  phone varchar(255) default NULL,
  email varchar(255) default NULL,
  postalZip varchar(255) default NULL,
  integernumber integer NULL,
  floatnumber float NULL,
  decimalnumber number(38,8) NULL
);

set encryptkey='KEY678901';

create or replace view ff3_datatypes_view1 as  select  $encryptkey as KEYID, * from ff3_datatypes_source1 ;





use role ff3_tag_admin;

create or replace tag ff3_encrypt_datatypes;
create or replace tag ff3_data_sc_decrypt_datatypes;

alter view ff3_datatypes_view1 modify column name set tag ff3_encrypt_datatypes='',column phone set tag ff3_encrypt_datatypes='',column email set tag ff3_encrypt_datatypes='',column postalzip set tag ff3_encrypt_datatypes='',column integernumber set tag ff3_encrypt_datatypes='',column floatnumber set tag ff3_encrypt_datatypes='',column decimalnumber set tag ff3_encrypt_datatypes='';


alter tag ff3_encrypt_datatypes set
  masking policy ENCRYPT_STRING_FF3,
  masking policy ENCRYPT_NUMBER_FF3_DECIMAL_38_8,
  masking policy ENCRYPT_FLOAT_FF3;
  
use role ff3_standard; 


-- Grant access rights to view

grant all privileges on view ff3_datatypes_view1 to role FF3_DATA_SC;
grant all privileges on view ff3_datatypes_view1 to role FF3_DECRYPT;
grant all privileges on view ff3_datatypes_view1 to role FF3_ENCRYPT;
grant all privileges on table ff3_datatypes_target1 to role FF3_DATA_SC;
grant all privileges on table ff3_datatypes_target1 to role FF3_DECRYPT;
grant all privileges on table ff3_datatypes_target1 to role FF3_ENCRYPT;

  

use role ff3_encrypt;

set userkeys='''{
    "678901": ["7d1b1f5d48fed50a53c6c7afffc1b4ec3fc2865a97744b263e285676bc96c055", "CBD09280979564", "56854"],
    "678902": ["c2051e1a93c3fd7f0e4f20b4fb4f7889aeb8d6fd10f68551af659323f42961e9", "7036604882667B", "85567"]
}''';

-- Populate target table with encrypted data (stay with role FF3_Encrypt)
 INSERT INTO ff3_datatypes_target1  select * from ff3_datatypes_view1; 

use role ff3_standard;

select * from ff3_datatypes_target1;


use role ff3_tag_admin;

alter tag ff3_data_sc_decrypt_datatypes set
  masking policy DECRYPT_FORMAT_FF3_STRING,
  masking policy DECRYPT_FORMAT_FF3_DECIMAL_38_8,
  masking policy DECRYPT_FORMAT_FF3_FLOAT ;


alter table ff3_datatypes_target1 modify column name set tag ff3_data_sc_decrypt_datatypes='',column phone set tag ff3_data_sc_decrypt_datatypes='',column email set tag ff3_data_sc_decrypt_datatypes='',column postalzip set tag ff3_data_sc_decrypt_datatypes='',column integernumber set tag ff3_data_sc_decrypt_datatypes='',column floatnumber set tag ff3_data_sc_decrypt_datatypes='',column decimalnumber set tag ff3_data_sc_decrypt_datatypes='';

use role ff3_decrypt;

select * from ff3_datatypes_target1;

use role ff3_data_sc;

select * from ff3_datatypes_target1;

