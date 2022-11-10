from snowflake.snowpark import Session
import zlib

def run(session, ff3keypy, tokencompress):
  token=zlib.decompress(tokencompress).decode()
  sql1 = """  create temporary table ff3_keys if not exists (keyid string, keyvalue string)  """       
  session.sql(sql1).collect()[0][0]

  session.sql("""set aws_secret  = 'ff3key"""+ff3keypy+"""'""").collect()
  session.sql("""set ff3key  = (select getkeybyname_session($aws_secret, 'eu-central-1', '"""+token+"""')::string)""").collect()
  session.sql(""" insert into ff3_keys values ("""+ff3keypy+""",$ff3key) """).collect()
  session.sql("""set userkeysraw  = (select array_to_string((select array_agg(select object_construct(KEYID,KEYVALUE)) from ff3_keys), ''))""").collect()
  
  session.sql("""set userkeys  = (select replace($userkeysraw,'}{',','))""").collect()
  
  session.sql("""unset userkeysraw """).collect()
  session.sql("""unset ff3key """).collect()
  session.sql("""unset aws_secret """).collect()
  
  
  return 'Key added to available keys'