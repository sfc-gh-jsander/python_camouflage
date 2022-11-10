create or replace function format_ff3_number_partial (ff3input number(38,8),firstdigit integer)
returns number(38,8)
language python
runtime_version = 3.8
imports = ('@python_libs/format_ff3_number_partial_1d.py')
HANDLER = 'format_ff3_number_partial_1d.udf'