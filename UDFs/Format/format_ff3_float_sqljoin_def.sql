create or replace function sqljoin_ff3_float_pass3(ff3input float)
returns float
language python
runtime_version = 3.8
imports = ('@python_libs/format_ff3_float_sqljoin.py')
HANDLER = 'format_ff3_float_sqljoin.udf'