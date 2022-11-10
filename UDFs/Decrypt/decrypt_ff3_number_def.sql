create or replace function decrypt_ff3_number_pass3(ff3key string, ff3input number(38,8), ff3_user_keys string)
returns number(38,8)
language python
runtime_version = 3.8
packages = ('pycryptodome')
imports = ('@python_libs/ff3.zip','@python_libs/decrypt_ff3_number.py')
HANDLER = 'decrypt_ff3_number.udf'