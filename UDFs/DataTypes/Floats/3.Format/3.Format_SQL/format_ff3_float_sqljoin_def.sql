

create or replace secure function sqljoin_ff3_float(ff3input float)
returns float
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_float_sqljoin.py')
HANDLER = 'format_ff3_float_sqljoin.udf';


