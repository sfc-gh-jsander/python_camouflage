  create or replace masking policy ff3_decrypt_format_pass5_integer as (val integer, keyid string)  returns integer ->
  case
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_number_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
    when  system$get_tag_on_current_column('decrypt_this')=''
     then decrypt_ff3_number_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey))) 
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_number_pass3(val)
    when  current_role() in ('DATA_SC')
     then format_ff3_number_pass3(val)
    when  current_role() in ('ACCOUNTADMIN') 
     then val
    else -999
    end;

    create or replace masking policy ff3_decrypt_format_pass5_decimal as (val number(38,8), keyid string)  returns number(38,8) ->
  case
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_number_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
    when  system$get_tag_on_current_column('decrypt_this')=''
     then decrypt_ff3_number_pass3(keyid,val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey))) 
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_number_pass3(val)
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('fuzzy')=''
     then format_ff3_number_pass3(val)
    when  current_role() in ('DATA_SC')
     then format_ff3_number_partial(val, (select partial_decrypt_ff3_number_1d(keyid, val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))::int))
    when  current_role() in ('ACCOUNTADMIN') 
     then val
    else -999
  end;

  --format_ff3_number_pass3(val)