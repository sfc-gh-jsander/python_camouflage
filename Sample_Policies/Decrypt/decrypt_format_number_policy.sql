  
  
  create or replace masking policy decrypt_format_ff3_integer as (val integer, keyid string)  returns integer ->
  case
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_number($userkeys)
    when  system$get_tag_on_current_column('decrypt_this')=''
     then decrypt_ff3_number($userkeys)
    when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_number(val)
    when  current_role() in ('DATA_SC')
     then format_ff3_number(val)
    when  current_role() in ('ACCOUNTADMIN') 
     then val
    else -999
    end;



  create or replace masking policy decrypt_format_ff3_decimal_38_8 as (val number(38,8), keyid string)  returns number(38,8) ->
  case
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_number($userkeys)
    when  system$get_tag_on_current_column('decrypt_this')=''
     then decrypt_ff3_number($userkeys)
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_number(val)
     when  current_role() in ('DATA_SC') AND system$get_tag_on_current_column('fuzzy')=''
     then format_ff3_number(val)
    when  current_role() in ('DATA_SC')
     then format_ff3_number_partial(val, (select partial_decrypt_ff3_number_1d(keyid, val, $userkeys)::int))
    when  current_role() in ('ACCOUNTADMIN') 
     then val
    else -999
  end;



