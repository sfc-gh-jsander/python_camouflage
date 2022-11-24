

create or replace function sqljoin_ff3_number_decimal38_8(ff3input number(38,8))
returns number(38,8)
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_number_sqljoin.py')
HANDLER = 'format_ff3_number_sqljoin.udf';


create or replace function sqljoin_ff3_number_integer(ff3input number(38,0))
returns number(38,0)
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_number_sqljoin.py')
HANDLER = 'format_ff3_number_sqljoin.udf';

