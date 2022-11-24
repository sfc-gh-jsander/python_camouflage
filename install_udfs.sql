use database ff3_testing_db;
use schema ff3_testing_schema;
use warehouse ff3_testing_wh;
use role accountadmin;

put file://ff3.zip @python_libs_ff3 auto_compress=false;
put file://*.py @python_libs_ff3 ;