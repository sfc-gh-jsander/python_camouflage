/*create or replace masking policy ff3_encrypt_number_pass3_integer as (val integer,keyid string)  returns integer ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_number_pass3(keyid,val, $userkeys)
    else -999
  end;*/


create or replace masking policy ff3_encrypt_number_pass5_integer as (val integer,keyid string)  returns integer ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_number_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
    else -999
  end;
  
  /*

 create or replace masking policy ff3_encrypt_number_pass3_decimal as (val number(38,8),keyid string)  returns number(38,8) ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_number_pass3(keyid,val, $userkeys)
    else -999
  end;*/
  
  create or replace masking policy ff3_encrypt_number_pass5_decimal as (val number(38,8),keyid string)  returns number(38,8) ->
  case
   when  current_role() in ('ACCOUNTADMIN') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_number_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
    else -999
  end;