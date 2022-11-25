
create or replace masking policy encrypt_number_ff3_integer as (val integer,keyid string)  returns integer ->
  case
    when  current_role() in ('FF3_STANDARD') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_number_integer(keyid,val, $userkeys)
    else -999
  end;

  

 create or replace masking policy encrypt_number_ff3_decimal_38_8 as (val number(38,8),keyid string)  returns number(38,8) ->
  case
    when  current_role() in ('FF3_STANDARD') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_number_decimal38_8(keyid,val, $userkeys)
    else -999
  end;


  
  