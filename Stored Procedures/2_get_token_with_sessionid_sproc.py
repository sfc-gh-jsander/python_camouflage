from snowflake.snowpark import Session
import zlib

def run(session):
  sql1 = """  select get_oauth_token_session('18e4c953-3423-4301-b050-562dbde643d2','device_code',$dev_code,'https://login.microsoftonline.com/b3b06c45-b6f1-4d13-a720-8845b509b948/oauth2/v2.0/token',(select current_session()))"""       
  token=str(session.sql(sql1).collect()[0][0])
  token=token[22:]
  token=token[:-3]
  session.sql("""set tokenraw  ='"""+token+"""'""").collect()
  session.sql("""set token  =(select compress($tokenraw,'ZLIB'))""").collect()
  session.sql("""unset tokenraw""").collect()
  session.sql("""set jwtks= (select compress((select get_azure_jwks('https://login.microsoftonline.com/b3b06c45-b6f1-4d13-a720-8845b509b948/discovery/v2.0/keys')), 'ZLIB'))""").collect()
  pubkey2=session.sql("""select getksession_pubkey()""").collect()[0][0]
  pubkey=zlib.decompress(pubkey2).decode()
  session.sql("""set pubkey  ='"""+pubkey+"""'""").collect()
  
  
  
  return 'token set'