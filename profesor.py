import psycopg2

class profesor:

    def __init__(self):
        self.cnn = psycopg2.connect(dbname="evidencia4", user="postgres",
                            password="44444444", host="localhost", port="8081")

    def __str__(self):
        datos=self.consulta_profesores()        
        aux=""
        for row in datos:
            aux=aux + str(row) + "\n"
        return aux
        
    def consulta_profesores(self):
        cur = self.cnn.cursor()
        cur.execute("SELECT * FROM profesor")
        datos = cur.fetchall()
        cur.close()    
        return datos

    def buscar_pais(self, Id):
        cur = self.cnn.cursor()
        sql= "SELECT * FROM profesores WHERE idprof = {}".format(Id)
        cur.execute(sql)
        datos = cur.fetchone()
        cur.close()    
        return datos
    
    def inserta_prof(self,id_prof,nombre_prof ,apell_prof ,despacho_prof ,telefono,tipo):
        cur = self.cnn.cursor()
        cur.execute('CALL profesorInsertar(%s,%s,%s,%s,%s,%s)', (id_prof,nombre_prof ,apell_prof ,despacho_prof ,telefono,tipo))
        self.cnn.commit()    
        cur.close()

    def elimina_prof(self,Id):
        cur = self.cnn.cursor()
        cur.execute('CALL profesorEliminar({})'.format(Id))
        self.cnn.commit()    
        cur.close() 

    def modifica_prof(self,id_prof,nombre_prof ,apell_prof ,despacho_prof ,telefono,tipo):
        cur = self.cnn.cursor()
        cur.execute('CALL profesorActualizar(%s,%s,%s,%s,%s,%s)', (id_prof,nombre_prof ,apell_prof ,despacho_prof ,telefono,tipo))

        self.cnn.commit()    
        cur.close()
 
