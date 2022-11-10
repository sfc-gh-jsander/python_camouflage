 create or replace masking policy ff3_decrypt_format_string_pass5 as (val string, keyid string)  returns string ->
  case
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_string_pass3(keyid, val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
     
    when  system$get_tag_on_current_column('decrypt_this')=''
     then decrypt_ff3_string_pass3(keyid, val, (select decrypt_format_keys_test2(keyid, $userkeys, $token, $jwtks, (select upper(select current_user())), (select current_session()), $pubkey)))
     
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_string_pass3(val)  
    
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('email')=''
     then format_email_ff3_string_pass3(val)
     
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('uspostal')=''
     then format_ff3_string_uspostal_pass3(val)
     
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('usphone')=''
     then format_ff3_string_usphone_pass3(val)
     
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('faker')=''
     then FAKE('en_US','name',null)::varchar
     
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('fake_email')=''
     then FAKE('en_US','email',null)::varchar
     
     

     
     
    when  current_role() in ('DATA_SC')
     then format_ff3_string_pass3(val) 
    when  current_role() in ('ACCOUNTADMIN') 
     then val
    else '** masked **'
  end;
  