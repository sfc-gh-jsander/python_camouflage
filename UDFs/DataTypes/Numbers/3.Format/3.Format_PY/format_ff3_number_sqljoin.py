from decimal import *



def format_ff3_number_sqljoin(ff3input):

    
    checkdecimal="." in str(ff3input)
    
    if checkdecimal==False :
    
        value=str(ff3input)
        #length=int(value[-2:])
        
        formatted=''
        formatted=value[1:]
        formatted=formatted[:-2]
        #formatted=formatted[0:length]
        #formatted='1'+formatted
        #final=''
        #addition=0
        #numberofzeros=0
        #nullen=''
        #result=0
        
        
        #if formatted[0]=='0':
        #    numberofzeros=length-1
        #    addition=length-numberofzeros
        #    for zeros in range(numberofzeros):
        #        nullen=nullen+'0'
        #    final=str(addition)+nullen
        #    result=int(formatted)+int(final)
        #    return result
            
        return int(formatted)
        
    if checkdecimal==True :
    
    #1114907569131.00000000 = 9.021
    #str(commais)+endresult+str(beforecomma)+str(aftercomma)+str(lengthpadding)
    
        value=str(ff3input).split('.')
        result=value[0]
        result=result[1:]
        result=result[:-1]
        commas=result[-2:]
        result=result[:-2]
        
        #beforecomma=int(commas[0])
        #aftercomma=int(commas[-1])
        
        bcdigits=result
        
        acdigits=0
        
        endresult=str(bcdigits)+'.'+str(acdigits)
        
        
        
      
        return Decimal(endresult)
