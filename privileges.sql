

grant all privileges on function encrypt_ff3_string(string, string, string) to role ff3_encrypt;
grant all privileges on function encrypt_ff3_string(string, string, string) to role masked;
grant all privileges on function decrypt_ff3_string(string, string, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_string(string, string, string) to role data_sc;
grant all privileges on function decrypt_ff3_string(string, string, string) to role masked;

grant all privileges on function format_ff3_string(string) to role data_sc;
grant all privileges on function sqljoin_ff3_string(string) to role data_sc;
grant all privileges on function format_email_ff3_string(string) to role data_sc;

grant all privileges on function format_ff3_string(string) to role masked;
grant all privileges on function sqljoin_ff3_string(string) to role masked;
grant all privileges on function format_email_ff3_string(string) to role masked;

grant all privileges on function format_ff3_string(string) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_string(string) to role ff3_decrypt;
grant all privileges on function format_email_ff3_string(string) to role ff3_decrypt;

grant all privileges on function format_ff3_string(string) to role masked;
grant all privileges on function sqljoin_ff3_string(string) to role masked;
grant all privileges on function format_email_ff3_string(string) to role masked;

grant all privileges on function encrypt_ff3_float(string, float, string) to role ff3_encrypt;
grant all privileges on function decrypt_ff3_float(string, float, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_float(string, float, string) to role data_sc;

grant all privileges on function encrypt_ff3_float(string, float, string) to role masked;
grant all privileges on function decrypt_ff3_float(string, float, string) to role masked;
grant all privileges on function decrypt_ff3_float(string, float, string) to role masked;

grant all privileges on function format_ff3_float(float) to role data_sc;
grant all privileges on function sqljoin_ff3_float(float) to role data_sc;

grant all privileges on function format_ff3_float(float) to role masked;
grant all privileges on function sqljoin_ff3_float(float) to role masked;

grant all privileges on function format_ff3_float(float) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_float(float) to role ff3_decrypt;

grant all privileges on function format_ff3_float(float) to role masked;
grant all privileges on function sqljoin_ff3_float(float) to role masked;

grant all privileges on function encrypt_ff3_number_decimal38_8(string, number, string) to role ff3_encrypt;
grant all privileges on function decrypt_ff3_number_decimal38_8(string, number, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_number_decimal38_8(string, number, string) to role data_sc;

grant all privileges on function encrypt_ff3_number_decimal38_8(string, number, string) to role masked;
grant all privileges on function decrypt_ff3_number_decimal38_8(string, number, string) to role masked;


grant all privileges on function format_ff3_number_decimal38_8(number) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role ff3_decrypt;

grant all privileges on function format_ff3_number_decimal38_8(number) to role masked;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role masked;

grant all privileges on function format_ff3_number_decimal38_8(number) to role data_sc;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role data_sc;

grant all privileges on function format_ff3_number_decimal38_8(number) to role masked;
grant all privileges on function sqljoin_ff3_number_decimal38_8(number) to role masked;


grant all privileges on function encrypt_ff3_number_integer(string, number, string) to role ff3_encrypt;
grant all privileges on function decrypt_ff3_number_integer(string, number, string) to role ff3_decrypt;
grant all privileges on function decrypt_ff3_number_integer(string, number, string) to role data_sc;

grant all privileges on function encrypt_ff3_number_integer(string, number, string) to role masked;
grant all privileges on function decrypt_ff3_number_integer(string, number, string) to role masked;

grant all privileges on function partial_decrypt_ff3_number_1d_decimal_38_8(string, number, string) to role masked;
grant all privileges on function partial_decrypt_ff3_number_1d_decimal_38_8(string, number, string) to role ff3_decrypt;
grant all privileges on function partial_decrypt_ff3_number_1d_decimal_38_8(string, number, string) to role data_sc;

grant all privileges on function partial_decrypt_ff3_number_1d_integer(string, number, string) to role masked;
grant all privileges on function partial_decrypt_ff3_number_1d_integer(string, number, string) to role ff3_decrypt;
grant all privileges on function partial_decrypt_ff3_number_1d_integer(string, number, string) to role data_sc;



grant all privileges on function format_ff3_number_integer(number) to role ff3_decrypt;
grant all privileges on function sqljoin_ff3_number_integer(number) to role ff3_decrypt;
grant all privileges on function format_ff3_number_integer(number) to role masked;


grant all privileges on function format_ff3_number_partial_decimal38_8(number(38,8),integer) to role masked;
grant all privileges on function format_ff3_number_partial_integer(number(38,0),integer) to role masked;

grant all privileges on function format_ff3_number_partial_decimal38_8(number(38,8),integer) to role data_sc;
grant all privileges on function format_ff3_number_partial_integer(number(38,0),integer) to role data_sc;

grant all privileges on function format_ff3_number_partial_decimal38_8(number(38,8),integer) to role ff3_decrypt;
grant all privileges on function format_ff3_number_partial_integer(number(38,0),integer)to role ff3_decrypt;

grant all privileges on function format_ff3_number_integer(number) to role data_sc;
grant all privileges on function sqljoin_ff3_number_integer(number) to role data_sc;

grant all privileges on function format_ff3_number_integer(number) to role masked;
grant all privileges on function sqljoin_ff3_number_integer(number) to role masked;







grant all privileges on function format_ff3_string_uspostal(string) to role ff3_encrypt;
grant all privileges on function format_ff3_string_uspostal(string) to role ff3_decrypt;
grant all privileges on function format_ff3_string_uspostal(string) to role masked;
grant all privileges on function format_ff3_string_uspostal(string) to role data_sc;

grant all privileges on function format_ff3_string_usphone(string) to role ff3_encrypt;
grant all privileges on function format_ff3_string_usphone(string) to role ff3_decrypt;
grant all privileges on function format_ff3_string_usphone(string) to role masked;
grant all privileges on function format_ff3_string_usphone(string) to role data_sc;


