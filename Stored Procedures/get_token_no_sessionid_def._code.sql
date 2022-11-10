CREATE OR REPLACE PROCEDURE get_token()
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'
EXECUTE AS CALLER
AS
$$
from snowflake.snowpark import Session

def run(session):
  sql1 = """  select get_oauth_token('18e4c953-3423-4301-b050-562dbde643d2','device_code',$dev_code,'https://login.microsoftonline.com/b3b06c45-b6f1-4d13-a720-8845b509b948/oauth2/v2.0/token')"""       
  token=str(session.sql(sql1).collect()[0][0])
  token=token[22:]
  token=token[:-3]
  session.sql("""set tokenraw  ='"""+token+"""'""").collect()
  session.sql("""set token  =(select compress($tokenraw,'ZLIB'))""").collect()
  session.sql("""unset tokenraw""").collect()
  session.sql("""set jwtks= (select compress((select get_azure_jwks('https://login.microsoftonline.com/b3b06c45-b6f1-4d13-a720-8845b509b948/discovery/v2.0/keys')), 'ZLIB'))""").collect()
  
  return 'token set'
  
  
$$;