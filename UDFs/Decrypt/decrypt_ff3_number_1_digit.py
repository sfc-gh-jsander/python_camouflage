from ff3 import FF3Cipher
import json
from decimal import *



def udf(ff3key, ff3input, userkeys):


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
            return int(ciphertext[1])
        if length==4:
            decrypted=decrypted[:-4]
        if length==3:
            decrypted=decrypted[:-3]
        if length==2:
            decrypted=decrypted[:-2]
        if length==1:
            decrypted=decrypted[:-1]

    

        return int(decrypted[:1])
        
    if checkdecimal==True :
    
        c = FF3Cipher(ff3key, tweak)

        value=str(ff3input)
        valuesplit=value.split('.')
        
        plaintext_org=valuesplit[0]
        length_pt_org=len(valuesplit[0])
        
        #if its a zero....return 1, but could also be something else
        if length_pt_org==9:
            ciphertext=str(plaintext_org)[1:]
            ciphertext=ciphertext[:-2]
            decrypted = c.decrypt(ciphertext)
            
            return Decimal(1)
        
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
                
            decsplit=decrypted.split('.')    
            if  len(decsplit[0])==1:
                return Decimal (value[4])
            else:
                return Decimal(decrypted[:1])
            
