
create or replace function sqljoin_ff3_string(ff3input string)
returns string
language python
runtime_version = 3.8
imports = ('@python_libs/format_ff3_string_sqljoin.py')
HANDLER = 'format_ff3_string_sqljoin.udf';

