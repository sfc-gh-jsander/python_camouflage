def udf(ff3input):


    result=''
    encrypted_value_list=ff3input.split('[C')
 
    encryptedvalue=''

    for encrypted_value in encrypted_value_list[1:-1]:
        encryptedvalue=encryptedvalue+encrypted_value[2:]


    ## Formatting Block
    lastvalue=encrypted_value_list[-1]
    encryptedvalue=encryptedvalue+lastvalue[2:]
    #howmany = int(encryptedvalue[-3:])
    encryptedvalue=encryptedvalue[:-3]

    
   
    return encryptedvalue
