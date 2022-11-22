git clone https://github.com/mysto/python-fpe.git
cd python-fpe
zip -r ff3.zip ff3/
mv ff3.zip ../
cd ..
rm -rf python-fpe
snowsql -a $account -u $user -f upload.sql -o output_file=upload_result.csv -o quiet=true -o friendly=false -o header=false -o output_format=csv
cat UDFs/DataTypes/Strings/1.Encrypt/1.Encrypt_SQL/encrypt_ff3_string_def.sql >> install.sql
cat UDFs/DataTypes/Numbers/1.Encrypt/1.Encrypt_SQL/encrypt_ff3_number_def.sql >> install.sql
cat UDFs/DataTypes/Floats/1.Encrypt/1.Encrypt_SQL/encrypt_ff3_float_def.sql >> install.sql
