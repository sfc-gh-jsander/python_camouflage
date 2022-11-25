
create or replace masking policy encrypt_float_ff3 as (val float,keyid string)  returns float ->
  case
   when  current_role() in ('FF3_STANDARD') 
     then val
    when  current_role() in ('FF3_ENCRYPT') 
     then encrypt_ff3_float(keyid,val, $userkeys)
    else -999
  end;

  