use role ff3_standard;

use database ff3_test_db;
use schema ff3_test_schema;
use warehouse ff3_test_wh;



--SOURCE TABLE
select * from insurance_source1;

--ASSIGN TAG TO MASKING POLICY 
use role ff3_tag_admin;

use database ff3_test_db;
use schema ff3_test_schema;
use warehouse ff3_test_wh;

alter tag ff3_encrypt set
  masking policy ENCRYPT_STRING_FF3,
  masking policy ENCRYPT_NUMBER_FF3_INTEGER,
  masking policy ENCRYPT_FLOAT_FF3;
  
  
alter tag ff3_data_sc set
  masking policy DECRYPT_FORMAT_FF3_FLOAT,
  masking policy DECRYPT_FORMAT_FF3_STRING,
  masking policy DECRYPT_FORMAT_FF3_INTEGER ;



set encryptkey='KEY678901';

use role ff3_standard;

create or replace view insurance_source1_view1 as  select  $encryptkey as KEYID, * from insurance_source1 ;  

select * from insurance_source1_view1;

use role ff3_tag_admin;

alter table insurance_source1_view1 modify column age set tag ff3_encrypt='',column sex set tag ff3_encrypt='',column bmi set tag ff3_encrypt='',column children set tag ff3_encrypt='',column smoker set tag ff3_encrypt='',column region set tag ff3_encrypt='',column charges set tag ff3_encrypt='';

use role ff3_standard;

--AES256 KEY, 56 bit Tweak, 6 digit padding
--https://pages.nist.gov/ACVP/draft-celi-acvp-symmetric.html#name-test-groups

set userkeys='''{
    "678901": ["7d1b1f5d48fed50a53c6c7afffc1b4ec3fc2865a97744b263e285676bc96c055", "CBD09280979564", "56854"],
    "678902": ["c2051e1a93c3fd7f0e4f20b4fb4f7889aeb8d6fd10f68551af659323f42961e9", "7036604882667B", "85567"]
}''';

grant usage on database ff3_test_db to role ff3_encrypt;
grant usage on schema ff3_test_schema to role ff3_encrypt;
grant all privileges on table insurance_source1_view1 to role ff3_encrypt;


use role ff3_encrypt;

use database ff3_test_db;
use schema ff3_test_schema;
use warehouse ff3_test_wh;

select * from insurance_source1_view1;


-- INGEST


use role ff3_standard;
    
CREATE or replace TABLE insurance_source1_target1 (
  keyid varchar(255) ,
  age integer ,
  sex varchar(255) ,
  bmi integer ,
  children  integer,
  smoker varchar(255),
  region varchar(255),
  charges integer
);

grant usage on database ff3_test_db to role ff3_decrypt;
grant usage on schema ff3_test_schema to role ff3_decrypt;

grant usage on database ff3_test_db to role ff3_data_sc;
grant usage on schema ff3_test_schema to role ff3_data_sc;

grant usage on database ff3_test_db to role ff3_masked;
grant usage on schema ff3_test_schema to role ff3_masked;

grant all privileges on table insurance_source1_target1 to role ff3_encrypt;
grant all privileges on table insurance_source1_target1 to role ff3_masked;
grant all privileges on table insurance_source1_target1 to role ff3_decrypt;
grant all privileges on table insurance_source1_target1 to role ff3_data_sc;



use role ff3_encrypt;

select * from insurance_source1_target1;

INSERT INTO insurance_source1_target1  select * from insurance_source1_view1;

use role ff3_standard;

create or replace view insurance_source1_target1_view1 as  select  $encryptkey as KEYID, * from insurance_source1_target1 ;  
 
grant all privileges on table insurance_source1_target1_view1 to role ff3_encrypt;
grant all privileges on table insurance_source1_target1_view1 to role ff3_masked;
grant all privileges on table insurance_source1_target1_view1 to role ff3_decrypt;
grant all privileges on table insurance_source1_target1_view1 to role ff3_data_sc;
    

--here
select * from insurance_source1_target1_view1 order by  charges desc;

use role ff3_tag_admin;
alter table insurance_source1_target1_view1 modify column age set tag ff3_data_sc='',column sex set tag ff3_data_sc='',column bmi set tag ff3_data_sc='',column children set tag ff3_data_sc='',column smoker set tag ff3_data_sc='',column region set tag ff3_data_sc='',column charges set tag ff3_data_sc='';



alter table insurance_source1_target1_view1 modify column charges set tag fuzzy='';
alter table insurance_source1_target1_view1 modify column age set tag fuzzy='';
alter table insurance_source1_target1_view1 modify column bmi set tag fuzzy='';
alter table insurance_source1_target1_view1 modify column smoker set tag decrypt_this='';
alter table insurance_source1_target1_view1 modify column children set tag sqljoin='';



use role ff3_decrypt;
select * from insurance_source1_target1_view1  order by charges desc;


select count(*) from insurance_source1_target1_view1 where smoker='yes' order by charges desc;

select sum(charges) from insurance_source1_target1_view1 where smoker='yes' ;
select sum(charges) from insurance_source1_target1_view1  ;
select sum(charges) from insurance_source1_target1_view1 WHERE age >= 30 AND age <= 40 and smoker='yes';
select sum(charges) from insurance_source1_target1_view1 WHERE age >= 50 AND age <= 60  ;
 

use role ff3_data_sc;


select * from insurance_source1_target1_view1  order by charges desc;
select charges,age from insurance_source1_target1_view1 where smoker='yes' ;
select count(*) from insurance_source1_target1_view1 where smoker='yes' order by charges desc;


--- Change to partial decrypt to approximate

use role ff3_tag_admin;

alter table insurance_source1_target1_view1 modify column charges unset tag fuzzy;
alter table insurance_source1_target1_view1 modify column age unset tag fuzzy;
alter table insurance_source1_target1_view1 modify column bmi unset tag fuzzy;

use role ff3_data_sc;

select sum(charges) from insurance_source1_target1_view1 where smoker='yes' ;
select sum(charges) from insurance_source1_target1_view1 where smoker='no' ;



select sum(charges) from insurance_source1_target1_view1 WHERE age >= 30 AND age <= 40 and smoker='yes';

select charges from insurance_source1_target1_view1 WHERE age >= 30 AND age <= 40 and smoker='yes';

select sum(charges) from insurance_source1_target1_view1 WHERE age  >= 50 AND age <= 60 and smoker='yes';
select sum(charges) from insurance_source1_target1_view1 WHERE age >= 50 AND age <= 60 and smoker='no';

select sum(charges) from insurance_source1_target1_view1 WHERE age >= 50 AND age <= 60 ;

select avg(charges) from insurance_source1_target1_view1 ;
    

--to compare between partial decrypted (first digit) and fully decrypted numbers
use role ff3_decrypt;
use role ff3_data_sc;
    
     
 --optionally fully decrypt age and bmi but leave charges partially decrypted (first digit)
 
 use role ff3_tag_admin;
 
 
 
alter table insurance_source1_target1_view1 modify column age set tag decrypt_this='';
alter table insurance_source1_target1_view1 modify column bmi set tag decrypt_this='';
    
--move back to partial decryption (1 digit)

use role ff3_tag_admin;
alter table insurance_source1_target1_view1 modify column age unset tag decrypt_this;
alter table insurance_source1_target1_view1 modify column bmi unset tag decrypt_this;
      
--to compare full encryption again
use role ff3_tag_admin;
alter table insurance_source1_target1_view1 modify column age set tag fuzzy='';
alter table insurance_source1_target1_view1 modify column bmi set tag fuzzy='';
alter table insurance_source1_target1_view1 modify column charges set tag fuzzy='';

--play with raw tokens 
use role ff3_tag_admin;

alter table insurance_source1_target1_view1 modify column children unset tag sqljoin;
--and query again with ff3_data_sc

alter table insurance_source1_target1_view1 modify column children set tag sqljoin='';
--and query again with ff3_data_sc

alter table insurance_source1_target1_view1 modify column age set tag sqljoin='';
--and query again with ff3_data_sc

alter table insurance_source1_target1_view1 modify column age unset tag sqljoin;
--and query again with ff3_data_sc


-- Further formatters are available that can make FF3-1 raw tokens look like US phone numbers or US postal codes
-- In order to test this use the worksheet datayptes_test.sql and go through the steps there.
-- Here also other datatypes such as floats and mixed numbers such as integers and decimals in the same table can be explored