
create or replace masking policy ff3_encrypt_float as (val float,keyid string)  returns float ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_float(keyid,val, $userkeys)
    else -999
  end;

  