def udf(ff3_input):

    

    #lengthpadding=int(str(ff3_input)[-3])
    #commais=int(str(ff3_input)[0])
    
    formatting=str(ff3_input)[-5:]
    formatting = formatting[:-3]
   

    beforecomma=int(formatting[0])
    aftercomma=int(formatting[-1])
    numberofdigits=beforecomma+aftercomma
    

    formatted=str(ff3_input)[0:numberofdigits]
    formatted=formatted[:beforecomma] + '.' + formatted[beforecomma:]

    checkformatted=int(formatted[-1])
    if checkformatted==0:
            formatted = formatted[:-1] + '1'



    return float(formatted)