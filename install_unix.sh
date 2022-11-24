git clone https://github.com/mysto/python-fpe.git
cd python-fpe
zip -r ff3.zip ff3/
mv ff3.zip ../
cd ..
rm -rf python-fpe
echo Account url?
read account
echo User??
read user


cp UDFs/DataTypes/Strings/1.Encrypt/1.Encrypt_PY/* .
cp UDFs/DataTypes/Numbers/1.Encrypt/1.Encrypt_PY/* .
cp UDFs/DataTypes/Floats/1.Encrypt/1.Encrypt_PY/* .

cp UDFs/DataTypes/Strings/2.Decrypt/2.Decrypt_PY/* .
cp UDFs/DataTypes/Numbers/2.Decrypt/2.Decrypt_PY/* .
cp UDFs/DataTypes/Floats/2.Decrypt/2.Decrypt_PY/* .

cp UDFs/DataTypes/Strings/3.Format/3.Format_PY/* .
cp UDFs/DataTypes/Numbers/3.Format/3.Format_PY/* .
cp UDFs/DataTypes/Floats/3.Format/3.Format_PY/* .


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


#snowsql -a $account -u $user -f install.sql -o output_file=upload_result.csv -o quiet=true -o friendly=false -o header=false -o output_format=csv

#rm *.py
#rm ff3.zip
