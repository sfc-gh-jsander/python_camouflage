from pydal import DAL, Field


from encrypt_ff3_string_OP import encrypt_string
from encrypt_ff3_number_OP import encrypt_number


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
    
    
    db.insurance_source1_target1.age.filter_in = lambda value : encrypt_number(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.sex.filter_in = lambda value : encrypt_string(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.bmi.filter_in = lambda value : encrypt_number(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.children.filter_in = lambda value : encrypt_number(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.smoker.filter_in = lambda value : encrypt_string(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.region.filter_in = lambda value : encrypt_string(ff3keyinput,value,userkeys)
    db.insurance_source1_target1.charges.filter_in = lambda value : encrypt_number(ff3keyinput,value,userkeys)

    ageinput=int(input('Age: '))
    genderinput=input('Gender: ')
    bmiinput=int(input('BMI: '))
    childreninput=int(input('Children: '))
    smokerinput=input('Smoker?: ')
    regioninput=input('Region?: ')
    chargesinput=int(input('Charges?: '))

    #db.insurance_source1_target1.insert(keyid=ff3keyinput, age=35, sex='neutral', bmi=99,children=2,smoker='yes', region='holland', charges=45454)

    db.insurance_source1_target1.insert(keyid=ff3keyinput, age=ageinput, sex=genderinput, bmi=bmiinput,children=childreninput,smoker=smokerinput, region=regioninput, charges=chargesinput)


    #rows=db().select(db.insurance_source1_target1.ALL)

    #for row in rows:
    #    age=str(row['age'])
    #    bmi=str(row['bmi'])
    #    charges=str(row['charges'])
    #    children=str(row['children'])
    #    print("{} || {} || {} || {} || {} || {} || {}".format(int(age), row['sex'], int(bmi),int(children),row['smoker'],row['region'],int(charges)))
    

finally:

    if db:
        db.close() 

print ('Row encrypted and inserted')