create or replace function format_ff3_number_partial_decimal38_8 (ff3input number(38,8),firstdigit integer)
returns number(38,8)
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_number_partial_1d.py')
HANDLER = 'format_ff3_number_partial_1d.udf'


create or replace function format_ff3_number_partial_integer (ff3input number(38,0),firstdigit integer)
returns number(38,0)
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_number_partial_1d.py')
HANDLER = 'format_ff3_number_partial_1d.udf'