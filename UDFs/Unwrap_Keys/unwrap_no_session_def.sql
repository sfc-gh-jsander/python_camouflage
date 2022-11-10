create or replace function decrypt_format_keys_test(key string, userkeys string, token binary, jtwks binary, currentuser string)
returns string
language python
runtime_version = 3.8
packages = ('pycryptodome','pyjwt','cryptography')
IMPORTS = ('@python_libs/unwrap_keys_no_session.py')
handler = 'unwrap_keys_no_session.udf'