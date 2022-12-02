

create or replace secure function decrypt_ff3_float(ff3key string, ff3input float, ff3_user_keys string)
returns float
language python
runtime_version = 3.8
packages = ('pycryptodome')
imports = ('@python_libs_ff3/ff3.zip','@python_libs_ff3/decrypt_ff3_float.py')
HANDLER = 'decrypt_ff3_float.udf';

