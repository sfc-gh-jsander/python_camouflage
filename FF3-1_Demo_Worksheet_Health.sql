use role ff3_standard;

use database ff3_testing_db_new;
use schema ff3_testing_schema_new;
use warehouse ff3_testing_wh_new;



--SOURCE TABLE
select * from insurance;

--ASSIGN TAG TO MASKING POLICY 
use role ff3_tag_admin;

use database ff3_testing_db_new;
use schema ff3_testing_schema_new;
use warehouse ff3_testing_wh_new;

alter tag ff3_encrypt set
  masking policy ENCRYPT_STRING_FF3,
  masking policy ENCRYPT_NUMBER_FF3_DECIMAL_38_8,
  masking policy FF3_ENCRYPT_FLOAT;

alter tag ff3_data_sc set
  masking policy DECRYPT_FORMAT_FF3_FLOAT,
  masking policy DECRYPT_FORMAT_FF3_STRING,
  masking policy DECRYPT_FORMAT_FF3_DECIMAL_38_8 ;



set encryptkey='KEY678901';

use role ff3_standard;

create or replace view insurance_view1 as  select  $encryptkey as KEYID, * from insurance ;
grant all privileges on tag ff3_encrypt to role ff3_standard;  

select * from insurance_view1;

use role ff3_tag_admin;

alter table insurance_view1 modify column age set tag ff3_encrypt='',column sex set tag ff3_encrypt='',column bmi set tag ff3_encrypt='',column children set tag ff3_encrypt='',column smoker set tag ff3_encrypt='',column region set tag ff3_encrypt='',column charges set tag ff3_encrypt='';

use role ff3_standard;

set userkeys='''{
    "678901": ["2DE79D232DF5585D68CE47882AE256D6", "CBD09280979564", "56854"],
    "678902": ["c2051e1a93c3fd7f0e4f20b4fb4f7889aeb8d6fd10f68551af659323f42961e9", "CBD09280979841", "85567"]
}''';

grant usage on database ff3_testing_db_new to role ff3_encrypt;
grant usage on schema ff3_testing_schema_new to role ff3_encrypt;
grant all privileges on table insurance_view1 to role ff3_encrypt;


use role ff3_encrypt;

use database ff3_testing_db_new;
use schema ff3_testing_schema_new;
use warehouse ff3_testing_wh_new;

select * from insurance_view1;


-- INGEST


use role ff3_standard;
    
CREATE or replace TABLE insurance_target1 (
  keyid varchar(255) ,
  age integer ,
  sex varchar(255) ,
  bmi integer ,
  children  integer,
  smoker varchar(255),
  region varchar(255),
  charges integer
);

grant usage on database ff3_testing_db_new to role ff3_decrypt;
grant usage on schema ff3_testing_schema_new to role ff3_decrypt;

grant usage on database ff3_testing_db_new to role ff3_data_sc;
grant usage on schema ff3_testing_schema_new to role ff3_data_sc;

grant usage on database ff3_testing_db_new to role ff3_masked;
grant usage on schema ff3_testing_schema_new to role ff3_masked;

grant all privileges on table insurance_target1 to role ff3_encrypt;
grant all privileges on table insurance_target1 to role ff3_masked;
grant all privileges on table insurance_target1 to role ff3_decrypt;
grant all privileges on table insurance_target1 to role ff3_data_sc;



use role ff3_encrypt;

select * from insurance_target1;

INSERT INTO insurance_target1  select * from insurance_view1;
 
    
use role ff3_standard;

select * from insurance_target1 order by  charges desc;

use role ff3_tag_admin;
alter table insurance_target1 modify column age set tag ff3_data_sc='',column sex set tag ff3_data_sc='',column bmi set tag ff3_data_sc='',column children set tag ff3_data_sc='',column smoker set tag ff3_data_sc='',column region set tag ff3_data_sc='',column charges set tag ff3_data_sc='';



alter table insurance_target1 modify column charges set tag fuzzy='';
alter table insurance_target1 modify column age set tag fuzzy='';
alter table insurance_target1 modify column bmi set tag fuzzy='';
alter table insurance_target1 modify column smoker set tag decrypt_this='';
alter table insurance_target1 modify column children set tag sqljoin='';



use role ff3_decrypt;
select * from insurance_target1  order by charges desc;


select count(*) from insurance_target1 where smoker='yes' order by charges desc;

select sum(charges::number(38,8)) from insurance_target1 where smoker='yes' ;
select sum(charges::number(38,8)) from insurance_target1  ;
select sum(charges::number(38,8)) from insurance_target1 WHERE age::number(38,8) >= 30 AND age::number(38,8) <= 40 and smoker='yes';
select sum(charges::number(38,8)) from insurance_target1 WHERE age::number(38,8) >= 50 AND age::number(38,8) <= 60  ;
 

use role ff3_data_sc;


select * from insurance_target1  order by charges desc;
select charges,age::number(38,8) from insurance_target1 where smoker='yes' ;
select count(*) from insurance_target1 where smoker='yes' order by charges desc;


--- Change to partial decrypt to approximate

use role ff3_tag_admin;

alter table insurance_target1 modify column charges unset tag fuzzy;
alter table insurance_target1 modify column age unset tag fuzzy;
alter table insurance_target1 modify column bmi unset tag fuzzy;

use role ff3_data_sc;

select sum(charges::number(38,8)) from insurance_target1 where smoker='yes' ;
select sum(charges::number(38,8)) from insurance_target1 where smoker='no' ;



select sum(charges::number(38,8)) from insurance_target1 WHERE age::number(38,8) >= 30 AND age::number(38,8) <= 40 and smoker='yes';

select charges::number(38,8) from insurance_target1 WHERE age::number(38,8) >= 30 AND age::number(38,8) <= 40 and smoker='yes';

select sum(charges::number(38,8)) from insurance_target1 WHERE age::number(38,8)  >= 50 AND age::number(38,8) <= 60 and smoker='yes';
select sum(charges::number(38,8)) from insurance_target1 WHERE age::number(38,8) >= 50::number(38,8) AND age::number(38,8) <= 60::number(38,8) and smoker='no';

select sum(charges::number(38,8)) from insurance_target1 WHERE age::number(38,8) >= 50 AND age::number(38,8) <= 60 ;

select avg(charges::number(38,8)) from insurance_target1 ;
    

--to compare between partial decrypted (first digit) and fully decrypted numbers
use role ff3_decrypt;
use role ff3_data_sc;
    
     
 --optionally fully decrypt age and bmi but leave charges partially decrypted (first digit)
 
 use role ff3_tag_admin;
 
 
 
alter table insurance_target1 modify column age set tag decrypt_this='';
alter table insurance_target1 modify column bmi set tag decrypt_this='';
    
--move back to partial decryption (1 digit)

use role ff3_tag_admin;
alter table insurance_target1 modify column age unset tag decrypt_this;
alter table insurance_target1 modify column bmi unset tag decrypt_this;
      
--to compare full encryption again
use role ff3_tag_admin;
alter table insurance_target1 modify column age set tag fuzzy='';
alter table insurance_target1 modify column bmi set tag fuzzy='';
alter table insurance_target1 modify column charges set tag fuzzy='';

--play with raw tokens 
use role ff3_tag_admin;

alter table insurance_target1 modify column children unset tag sqljoin;
--and query again with ff3_data_sc

alter table insurance_target1 modify column children set tag sqljoin='';
--and query again with ff3_data_sc

alter table insurance_target1 modify column age set tag sqljoin='';
--and query again with ff3_data_sc

alter table insurance_target1 modify column age unset tag sqljoin;
--and query again with ff3_data_sc


-- Further formatters are available that can make FF3-1 raw tokens look like US phone numbers or US postal codes
-- In order to test this use the worksheet datayptes_test.sql and go through the steps there.
-- Here also other datatypes such as floats and mixed numbers such as integers and decimals in the same table can be explored





 
 
 
 
 
 alter table insurance_target1 modify column age set tag decrypt_this='';
  alter table insurance_target1 modify column age unset tag decrypt_this;
  alter table insurance_target1 modify column bmi set tag decrypt_this='';
    alter table insurance_target1 modify column bmi unset tag decrypt_this;
 
 set userkeys='''{
    "678901": ["2DE79D232DF5585D68CE47882AE256D6", "CBD09280979564", "56854"],
    "678902": ["c2051e1a93c3fd7f0e4f20b4fb4f7889aeb8d6fd10f68551af659323f42961e9", "CBD09280979841", "85567"]
}''';






create or replace external function get_oauth_url_code (client_id varchar, scope varchar, resource_url varchar, device_code_url varchar)
    returns variant
    api_integration = azure_api_1
    as 'https://kellersapi.azure-api.net/kellers-sf-function-test/get_oauth_url';
    
    
    select get_oauth_url_code('18e4c953-3423-4301-b050-562dbde643d2','https://kelleruserflow.snowflakeseclab42outlook.onmicrosoft.com/session:scope:POWERBIUSER','https://kelleruserflow.snowflakeseclab42outlook.onmicrosoft.com','https://login.microsoftonline.com/b3b06c45-b6f1-4d13-a720-8845b509b948/oauth2/devicecode');
;
  