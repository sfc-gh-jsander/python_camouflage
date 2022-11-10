create or replace function decrypt_format_keys_test2(key string, userkeys string, token binary, jtwks binary, currentuser string, currentsession string, pubsessionkey string)
returns string
language python
runtime_version = 3.8
packages = ('pycryptodome','pyjwt','cryptography')
IMPORTS = ('@python_libs/unwrap_keys.py')
handler = 'unwrap_keys.udf'
