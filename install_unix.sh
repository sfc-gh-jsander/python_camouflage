#!/bin/bash

# start by cloning the FF3 libraries and creating the zip file to upload
git clone https://github.com/mysto/python-fpe.git
cd python-fpe
# should we test for zip and not assume?
zip -r ff3.zip ff3/
mv ff3.zip ../
cd ..
rm -rf python-fpe

# preserve the original install SQL script
cp install.sql install.sql.bak

# gather the user's details for their ENV
echo Enter your account identifier as you would format it to use with SnowSQL.
echo For example, if you have an account URL "myorg-acct.snowflakecomputing.com"
echo then you would enter "myorg-acct" as the account identifier \(or everything
echo before the ".snowflakecomputing.com"\)
echo -n Enter your Snowflake account identifier: 
read account
echo Enter a user with admin rights, using the same name you would use to authenticate
echo when connecting with SnowSQL.
echo -n Enter your user\'s login name: 
read user

# prepare files for install
cp UDFs/DataTypes/Strings/1.Encrypt/1.Encrypt_PY/* .
cp UDFs/DataTypes/Numbers/1.Encrypt/1.Encrypt_PY/* .
cp UDFs/DataTypes/Floats/1.Encrypt/1.Encrypt_PY/* .

cp UDFs/DataTypes/Strings/2.Decrypt/2.Decrypt_PY/* .
cp UDFs/DataTypes/Numbers/2.Decrypt/2.Decrypt_PY/* .
cp UDFs/DataTypes/Floats/2.Decrypt/2.Decrypt_PY/* .

cp UDFs/DataTypes/Strings/3.Format/3.Format_PY/* .
cp UDFs/DataTypes/Numbers/3.Format/3.Format_PY/* .
cp UDFs/DataTypes/Floats/3.Format/3.Format_PY/* .

# insert username into the install script
sed -i OLD "s/UsErNaMePlAcEhOlDeR/$user/g" install.sql

# build the install SQL from the parts
cat UDFs/DataTypes/Strings/1.Encrypt/1.Encrypt_SQL/*.sql >> install.sql
cat UDFs/DataTypes/Numbers/1.Encrypt/1.Encrypt_SQL/*.sql >> install.sql
cat UDFs/DataTypes/Floats/1.Encrypt/1.Encrypt_SQL/*.sql >> install.sql

cat UDFs/DataTypes/Strings/2.Decrypt/2.Decrypt_SQL/*.sql >> install.sql
cat UDFs/DataTypes/Numbers/2.Decrypt/2.Decrypt_SQL/*.sql >> install.sql
cat UDFs/DataTypes/Floats/2.Decrypt/2.Decrypt_SQL/*.sql >> install.sql

cat UDFs/DataTypes/Strings/3.Format/3.Format_SQL/*.sql >> install.sql
cat UDFs/DataTypes/Numbers/3.Format/3.Format_SQL/*.sql >> install.sql
cat UDFs/DataTypes/Floats/3.Format/3.Format_SQL/*.sql >> install.sql

cat Faker/*.sql >> install.sql

cat privileges.sql >> install.sql

cat Sample_Policies/Encrypt/*.sql >> install.sql

cat Sample_Policies/Decrypt/*.sql >> install.sql

# testing version
#snowsql -a $account -u $user -f install.sql -o output_file=upload_result.csv -o quiet=true -o friendly=false -o header=false -o output_format=csv

# run the install SQL script on the target Snowflake account
snowsql -a $account -u $user -f install.sql   -o friendly=true

# clean up
rm *.py
rm ff3.zip
cp install.sql.bak install.sql
rm install.sql.bak 
rm install.sqlOLD
