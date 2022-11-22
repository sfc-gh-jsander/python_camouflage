
create or replace function encrypt_ff3_number_decimal38_8(ff3key string, ff3input number (38,8), ff3_user_keys string)
returns number(38,8)
language python
runtime_version = 3.8
packages = ('pycryptodome')
imports = ('@python_libs/ff3.zip','@python_libs/encrypt_ff3_number.py')
HANDLER = 'encrypt_ff3_number.udf';


create or replace function encrypt_ff3_number_integer(ff3key string, ff3input number (38,0), ff3_user_keys string)
returns number(38,0)
language python
runtime_version = 3.8
packages = ('pycryptodome')
imports = ('@python_libs/ff3.zip','@python_libs/encrypt_ff3_number.py')
HANDLER = 'encrypt_ff3_number.udf';

