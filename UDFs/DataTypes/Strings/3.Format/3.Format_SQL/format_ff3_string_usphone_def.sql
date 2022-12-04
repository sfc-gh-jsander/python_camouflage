
create or replace secure function format_ff3_string_usphone(ff3input string)
returns string
language python
runtime_version = 3.8
imports = ('@python_libs_ff3/format_ff3_string_usphone.py')
HANDLER = 'format_ff3_string_usphone.format_ff3_string_usphone';

