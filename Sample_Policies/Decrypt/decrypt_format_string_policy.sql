 
 
 create or replace masking policy decrypt_format_ff3_string as (val string, keyid string)  returns string ->
  case
    
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_string(keyid, val,$userkeys)
     
    when  system$get_tag_on_current_column('decrypt_this')=''
     then decrypt_ff3_string(keyid, val,$userkeys)
     
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_string(val)  
    
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('email')=''
     then format_email_ff3_string(val)
     
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('uspostal')=''
     then format_ff3_string_uspostal(val)
     
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('usphone')=''
     then format_ff3_string_usphone(val)
     
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('faker')=''
     then FAKE('en_US','name',null)::varchar
     
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('fake_email')=''
     then FAKE('en_US','email',null)::varchar
     
    when  current_role() in ('DATA_SC')
     then format_ff3_string(val) 
    
    when  current_role() in ('ACCOUNTADMIN') 
     then val
    
    else '** masked **'
  
  end;
  

  