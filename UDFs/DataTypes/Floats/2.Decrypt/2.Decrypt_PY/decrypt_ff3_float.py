from ff3 import FF3Cipher
import json

def decrypt_float(ff3key_input, ff3_input, userkeys):

    userkeys=userkeys.replace("'","")
    ff3_userkey_dict=json.loads(userkeys)
    userkeys_list=[]
    userkeyslist=ff3_userkey_dict[ff3key_input[3:]]
    
    ff3_key=userkeyslist[0]
    ff3_tweak=userkeyslist[1]
   

    plaintext_org=str(ff3_input)
    plaintext_org=plaintext_org[1:]
    plaintext_org=plaintext_org[:-5]
    
    c = FF3Cipher(ff3_key, ff3_tweak)

    decrypted = c.decrypt(plaintext_org)
    #decrypted=''

    lengthpadding=int(str(ff3_input)[-3])
    commais=int(str(ff3_input)[0])

    
    if lengthpadding==1:
            decrypted=decrypted[:commais] + '.' + decrypted[commais:]
    else:
            decrypted=decrypted[:-lengthpadding+1]
            decrypted=decrypted[:commais] + '.' + decrypted[commais:]


    return float(decrypted)
