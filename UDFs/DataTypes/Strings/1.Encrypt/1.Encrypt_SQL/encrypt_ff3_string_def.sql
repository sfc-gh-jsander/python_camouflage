
create or replace function encrypt_ff3_string(ff3key string, ff3input string, ff3_user_keys string)
returns string
language python
runtime_version = 3.8
packages = ('pycryptodome')
imports = ('@python_libs_ff3/ff3.zip','@python_libs_ff3/encrypt_ff3_string.py')
HANDLER = 'encrypt_ff3_string.udf';

