from decimal import *
import re



def format_ff3_number_1d(ff3input, firstdigit):

    
    checkdecimal="." in str(ff3input)
    
    if checkdecimal==False :
    
        value=str(ff3input)
        length=int(value[-2:])
        
        formatted=''
        formatted=value[1:]
        formatted=formatted[:-2]
        formatted=formatted[0:length]
        #formatted='1'+formatted
        final=''
        addition=0
        numberofzeros=0
        nullen=''
        result=0
        
        
        if formatted[0]=='0':
            numberofzeros=length-1
            addition=length-numberofzeros
            for zeros in range(numberofzeros):
                nullen=nullen+'0'
            final=str(addition)+nullen
            result=int(formatted)+int(final)
            new_str = re.sub(str(result)[0], str(firstdigit), str(result), 1)
            return int(new_str)
            
        new_str = re.sub(formatted[0], str(firstdigit), formatted, 1)
        return int(new_str)
        
    if checkdecimal==True :
    
    #1114907569131.00000000 = 9.021
    #str(commais)+endresult+str(beforecomma)+str(aftercomma)+str(lengthpadding)
    
        value=str(ff3input).split('.')
        result=value[0]
        
        #if encrypted value is a zero 
        
        if len(result)!=9:
            result=result[1:]
            result=result[:-1]
            commas=result[-2:]
            result=result[:-2]
        
            beforecomma=int(commas[0])
            aftercomma=int(commas[-1])
        
            if beforecomma!=1:
                bcdigits=value[0][0:beforecomma]
        
                if aftercomma!=0: 
                    acdigits=value[0][-aftercomma:]
                else:
                    acdigits=0
        
                endresult=str(bcdigits)+'.'+str(acdigits)
        
        
        
                new_str = re.sub(endresult[0], str(firstdigit), endresult, 1)
      
                return Decimal(new_str)
                
            else:
            
                bcdigits=value[0][4]
        
                if aftercomma!=0: 
                    acdigits=value[0][-aftercomma:]
                else:
                    acdigits=0
        
                endresult=str(bcdigits)+'.'+str(acdigits)
        
        
                new_str = re.sub(endresult[0], str(firstdigit), endresult, 1)
      
                return Decimal(new_str)
                
                
            
        else:
            endresult=result[5]
            
      
            return Decimal(endresult)
         

