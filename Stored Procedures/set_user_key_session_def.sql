CREATE OR REPLACE PROCEDURE set_user_key_session(ff3key string, token binary)
RETURNS STRING
EXECUTE AS CALLER
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python')
IMPORTS = ('@python_libs/set_user_key_session_sproc.py')
HANDLER = 'set_user_key_session.run'
