from ff3 import FF3Cipher
import json
import re
from decimal import *



def encrypt_number(ff3key, ff3input, userkeys):

    userkeys=userkeys.replace("'","")
    ff3_userkey_dict=json.loads(userkeys)
    userkeys_list=[]
    userkeyslist=ff3_userkey_dict[ff3key[3:]]
    
    ff3key=userkeyslist[0]
    tweak=userkeyslist[1]
    padding=userkeyslist[2]
    
    
    checkdecimal="." in str(ff3input)
    
    
    
    if checkdecimal==False :
    
        length=len(str(ff3input))
        lengthpadding=0

        c = FF3Cipher(ff3key, tweak)
    

        if length>=6:
            plaintext=str(ff3input)
            lengthpadding=1

        if length==5:
            plaintext=str(ff3input)+padding[0:1]
            lengthpadding=2

        if length==4:
            plaintext=str(ff3input)+padding[0:2]
            lengthpadding=3

        if length==3:
            plaintext=str(ff3input)+padding[0:3]
            lengthpadding=4

        if length==2:
            plaintext=str(ff3input)+padding[0:4]
            lengthpadding=5

        if length==1:
            plaintext=str(ff3input)+padding
            lengthpadding=6
            
        if ff3input==0:
            plaintext='000000'
            lengthpadding=6

        ciphertext = c.encrypt(plaintext)

        
        if length<10:
           ciphertext=ciphertext+"0"+str(length)
        else:
            ciphertext=ciphertext+str(length)


        ciphertext=str(lengthpadding)+ciphertext
        return int(ciphertext)
        
        
        
    if checkdecimal==True :
    
       

        c = FF3Cipher(ff3key, tweak)

        value = str(ff3input)
        lengthvalue=len(value)

        if lengthvalue==3:
            ff3_padding=ff3_padding[0:4]
        if lengthvalue==4:
            ff3_padding=ff3_padding[0:3]
        if lengthvalue==5:
            ff3_padding=ff3_padding[0:2]
        if lengthvalue==6:
            ff3_padding=ff3_padding[0:1]
        if lengthvalue >= 7:
            ff3_padding=None

        plaintext_org=value
        commais=value.find('.')
        commais=commais
        detect_float=plaintext_org.split('.')



        plaintext =  value
        plaintext=plaintext.replace('.','')
        if ff3_padding !=None:
            lengthpadding=len(ff3_padding)+1
            ciphertext = c.encrypt(plaintext+ff3_padding)
        else:
            lengthpadding=1
            ciphertext = c.encrypt(plaintext)

        beforecomma=len(detect_float[0])
        aftercomma=len(detect_float[1])
        
        
        
        aftercommacheck=value
       
        
        mo = re.search('(?:(\.\d*?[1-9]+)|\.)0*$', aftercommacheck)
        
        if mo.group(1) !=  None:
    
            aftercommacheck=mo.group(1).replace('.','')
            aftercomma=len(aftercommacheck)
        
        else:
            aftercomma=0
            
            
        
        
        
        
   
        

        endresult=ciphertext

        endresult=str(commais)+endresult+str(beforecomma)+str(aftercomma)+str(lengthpadding)
        


        
        return Decimal(endresult)
