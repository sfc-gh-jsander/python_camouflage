 /*
  create or replace masking policy ff3_encrypt_float_pass3 as (val float,keyid string)  returns float ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_float_pass3(keyid,val, $userkeys)
    else -999
  end;*/
  
  create or replace masking policy ff3_encrypt_float_pass5 as (val float,keyid string)  returns float ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_float_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
    else -999
  end;