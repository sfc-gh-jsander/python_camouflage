create or replace function format_ff3_number_pass3(ff3input number(38,8))
returns number(38,8)
language python
runtime_version = 3.8
imports = ('@python_libs/format_ff3_number.py')
HANDLER = 'format_ff3_number.udf'