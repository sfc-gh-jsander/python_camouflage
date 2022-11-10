create or replace function decompress_zlib(jwtskeys binary)
returns string
language python
runtime_version = 3.8
IMPORTS = ('@python_libs/decompress_zlib.py')
HANDLER = 'decompress_zlib.udf'
;