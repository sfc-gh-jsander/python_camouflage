

 create or replace masking policy decrypt_format_ff3_float as (val float, keyid string)  returns float ->
  case
    when  current_role() in ('FF3_DECRYPT')
     then decrypt_ff3_float(keyid,val,$userkeys)
    when  system$get_tag_on_current_column('decrypt_this')=''
      then decrypt_ff3_float(keyid,val,$userkeys)
    when  current_role() in ('FF3_DATA_SC') AND system$get_tag_on_current_column('sqljoin')=''
     then sqljoin_ff3_float(val)
    when  current_role() in ('FF3_DATA_SC')
     then format_ff3_float(val)
     when  current_role() in ('FF3_STANDARD') 
     then val
    else -999
  end;

  