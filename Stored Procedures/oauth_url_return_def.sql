
CREATE OR REPLACE PROCEDURE oauth_url_return()
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python')
IMPORTS = ('@python_libs/oauth_url_return_sproc.py')
HANDLER = 'oauth_url_return_sproc.run'
EXECUTE AS CALLER