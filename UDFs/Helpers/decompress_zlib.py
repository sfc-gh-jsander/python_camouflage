def udf(jwtskeys):

        result=zlib.decompress(jwtskeys).decode()


        return result