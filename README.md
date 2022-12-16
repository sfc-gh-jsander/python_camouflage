# Python Camouflage

Project Python Camouflage aims to give a working minimal viable product (MVP) for tokenization in Snowflake using Python. The problem this aims to solve is allowing customers to obfuscate (or “mask”) PII while at the same time not losing the ability to use that data in joins and other operations where the consistency of the data through operations is required. Python offers UDFs powered by Python libraries to achieve this using encryption. As an MVP, this is not meant to offer a complete solution to the problem. Rather, this is a framework that others can embrace and extend. 

If this sounds a lot like what our External Tokenization partners (like Protegrity and Voltage) deliver, that’s because it is basically the same approach - only without the external part. Of course, our partners don’t only deliver an MVP. They are offering battle tested, robust solutions for these issues. Those solutions come with costs - both financial and performance - that some may not wish to pay. There are also use cases where tokenization is desired, but since it’s not as business critical those costs may not make sense. So, it is even possible to imagine scenarios where both Project Python Camouflage and the partner may be used by the same customer but for different sets of data. 

## How to Use the Snowvation Python Camo Demo

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

Note: The experience of working with encrypted data can be tweaked!

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

THIS DISABLES THE DECRYPTION OF THE FIRST DIGIT


7) Enable the tag fake='' on a name column and it will popluate the colummn with fake Firstname Lastname values with every SQL run. 
   The advantage is that names like nicer, but they will be re-generated with every run. If you want fake names to be persistent you need to work with a copy of the table when the names were generated. 

Sample:
    alter table EXAMPLE modify column name set tag fake='';


The last step is one where you may need some additional guidance, and you can feel free to reach out to the maintainters and contributors of this repo for that help. 

## Background for Project Python Camouflage

The key to understanding this project is understanding the difference between “masking” and “tokenization.” These terms (as well as “obfuscation” and even sometimes “encryption”) are often used interchangeably. However, there is an important distinction between them when used in a more formal tone. Masking is something that is destructive. Take the example we use in the deep dive deck. We take North American phone numbers (e.g. (888) 235-8756) and remove the area code and first three digits of the number (e.g. (***) ***-8756). If you tried to join across tables that all had masked phone numbers like this, you would very likely have false matches where the last 4 digits of different phone numbers aligned - and this gets worse as the datasets get larger. This is the "destructive" part. It does not retain the information value of the data - that gets lost in masking. In contrast, the specific thing about a token is that it does not lose that information. The result is that if I take the tokenized version of these phone numbers and place them in several different tables, then I can still join on this value even though it’s not the “real” value of the data. Tokenization preserves the information value of data across multiple iterations. Since many identifiers are PII, this has a lot of value in analytical data sets. 

Another aspect of tokenization is that it will give you tokens that even appear to have the same qualities of the data which was tokenized. In other words, you can tokenize a number and get back a number of the same order of magnitude. You can tokenize an email and get back a string with the same format as an email (i.e. it will have valid email format, and @ in the middle, etc.). Confusingly, this is most commonly referred to as “format preserving encryption” - even though it is another form of what we are calling tokenization here with all the consistency benefits. 

Tokenization, especially the kind which preserves formats, is very complex. When you need to scale it to hundreds of millions of records and beyond, it becomes even more difficult. This is why it is most often accomplished using third party, commercially available solutions. Of course, it is still only technology. So there are libraries in many languages that provide the basic building blocks of tokenization. Project Python Camouflage takes advantage of pre-existing Python libraries which provide FF3-1 tokenization - specifically the “mysto” libraries. FF3-1 is based on AES encryption, the standard used by the entire tokenization industry. When Snowflake introduced Python UDFs, it provided Kevin Keller from the Security Field CTO team the chance to flex his programming muscles and apply these libraries to Snowflake’s new features to produce this MVP, which can now serve as a starting point for customers who wish to have the benefits of tokenization, do not wish to use a commercial solution or external functions, and are willing to roll up their sleeves a bit to get what they want. 

