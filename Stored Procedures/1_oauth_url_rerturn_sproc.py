from snowflake.snowpark import Session

def run(session):
  sql = """ select get_oauth_url_code('18e4c953-3423-4301-b050-562dbde643d2','https://kelleruserflow.snowflakeseclab42outlook.onmicrosoft.com/session:scope:POWERBIUSER','https://kelleruserflow.snowflakeseclab42outlook.onmicrosoft.com','https://login.microsoftonline.com/b3b06c45-b6f1-4d13-a720-8845b509b948/oauth2/devicecode')   """       
  get_tables = session.sql(sql).collect()[0][0]
  session.sql("""set dev_code = '"""+get_tables[21:228]+"""'""").collect()
  return get_tables[242:368]
