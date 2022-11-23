---  Create objects for use in the demo and grant the rights to them.

--- Create demo roles
create or replace role ff3_encrypt;
create or replace role ff3_decrypt;
create or replace role data_sc;
create or replace role masked;

--- Grant demo roles to your demo user
--- Replace <USER> with your demo user
grant role ff3_encrypt to user <USER>;
grant role ff3_decrypt to user <USER>;
grant role data_sc to user <USER>;
grant role masked to user <USER>;

--- Create warehouse for demo  
create or replace warehouse ff3_testing_wh warehouse_size=medium initially_suspended=true;

--- Grants on warehouse for demo
grant usage, operate on warehouse ff3_testing_wh to role ff3_encrypt;
grant usage, operate on warehouse ff3_testing_wh to role ff3_decrypt;
grant usage, operate on warehouse ff3_testing_wh to role data_sc;
grant usage, operate on warehouse ff3_testing_wh to role masked;

--- Create demo database and schema for demo
create or replace database ff3_testing_db;
create schema ff3_testing_db.ff3_testing_schema;

use database ff3_testing_db;
use schema ff3_testing_db.ff3_testing_schema;

--- Create internal stage for the FF3 Python library
create or replace stage python_libs_ff3;

use database ff3_testing_db;
use schema ff3_testing_schema;
use warehouse ff3_testing_wh;
use role accountadmin;

put file://ff3.zip @python_libs_ff3 auto_compress=false;

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
