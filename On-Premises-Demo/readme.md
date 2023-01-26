# Demo Python Camo Protection On-Prem

## What can Python Camo do on-prem?
The on-prem capability of Python Camo allows you to deal with the FF3 protected form of information stored in Snowflake in it's unprotected form in a location outside of Snowflake. "On-prem" is a shortcut to saying anyplace that isn't in Snowflake itself. So this may mean literally on-prem, but it could just as easily be in a VM or EC2 instance, etc. This demo walks through how to bring the information into your local environment, deal with it in the unprotected form, and never have that unprotected form transit to or from Snowflake or be stored in Snowflake. 

## Steps to run the demo

1. Install Python in your local environment if required.
2. Create a [virtualenv with Python](https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/#creating-a-virtual-environment).
3. Activate the virtualenv and install the dependencies listed in the included requirements.txt [via pip](https://pypi.org/project/pip/) (or your preferred method).
4. Open 2 terminal windows/tabs, naviagte to the "On-Premises-Demo" directory from the repo in both, and activate the Python virtualenv from step 2 in both of those sessions.
5. CD into the decrypt directory and in the first tab/window and adapt the Python code so it can authenticate to Snowflake (add credentials and connection info).
6. Launch the decrypt script in the first tab/window. You will see that all the rows of the encrypted table will be shown to you decrypted and a sum is calculated.
7. Login to your Snowflake account in the webUI and check the history or run a history SQL and verify that the SQL issued by the script only returned encrypted values within Snowflake.
8. Change to the other terminal tab. DO NOT CLOSE OR EXIT the first session tab with the decrypted info. You will need it in later steps. 
9. CD into the encrypt directory.
10. Again make sure the Python script has the information to be able to authenticate to your Snowflake account (add credentials and connection info).
11. Launch the Python script.
12. The script will create a row in the encrypted table and prompt you for the values to enter into the columns. Please make sure you enter strings for the string columns and integers for the integer columns.
13. One you have provided all the values the row is inserted into Snowflake encrypted. Meaning the script encrypted the values before inserting them into Snowflake. You will get a confirmation that his happened at the end of the script. 
14. Go back to your other terminal tab for the decryption script and run the decryption script again. You will see that your added row is there and the end with the values you provided.
15. Go into the webUI in Snowflake and check using the FF3-Standard role how the table appears. You will see that there are only encrypted values including the new ones you entered. 
16. Check the history in Snowflake for the insert SQL. You will see that only encrypted values were inserted.
