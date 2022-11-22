def isDivisibleBy2(num):
    if (num % 2) == 0:
        return True
    else:
        return False


def udf(ff3input):

    
    


    result=''
    encrypted_value_list=ff3input.split('[C')
    decrypted_value_list=[]
    encryptedvalue=''
    i=0
    x=0

    
    for encrypted_value in encrypted_value_list[1:-1]:
     
        if i >= 1:
            x=1
            encrypted_value=encrypted_value[2:]
            encryptedvalue=encryptedvalue+encrypted_value
        
        else:
            encrypted_value=encrypted_value[2:]
            encryptedvalue=encryptedvalue+encrypted_value
        i=i+1


    ## Formatting Block
    lastvalue=encrypted_value_list[-1]
    lastvalue=lastvalue[2:]
    encryptedvalue=encryptedvalue+ lastvalue
    
    howmany = int(encryptedvalue[-3:])
    encryptedvalue=encryptedvalue[:-3]
    
    if x ==1:
        
        #formatted=encryptedvalue[2:]
        formatted=formatted[0:howmany-2]
        formatted=encryptedvalue[2:]
        
        
        
        
    else:
         
        formatted=encryptedvalue
        #formatted=formatted[0:howmany]
        #formatted=encryptedvalue
         
         
    formatted=formatted.replace(' ','')
   
    
    

   
    return formatted
