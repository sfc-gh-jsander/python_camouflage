create or replace function FAKE(locale varchar,provider varchar,parameters variant)
returns variant
language python
volatile
runtime_version = '3.8'
packages = ('faker','simplejson')
IMPORTS = ('@python_libs/fake.py')
HANDLER = 'fake.fake'