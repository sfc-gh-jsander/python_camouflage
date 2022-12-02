
import json
from ff3 import FF3Cipher


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
    #ff3_key_dict=json.loads(ff3key)
    #keyid = str(list(ff3_key_dict.keys())[0])
    #ff3_key=ff3_key_dict[keyid][0]
    #ff3_tweak=ff3_key_dict[keyid][1]
    #ff3_padding=ff3_key_dict[keyid][2]

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
   