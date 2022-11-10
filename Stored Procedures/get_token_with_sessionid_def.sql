CREATE OR REPLACE PROCEDURE get_token_with_sessionid()
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python')
IMPORTS = ('@python_libs/get_token_with_sessionid_sproc.py')
HANDLER = 'get_token_with_sessionid_sproc.run'
EXECUTE AS CALLER