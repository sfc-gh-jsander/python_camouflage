---  Create objects for use in the demo and grant the rights to them.

use role sysadmin;

--- Create demo roles
create or replace role ff3_encrypt;
create or replace role ff3_decrypt;
create or replace role data_sc;
create or replace role masked;

--- Grant demo roles to your demo user
--- Replace KELLER with your demo user
/*grant role ff3_encrypt to user KELLER;
grant role ff3_decrypt to user KELLER;
grant role data_sc to user KELLER;
grant role masked to user KELLER;*/

grant role ff3_encrypt to user KELLER;
grant role ff3_decrypt to user KELLER;
grant role data_sc to user KELLER;
grant role masked to user KELLER;

--- Create warehouse for demo  
create or replace warehouse ff3_testing_wh_new warehouse_size=medium initially_suspended=true;

--- Grants on warehouse for demo
grant usage, operate on warehouse ff3_testing_wh_new to role ff3_encrypt;
grant usage, operate on warehouse ff3_testing_wh_new to role ff3_decrypt;
grant usage, operate on warehouse ff3_testing_wh_new to role data_sc;
grant usage, operate on warehouse ff3_testing_wh_new to role masked;

--- Create demo database and schema for demo
create or replace database ff3_testing_db_new;
create schema ff3_testing_db.ff3_testing_schema_new;

use database ff3_testing_db_new;
use schema ff3_testing_db.ff3_testing_schema_new;

--- Create internal stage for the FF3 Python library
create or replace stage python_libs_ff3;

use database ff3_testing_db_new;
use schema ff3_testing_schema_new;
use warehouse ff3_testing_wh_new;
use role sysadmin;

put file://ff3.zip @python_libs_ff3 auto_compress=false;
put file://*.py @python_libs_ff3 ;



--- Create tags
create or replace tag ff3_data_sc;
create or replace tag ff3_encrypt;
create or replace tag sqljoin;
create or replace tag email;
create or replace tag uspostal;
create or replace tag usphone;
create or replace tag fuzzy;
create or replace tag decrypt_this;
create or replace tag faker;
create or replace tag fake_email;



create or replace TABLE FF3_TESTING_DB.FF3_TESTING_SCHEMA.INSURANCE (

    AGE NUMBER(38,0),

    SEX VARCHAR(50),

    BMI NUMBER(38,0),

    CHILDREN NUMBER(38,0),

    SMOKER VARCHAR(50),

    REGION VARCHAR(50),

    CHARGES NUMBER(38,0)

);

create or replace file format csv_format_ff3_test
  type = csv
  field_delimiter = ','
  skip_header = 1
  null_if = ('NULL', 'null')
  empty_field_as_null = true
  compression = gzip;

create or replace stage ff3_csv_load
  file_format = csv_format_ff3_test;


put file://insurance.csv @ff3_csv_load ;

copy into insurance from @ff3_csv_load/insurance.csv
file_format = (format_name = 'csv_format_ff3_test');

drop stage ff3_csv_load;
drop file format csv_format_ff3_test;

set userkeys='test';

