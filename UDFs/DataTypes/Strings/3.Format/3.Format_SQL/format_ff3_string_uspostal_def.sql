
create or replace secure function format_ff3_string_uspostal(ff3input string)
returns string
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_string_uspostal.py')
HANDLER = 'format_ff3_string_uspostal.format_ff3_string_uspostal';

