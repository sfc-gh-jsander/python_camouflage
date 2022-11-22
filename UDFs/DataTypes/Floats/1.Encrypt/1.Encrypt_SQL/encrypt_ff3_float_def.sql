

create or replace function encrypt_ff3_float(ff3key string, ff3input float, ff3_user_keys string)
returns float
language python
runtime_version = 3.8
packages = ('pycryptodome')
imports = ('@python_libs/ff3.zip','@python_libs/encrypt_ff3_float.py')
HANDLER = 'encrypt_ff3_float.udf';


