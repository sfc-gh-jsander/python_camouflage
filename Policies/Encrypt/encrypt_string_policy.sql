create or replace masking policy ff3_encrypt_string_pass5 as (val string, keyid string)  returns string ->
  case
    when  current_role() in ('ACCOUNTADMIN') 
     then val
   when  current_role() in ('FF3_ENCRYPT')
     then encrypt_ff3_string_pass3(keyid,val,(select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
    else '** masked **'
  end;
  