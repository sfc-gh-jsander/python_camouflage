
create or replace masking policy encrypt_string_ff3 as (val string, keyid string)  returns string ->
  case
    when  current_role() in ('ACCOUNTADMIN') 
     then val
   when  current_role() in ('FF3_ENCRYPT')
     then encrypt_ff3_string(keyid,val,$userkeys)
    else '** masked **'
  end;

  
  