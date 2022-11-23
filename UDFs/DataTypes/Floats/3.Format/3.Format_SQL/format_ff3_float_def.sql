

create or replace function format_ff3_float_pass3(ff3input float)
returns float
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_float.py')
HANDLER = 'format_ff3_float.udf';

