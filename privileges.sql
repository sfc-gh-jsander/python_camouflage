

grant usage on database ff3_test_db to role ff3_encrypt;
grant usage on schema ff3_test_schema to role ff3_encrypt;

grant usage on database ff3_test_db to role ff3_decrypt;
grant usage on schema ff3_test_schema to role ff3_decrypt;

grant usage on database ff3_test_db to role ff3_data_sc;
grant usage on schema ff3_test_schema to role ff3_data_sc;

grant usage on database ff3_test_db to role ff3_masked;
grant usage on schema ff3_test_schema to role ff3_masked;


grant all privileges on function encrypt_ff3_string(string, string, string) to role ff3_encrypt;
grant all privileges on function encrypt_ff3_string(string, string, string) to role ff3_masked;
grant all privileges on function decrypt_ff3_string(string, string, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_string(string, string, string) to role ff3_data_sc;
grant all privileges on function decrypt_ff3_string(string, string, string) to role ff3_masked;

grant all privileges on function format_ff3_string(string) to role ff3_data_sc;
grant all privileges on function sqljoin_ff3_string(string) to role ff3_data_sc;
grant all privileges on function format_email_ff3_string(string) to role ff3_data_sc;

grant all privileges on function format_ff3_string(string) to role ff3_masked;
grant all privileges on function sqljoin_ff3_string(string) to role ff3_masked;
grant all privileges on function format_email_ff3_string(string) to role ff3_masked;

grant all privileges on function format_ff3_string(string) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_string(string) to role ff3_decrypt;
grant all privileges on function format_email_ff3_string(string) to role ff3_decrypt;

grant all privileges on function format_ff3_string(string) to role ff3_masked;
grant all privileges on function sqljoin_ff3_string(string) to role ff3_masked;
grant all privileges on function format_email_ff3_string(string) to role ff3_masked;

grant all privileges on function encrypt_ff3_float(string, float, string) to role ff3_encrypt;
grant all privileges on function decrypt_ff3_float(string, float, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_float(string, float, string) to role ff3_data_sc;

grant all privileges on function encrypt_ff3_float(string, float, string) to role ff3_masked;
grant all privileges on function decrypt_ff3_float(string, float, string) to role ff3_masked;
grant all privileges on function decrypt_ff3_float(string, float, string) to role ff3_masked;

grant all privileges on function format_ff3_float(float) to role ff3_data_sc;
grant all privileges on function sqljoin_ff3_float(float) to role ff3_data_sc;

grant all privileges on function format_ff3_float(float) to role ff3_masked;
grant all privileges on function sqljoin_ff3_float(float) to role ff3_masked;

grant all privileges on function format_ff3_float(float) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_float(float) to role ff3_decrypt;

grant all privileges on function format_ff3_float(float) to role ff3_masked;
grant all privileges on function sqljoin_ff3_float(float) to role ff3_masked;

grant all privileges on function encrypt_ff3_number_decimal38_8(string, number, string) to role ff3_encrypt;
grant all privileges on function decrypt_ff3_number_decimal38_8(string, number, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_number_decimal38_8(string, number, string) to role ff3_data_sc;

grant all privileges on function encrypt_ff3_number_decimal38_8(string, number, string) to role ff3_masked;
grant all privileges on function decrypt_ff3_number_decimal38_8(string, number, string) to role ff3_masked;


grant all privileges on function format_ff3_number_decimal38_8(number) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role ff3_decrypt;

grant all privileges on function format_ff3_number_decimal38_8(number) to role ff3_masked;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role ff3_masked;

grant all privileges on function format_ff3_number_decimal38_8(number) to role ff3_data_sc;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role ff3_data_sc;

grant all privileges on function format_ff3_number_decimal38_8(number) to role ff3_masked;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role ff3_masked;


grant all privileges on function encrypt_ff3_number_integer(string, number, string) to role ff3_encrypt;
grant all privileges on function decrypt_ff3_number_integer(string, number, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_number_integer(string, number, string) to role ff3_data_sc;

grant all privileges on function encrypt_ff3_number_integer(string, number, string) to role ff3_masked;
grant all privileges on function decrypt_ff3_number_integer(string, number, string) to role ff3_masked;

grant all privileges on function partial_decrypt_ff3_number_1d_decimal_38_8(string, number, string) to role ff3_masked;
grant all privileges on function partial_decrypt_ff3_number_1d_decimal_38_8(string, number, string) to role ff3_decrypt;
grant all privileges on function partial_decrypt_ff3_number_1d_decimal_38_8(string, number, string) to role ff3_data_sc;

grant all privileges on function partial_decrypt_ff3_number_1d_integer(string, number, string) to role ff3_masked;
grant all privileges on function partial_decrypt_ff3_number_1d_integer(string, number, string) to role ff3_decrypt;
grant all privileges on function partial_decrypt_ff3_number_1d_integer(string, number, string) to role ff3_data_sc;



grant all privileges on function format_ff3_number_integer(number) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_number_integer(number) to role ff3_decrypt;
grant all privileges on function format_ff3_number_integer(number) to role ff3_masked;


grant all privileges on function format_ff3_number_partial_decimal38_8(number(38,8),integer) to role ff3_masked;
grant all privileges on function format_ff3_number_partial_integer(number(38,0),integer) to role ff3_masked;

grant all privileges on function format_ff3_number_partial_decimal38_8(number(38,8),integer) to role ff3_data_sc;
grant all privileges on function format_ff3_number_partial_integer(number(38,0),integer) to role ff3_data_sc;

grant all privileges on function format_ff3_number_partial_decimal38_8(number(38,8),integer) to role ff3_decrypt;
grant all privileges on function format_ff3_number_partial_integer(number(38,0),integer)to role ff3_decrypt;

grant all privileges on function format_ff3_number_integer(number) to role ff3_data_sc;
grant all privileges on function sqljoin_ff3_number_integer(number) to role ff3_data_sc;

grant all privileges on function format_ff3_number_integer(number) to role ff3_masked;
grant all privileges on function sqljoin_ff3_number_integer(number) to role ff3_masked;







grant all privileges on function format_ff3_string_uspostal(string) to role ff3_encrypt;
grant all privileges on function format_ff3_string_uspostal(string) to role ff3_decrypt;
grant all privileges on function format_ff3_string_uspostal(string) to role ff3_masked;
grant all privileges on function format_ff3_string_uspostal(string) to role ff3_data_sc;

grant all privileges on function format_ff3_string_usphone(string) to role ff3_encrypt;
grant all privileges on function format_ff3_string_usphone(string) to role ff3_decrypt;
grant all privileges on function format_ff3_string_usphone(string) to role ff3_masked;
grant all privileges on function format_ff3_string_usphone(string) to role ff3_data_sc;


