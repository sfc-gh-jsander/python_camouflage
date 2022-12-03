from pydal import DAL, Field
from ff3 import FF3Cipher
import json
from decimal import *
import pandas as pd



def decrypt_number(ff3key, ff3input, userkeys):


    userkeys=userkeys.replace("'","")
    ff3_userkey_dict=json.loads(userkeys)
    userkeys_list=[]
    userkeyslist=ff3_userkey_dict[ff3key[3:]]
    
    ff3key=userkeyslist[0]
    tweak=userkeyslist[1]
    padding=userkeyslist[2]
    
    checkdecimal="." in str(ff3input)
    
    if checkdecimal==False :
        
        lengthpadding=str(ff3input)[0]
        lengthpadding=int(lengthpadding)
        lengthpadding=lengthpadding-1
    
        c = FF3Cipher(ff3key, tweak)

        
        ciphertext=str(ff3input)[1:]
        ciphertext=ciphertext[:-2]
        decrypted = c.decrypt(ciphertext)
        length=lengthpadding 
 
        if length==5:
            decrypted=decrypted[:-5]
        if length==4:
            decrypted=decrypted[:-4]
        if length==3:
            decrypted=decrypted[:-3]
        if length==2:
            decrypted=decrypted[:-2]
        if length==1:
            decrypted=decrypted[:-1]

    

        return int(decrypted)
        
    if checkdecimal==True :
    
        c = FF3Cipher(ff3key, tweak)

        value=str(ff3input)
        valuesplit=value.split('.')
        
        plaintext_org=valuesplit[0]
        length_pt_org=len(valuesplit[0])
        
        
        if length_pt_org==9:
            ciphertext=str(plaintext_org)[1:]
            ciphertext=ciphertext[:-2]
            decrypted = c.decrypt(ciphertext)
            
            return Decimal(decrypted)
        
        else:    
            plaintext_org=plaintext_org[1:]
            plaintext_org=plaintext_org[:-3]

            decrypted = c.decrypt(str(plaintext_org))
            value=valuesplit[0]
            lengthpadding=int(value[-1])
            commais=int(value[0])

     
            if lengthpadding==1:
                decrypted=decrypted[:commais] + '.' + decrypted[commais:]
            else:
                decrypted=decrypted[:-lengthpadding+1]
                decrypted=decrypted[:commais] + '.' + decrypted[commais:]


            return Decimal(decrypted)


def isDivisibleBy2(num):
    if (num % 2) == 0:
        return True
    else:
        return False


def decrypt_string(ff3keyinput, ff3input, userkeys):

    
    
    userkeys=userkeys.replace("'","")
    ff3_userkey_dict=json.loads(userkeys)
    userkeys_list=[]
    userkeyslist=ff3_userkey_dict[ff3keyinput[3:]]
    
    key=userkeyslist[0]
    tweak=userkeyslist[1]
    padding=userkeyslist[2]
    
   

    result=''
    length=len(ff3input)


    c = FF3Cipher.withCustomAlphabet(key, tweak, """0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-().@ '""")

    encrypted_value_list=ff3input.split('[C')
    decrypted_value_list=[]
    encryptedvalue=''

    for encrypted_value in encrypted_value_list[1:-1]:
         paddinglength=int(encrypted_value[0])
         encrypted_value=encrypted_value[2:]
         decrypted = c.decrypt(encrypted_value)
         if paddinglength != 0:
            decrypted=decrypted[:-paddinglength]
         decrypted_value_list.append(decrypted)
         encryptedvalue=encryptedvalue+encrypted_value
      

    for decrypted_value in decrypted_value_list:
             result=result+decrypted_value


   


    lastvalue=encrypted_value_list[-1]
    lastvalue = lastvalue[:-3]
    paddinglength=int(lastvalue[0])
    lastvalue = lastvalue[2:]
    lastdecrypt=c.decrypt(lastvalue)
    if paddinglength != 0:
        lastdecrypt=lastdecrypt[:-int(paddinglength)]
    result=result+lastdecrypt
    return result
   





try:

   
    db = DAL('snowflake://USERNAME:PASSWORD:ff3_standard:ff3_test_wh:ACCOUNTURL@ff3_test_schema/ff3_test_db',folder='db', fake_migrate=True, migrate=False)


    userkeys=''''{
    "678901": ["7d1b1f5d48fed50a53c6c7afffc1b4ec3fc2865a97744b263e285676bc96c055", "CBD09280979564", "56854"],
    "678902": ["c2051e1a93c3fd7f0e4f20b4fb4f7889aeb8d6fd10f68551af659323f42961e9", "7036604882667B", "85567"]
}'''

    ff3keyinput='KEY678901'

    db.define_table('insurance_source1_target1',
                Field('age','integer'),
                Field('sex'),
                Field('bmi','integer'),
                Field('children','integer'),
                Field('smoker'),
                Field('region'),
                Field('charges','integer') ,
                primarykey=['bmi'] )        
        

    

 
    db.insurance_source1_target1.age.filter_out = lambda value : decrypt_number(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.sex.filter_out = lambda value : decrypt_string(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.bmi.filter_out = lambda value : decrypt_number(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.children.filter_out = lambda value : decrypt_number(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.smoker.filter_out = lambda value : decrypt_string(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.region.filter_out = lambda value : decrypt_string(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.charges.filter_out = lambda value : decrypt_number(ff3keyinput,value,userkeys)
    
    rows=db().select(db.insurance_source1_target1.ALL)


    data = []
    
    for row in rows:
        data.append([row.age,row.sex,row.bmi,row.children,row.smoker,row.region,row.charges]) 

    
    

finally:

    if db:
        db.close() 
        df = pd.DataFrame(data,columns=['Age','Sex','BMI','Children','Smoker','Region','Charges'])
        print (df)
