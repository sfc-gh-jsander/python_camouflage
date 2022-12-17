# Python Camouflage

Project Python Camouflage aims to give a working minimal viable product (MVP) for tokenization in Snowflake using Python. The problem this aims to solve is allowing customers to obfuscate (or “mask”) PII while at the same time not losing the ability to use that data in joins and other operations where the consistency of the data through operations is required. Python offers UDFs powered by Python libraries to achieve this using encryption. As an MVP, this is not meant to offer a complete solution to the problem. Rather, this is a framework that others can embrace and extend. 

If this sounds a lot like what our External Tokenization partners (like Protegrity and Voltage) deliver, that’s because it is basically the same approach - only without the external part. Of course, our partners don’t only deliver an MVP. They are offering battle tested, robust solutions for these issues. Those solutions come with costs - both financial and performance - that some may not wish to pay. There are also use cases where tokenization is desired, but since it’s not as business critical those costs may not make sense. So, it is even possible to imagine scenarios where both Project Python Camouflage and the partner may be used by the same customer but for different sets of data. 

This Python functions were developed specifically for us in Snowflake Python UDFs and masking polcies, but 
they also work fine for any other database that either execute Python code directly such as PostgreSQL or you can use the Python functions to execute before ingest or after select with any Python ORM such as PyDAL (one example is available in the On-Premises-Demo folder) or SQLAlchemy etc. 

## Use Cases

1) You want to hold your own key

2) You have compliance requirements for holding your own key and/or storing senstive data in Snowflake only in encrypted form

3) You want to protect senstive data from super users such as accountadmins and use encryption as another layer of protection. 

Data Clean Rooms can also easily benefit from this solution in order to join data on encrypted columns. 
The partners in a clean room only have to agree on the same key in order to be able to do the sql joins. 



## How to Use the Python Camouflage Demo

The steps are very simple from a technical point of view:

1. Clone this repo

2. Run the install script for your system (e.g. for MacOS related systems use install_macos.sh, for Linux use install_linux.sh. Windows support is on the way)

3. Follow the install script prompts carefully. Make sure SNOWSQL is installed and in your path!

    It will ask you for your Snowflake account URL, username and your users password. 
    Then it will generate and install.sql script and execute this with SnowfSQL against your account. 
    The script will create a database called ff3_test_db, a schema called ff3_test_schema, a warehouse called ff3_test_wh and various 
    roles such as ff3_standard (install role), ff3_encrypt (use this role to encrypt data), ff3_decrypt (use this role to decrypt data), ff3_data_sc (data scientist role, use this role to work with encrypted data), ff3_masked just a test role to show that also normal masking policies can be used if you use that role. (Accountadmin, Useradmin etc. needed, check the beginning of install.sql)

    It also creates the FF3 Python UDFs and the masking policies that can be used to assign them to tags when you go throug the demo.

4. After the FF3-1 install script is done, please login to your Snowflake account and create a new worksheet. Then go to the Demo_Scripts folder and copy and paste the FF3-1_Demo_Walkthrough_Health.sql script into your worksheet and go through it step by step. 

## Note: The Experience Of Working With Encrypted Data Can Be Tweaked!

Python Camouflage works based on tag based policies which can also take other tags into account to change the experience. 

For example sometimes when a data scientist wants to work with encrypted data the following can happen:

1) Token formatting or "cleansing" means that the encrypted data is read including some of the meta data that was attached to the encrypted data during encryption. This metadata makes it possible to for the token formatting UDF to format the encrypted data into something that resembles the original data e.g. decimals encrypted hat the same number of digits before and behind the comma.
However the drawback of this approach is, especially with numbers that have 1-3 digits, that there may be duplicates due to the nature how token cleansing works. 

If a data scientist needs to be sure that the value of an encrypted number for example is 100% unique, then she can enable the tag sqljoin='' on that column and the token cleaninsing UDF will only strip away the metadata and leave the encrypted data otherwise untouched. This means longer values to deal with, but definitly 100% accurate for sqljoins. 

Sample:
    alter table EXAMPLE modify column somenumber set tag sqljoin='';

2) If you encrypted email addresses, you may want your encrypted data also look like an email address. 
   There are two ways, or tags, to enable this. You either enable the tag email='' on that column which will transform encrypted data into a string with an @ in the middle and a .com at the end. 
   Or you enable the tag fake_email='' which will use the Python Faker library to generate fake email addresses and populate those in your column. 
   The Faker approach will generate new email addresses with every run, unless you make a copy of the data while you run an SQL on the encrypted data with the fake_email='' tag enabled. 

Samples:
   alter table EXAMPLE modify column email set tag email='';
   alter table EXAMPLE modify column email set tag fake_email='';

3) The uspostal='' tag on a column will convert encrypted data into a 5 digit number that looks like a US postal code

Sample:
    alter table EXAMPLE modify column postcode set tag uspostal='';

4) The usphone='' tag on a column will convert encrypted data into a 5 digit number that looks like a US phone number

Sample:
    alter table EXAMPLE modify column phone set tag usphone='';

6) The tag fuzzy='' DISABLES that the first number of a number type (integer or decimal) is decrypted. Decryption of the first number is currently enabled per default is it enables data scientist to run SQL comparisons and calculations that are not accurate, but can certainly be used to see viable trends. 

If you want that all numbers are encrypted enable the fuzzy='' tag on the column and the first number will not be decrypted. This will however take away the possiblity to make any meaningful comparisons or calculate any trends on encrypted data.  

The decryption of the first number is currently only available for the number data type. The float data type has all digits always encrypted as this function is not implemented yet for floats. 

Sample:
    alter table EXAMPLE modify column price set tag fuzzy='';

THIS DISABLES THE DECRYPTION OF THE FIRST DIGIT FOR THE NUMBER DATA TYPE


7) Enable the tag fake='' on a name column and it will popluate the colummn with fake Firstname Lastname values with every SQL run. 
   The advantage is that names like nicer, but they will be re-generated with every run. If you want fake names to be persistent you need to work with a copy of the table when the names were generated. 

Sample:
    alter table EXAMPLE modify column name set tag fake='';

8) Enable the tag decrypt_this='' on a column to decrypt it no matter which role you have. 
   ATTENTION THIS IS JUST FOR TESTING AND NEEDS TO BE REMOVED IN A REAL ENVIRONMENT. 
   The masking policies for decryption and formatting need to be ALTERED to NOT ALLOW THIS NORMALLY.  
   Again, THIS IS INTENTED FOR TESTING. 

   Sample:
    alter table EXAMPLE modify column name set tag decrypt_this='';


The last step is one where you may need some additional guidance, and you can feel free to reach out to the maintainters and contributors of this repo for that help. 

## How Metadata is Injected in the Encrypted Data Field to Make Token Formatting or "Cleansing" Possible

1) Numbers: 

Integer: 

The number of digits needed for padding +1 is the first digit in an encrypted field. 
The +1 is always added as the first digit as a leading digit can not be 0. This 0 would dissapear in Snowflake. 
Hence 0 padding means 1. 
The last 2 digits denote how many digits the original number had before it was encrypted. 
In the middle is the encrypted ciphertext of the number, which in itself is a number

So a number with 2 digits could look like this: 
(4 for padding because we need at least 5 digits in order to encrypt, so we are adding 3 digits but add the +1)

Numer 55 encrypted may look like this: 

4 (padding +1) 45434 (ciphertext) 02 (2 numbers were encrypted)  --> 

Result:

4543402

Decimal:

A decimal starts with a digit that denotes at which postion we find the comma in the original number that was encrypted. 
It is followed by the ciphertext (in this case also a number actually).
Afterwards we have a number that describes how many digits were before the comma and after that a number that describes how many digits were after the comma. 
The next digit encodes how long the orignal value was.
Finally the last 1 digit encodes how many digits long padding was that was needed +1.

Sample: 

55.78 is encrypted to: 

2 (position of comma counted from 0) 453545 (ciphertext) 2(numbers before comma) 2 (numnbers after comma) 4 (the orginal value was 4 digits long) 2 (padding was 1 +1)

--> 

Result: 
24535452242

This number is usually followed by a comma and the zeros of the defined decimal. 

Sample: Number type 38,8 

-->

Result:

24535452242.00000000

When a table has mixed integers and decimals e.g. 38,0 and 38,8 number types, the number encrypt UDF is able to detect if an integer of decimal is encrypted automatically and is running the appropiate encryption method. 

However integers will turn into decimals when those data types are mixed due to the application of tags with tag based policies with mixed number types. The policy will need to be set to the decimal type which is compatible with integer. The other way around will also work, but you will loose everything behind the comma. 

Integer numbers that turn into decimals will however be given a comma and trailing zeros. 

Its often better to assign the right masking policy that expects the correct data type of the right number column manually instead of relying on tag based policies in this case of mixed number types as it makes it easier to deal with and what to expect. 

But generally mixing of number types is possible, Python Camouflage will not crash. 


Floats: 

The encrypted float ciphertext (in this case also a number) will have one digit added in front which denotes the position of the comma before the value was encrypted. 

It is followed by the cipher(text). 

Afterwards added is the number of how many digits were before the comma and afterwards how many digits were after the comma of the original float number. Finally the last digit is the number of digits that were needed for padding +1. 

Thus a float number of: 

8.67

May be encrypted as follows:

1 (number of comma from 0), 4343545( ciphertext), 1(one number before comma),2 (one number after comma), 3 (how much padding was needed to reach 5 digits = 2 +1  )

--> 

Result: 

14343545123

Strings: 

FF3-1 can only encrypted a maximum of 30 characters at a time. 

Hence for larger strings in a column the characters have to be chunked in 30 character pieces. 

The way Python Camouflage does this is as follows:

This two leading characters are inserted at the beginning of an encrypted string (C stands for chunk):
[C
followed by the number of characters that were needed for padding. 
For a 4 character string its 1 to reach 5 characaters that are needed as a minimum for encryption. 

Thus for example:
[C1]

Followed by the chunked ciphertext
[C1]dfsgfdghsgtrt45w4

At the end you will find 3 digits reserved to conserve how many digits this chunk had before it was encrypted e.g. for 4
004

Finally the encrypted string will look like this for example.

[C1]dfsgfdghsgtrt45w4004

If there are more chunks, the will just be concatonated:

[C0]dfsgfdghsgtrt45w4030[C1]dfsgjhjhjfdhtrt45w4004


The data or token formater UDF can now use this metadata in order to turn a cryptic value into something more nice to look at and to work with. 


## A Word of Caution When Using Keys, Tweaks and Padding in Cleartext in a Snowflake Session

Python Camouflage is designed to work with AES256 keys in combination with a so called tweak of 56 bits and 5 characters of padding which need to be digits. 

For example a set of secrets that is used for this demo looks like this.

AES265 key, tweak 56 bits, padding -->

"7d1b1f5d48fed50a53c6c7afffc1b4ec3fc2865a97744b263e285676bc96c055", "CBD09280979564", "56854"

An encryption method is only ever as good as the key protection is. 

Currently this demo does not yet feature how to protect the keys in a Snowflake session. 

There are many approaches how this can be accomplished. 

At least 1 is already implemeted by me (Kevin Keller) as a demo, but it is not yet part of this repository. 

The flow is basically to keep those secrets in a secret manager such as Azure Keyvault, AWS KMS or Hashi Corp Vault and 
have some external functions call Azure Functions or AWS Lambda functions in order for a user in a Snowflake session 
to obtain an OAuth token via Device Code Flow. 

One the user has authenticated and ants to to obtain the OAuth token, the users Snowflake session will also be recored and the requested token including a session signature will be sent back to the user. 

With this signature and OAuth token, the user can now call a final external function to obtain one or all keys the user is allowed to obtain based on the users valid OAuth token and based on that the users Snowflake session really exists and can be validated online. 

The keys will then be sent to the user and stored either in a Snowflake stage or in a Snowflake SQL variable in a wrapped (AES encrypte form). 

An unwrap UDF will be nested in the Python Camouflage UDFs that unwraps the key material if the users token is valid and matches the current users Snowflake username and the Snowflake session is still the same as it was when the token was requested.

For good measure Python Camouflage itself should do another round of unwrapping of the unwrapped key material. 

But this is just one approach, there are many others that can be used. 

In any case, you need an approach to protect the keys!

And currently it is not part of the repo. 

I will add different approaches and demo code over time however.





## Background for Project Python Camouflage

The key to understanding this project is understanding the difference between “masking” and “tokenization.” These terms (as well as “obfuscation” and even sometimes “encryption”) are often used interchangeably. However, there is an important distinction between them when used in a more formal tone. Masking is something that is destructive. Take the example we use in the deep dive deck. We take North American phone numbers (e.g. (888) 235-8756) and remove the area code and first three digits of the number (e.g. (***) ***-8756). If you tried to join across tables that all had masked phone numbers like this, you would very likely have false matches where the last 4 digits of different phone numbers aligned - and this gets worse as the datasets get larger. This is the "destructive" part. It does not retain the information value of the data - that gets lost in masking. In contrast, the specific thing about a token is that it does not lose that information. The result is that if I take the tokenized version of these phone numbers and place them in several different tables, then I can still join on this value even though it’s not the “real” value of the data. Tokenization preserves the information value of data across multiple iterations. Since many identifiers are PII, this has a lot of value in analytical data sets. 

Another aspect of tokenization is that it will give you tokens that even appear to have the same qualities of the data which was tokenized. In other words, you can tokenize a number and get back a number of the same order of magnitude. You can tokenize an email and get back a string with the same format as an email (i.e. it will have valid email format, and @ in the middle, etc.). Confusingly, this is most commonly referred to as “format preserving encryption” - even though it is another form of what we are calling tokenization here with all the consistency benefits. 

Tokenization, especially the kind which preserves formats, is very complex. When you need to scale it to hundreds of millions of records and beyond, it becomes even more difficult. This is why it is most often accomplished using third party, commercially available solutions. Of course, it is still only technology. So there are libraries in many languages that provide the basic building blocks of tokenization. Project Python Camouflage takes advantage of pre-existing Python libraries which provide FF3-1 tokenization - specifically the “mysto” libraries. FF3-1 is based on AES encryption, the standard used by the entire tokenization industry. When Snowflake introduced Python UDFs, it provided Kevin Keller from the Security Field CTO team the chance to flex his programming muscles and apply these libraries to Snowflake’s new features to produce this MVP, which can now serve as a starting point for customers who wish to have the benefits of tokenization, do not wish to use a commercial solution or external functions, and are willing to roll up their sleeves a bit to get what they want. 

## Thanks

This project would not be possible without:

https://github.com/mysto/python-fpe
https://github.com/Legrandin/pycryptodome


