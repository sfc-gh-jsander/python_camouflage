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


-- Grant access rights to view

grant all privileges on view ff3_datatypes_view1 to role FF3_STANDARD;
grant all privileges on view ff3_datatypes_view1 to role FF3_DECRYPT;
grant all privileges on view ff3_datatypes_view1 to role FF3_ENCRYPT;

alter view ff3_datatypes_view1 modify column name set tag ff3_encrypt='',column phone set tag ff3_encrypt='',column email set tag ff3_encrypt='',column postalzip set tag ff3_encrypt='',column integernumber set tag ff3_encrypt='',column floatnumber set tag ff3_encrypt='',column decimalnumber set tag ff3_encrypt='';

--alter view ff3_datatypes_view1 modify column name unset tag ff3_encrypt,column phone unset tag ff3_encrypt,column email unset tag ff3_encrypt,column postalzip unset tag ff3_encrypt,column integernumber unset tag ff3_encrypt,column floatnumber unset tag ff3_encrypt,column decimalnumber unset tag ff3_encrypt;

use role ff3_tag_admin;

alter tag ff3_encrypt set
  masking policy ff3_encrypt_string_pass5,
  masking policy ff3_encrypt_number_pass5_decimal,
  masking policy ff3_encrypt_float_pass5;

use role ff3_encrypt;
-- Populate target table with encrypted data (stay with role FF3_Encrypt)
 INSERT INTO ff3_datatypes_target1  select * from ff3_datatypes_view1; 




 ----XXXXXX WORK HERE ---

  grant all privileges on table ff3_pass3_target1 to role accountadmin;
  grant all privileges on table ff3_pass3_target1 to role sysadmin;
 
 grant all privileges on view ff3_pass3_target1 to role ff3_encrypt;

grant all privileges on view ff3_pass3_target1 to role ff3_decrypt;
grant all privileges on view ff3_pass3_target1 to role data_sc;


grant all privileges on table ff3_pass3_target1 to role ff3_decrypt;

alter tag ff3_data_sc set
  masking policy ff3_decrypt_format_float_pass5,
  masking policy ff3_decrypt_format_string_pass5,
  masking policy ff3_decrypt_format_pass5_decimal ;

-- Change back to Accountadmin
-- Assign decrypt tag to decrypt demo table

use role accountadmin;

alter table ff3_pass3_target1 modify column name set tag ff3_data_sc='',column phone set tag ff3_data_sc='',column email set tag ff3_data_sc='',column postalzip set tag ff3_data_sc='',column integernumber set tag ff3_data_sc='',column floatnumber set tag ff3_data_sc='',column decimalnumber set tag ff3_data_sc='';
