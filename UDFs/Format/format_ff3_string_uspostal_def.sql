create or replace function format_ff3_string_uspostal_pass3(ff3input string)
returns string
language python
runtime_version = 3.8
imports = ('@python_libs/format_ff3_string_uspostal.py')
HANDLER = 'format_ff3_string_uspostal.udf'