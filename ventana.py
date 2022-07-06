from io import BufferedIOBase
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from profesor import *

    

class Ventana(Frame):
    
    bdtest = profesor()
    
    def __init__(self, master=None):
        super().__init__(master,width=770, height=360)
        self.master = master
        self.pack()
        self.create_widgets()
        self.llenaDatos()
        self.habilitarCajas("disabled")  
        self.habilitarBtnOper("normal")
        self.habilitarBtnGuardar("disabled")  
        self.id=0      
                   
    def habilitarCajas(self,estado):
        self.txtid.configure(state=estado)
        self.txtname.configure(state=estado)
        self.txtapell.configure(state=estado)
        self.txtdesp.configure(state=estado)
        self.txttef.configure(state=estado)
        self.txttipo.configure(state=estado)
        
    def habilitarBtnOper(self,estado):
        self.btnNuevo.configure(state=estado)                
        self.btnModificar.configure(state=estado)
        self.btnEliminar.configure(state=estado)
        
    def habilitarBtnGuardar(self,estado):
        self.btnGuardar.configure(state=estado)                
        self.btnCancelar.configure(state=estado)                
        
    def limpiarCajas(self):
        self.txtid.delete(0,END)
        self.txtname.delete(0,END)
        self.txtapell.delete(0,END)
        self.txtdesp.delete(0,END)
        self.txttef.delete(0,END)
        self.txttipo.delete(0,END)
        
    def limpiaGrid(self):
        for item in self.grid.get_children():
            self.grid.delete(item)

    def llenaDatos(self):
        datos = self.bdtest.consulta_profesores()        
        for row in datos:            
            self.grid.insert("",END,text=row[0], values=(row[1],row[2], row[3],row[4],row[5]))

    def fNuevo(self):         
        self.habilitarCajas("normal")  
        self.habilitarBtnOper("disabled")
        self.habilitarBtnGuardar("normal")
        self.limpiarCajas()        
        self.txtid.focus()
        self.id = 1
    
    def fGuardar(self): 
        if self.id ==1:       
            self.bdtest.inserta_prof(self.txtid.get(),self.txtname.get(),self.txtapell.get(),self.txtdesp.get(),self.txttef.get(),self.txttipo.get())            
            messagebox.showinfo("Insertar", 'Elemento insertado correctamente.')
            
        elif self.id==2:
            self.bdtest.modifica_prof(self.txtid.get(),self.txtname.get(),self.txtapell.get(),self.txtdesp.get(),self.txttef.get(),self.txttipo.get())
            messagebox.showinfo("Modificar", 'Elemento actualizado correctamente.')
        self.limpiaGrid()
        self.llenaDatos() 
        self.limpiarCajas() 
        self.habilitarBtnGuardar("disabled")      
        self.habilitarBtnOper("normal")
        self.habilitarCajas("disabled")        
        
                 
    def fModificar(self):        
        selected = self.grid.focus()
        clave = self.grid.item(selected,'text')
        if clave == '':
            messagebox.showwarning("Modificar","Debes seleccionar un elemento.")
        else:
            self.id = 2
            self.habilitarCajas("normal")
            valores = self.grid.item(selected,'values')
            self.limpiarCajas()
            self.txtid.insert(0,clave)
            self.txtname.insert(0,valores[0])
            self.txtapell.insert(0,valores[1])
            self.txtdesp.insert(0,valores[2])
            self.txttef.insert(0,valores[3])
            self.txttipo.insert(0,valores[4])
            self.habilitarBtnOper("disabled")
            self.habilitarBtnGuardar("normal")
            self.txtid.focus()
            
    
    def fEliminar(self):
        selected = self.grid.focus()                               
        clave = self.grid.item(selected,'text')        
        if clave == '':
            messagebox.showwarning("Eliminar", 'Debes seleccionar un elemento.')            
        else:                           
            valores = self.grid.item(selected,'values')
            data = str(clave) + ", " + valores[0] + ", " + valores[1]
            r = messagebox.askquestion("Eliminar", "Deseas eliminar el registro seleccionado?\n" + data)            
            if r == messagebox.YES:
                n = self.bdtest.elimina_prof(clave)
                messagebox.showinfo("Eliminar", 'Elemento eliminado correctamente.')
                self.limpiaGrid()
                self.llenaDatos()
                            
    def fCancelar(self):
        r = messagebox.askquestion("Calcelar", "Esta seguro que desea cancelar la operación actual")
        if r == messagebox.YES:
            self.limpiarCajas() 
            self.habilitarBtnGuardar("disabled")      
            self.habilitarBtnOper("normal")
            self.habilitarCajas("disabled")

    def create_widgets(self):
        frame1 = Frame(self, bg="#49A")
        frame1.place(x=0,y=0,width=93, height=359)        
        self.btnNuevo=Button(frame1,text="Nuevo", command=self.fNuevo, bg="blue", fg="white")
        self.btnNuevo.place(x=5,y=50,width=80, height=30 )        
        self.btnModificar=Button(frame1,text="Actualizar", command=self.fModificar, bg="blue", fg="white")
        self.btnModificar.place(x=5,y=90,width=80, height=30)                
        self.btnEliminar=Button(frame1,text="Eliminar", command=self.fEliminar, bg="blue", fg="white")
        self.btnEliminar.place(x=5,y=130,width=80, height=30)        
        frame2 = Frame(self,bg="#49A" )
        frame2.place(x=95,y=0,width=150, height=359)                        
        lbl1 = Label(frame2,text="ID: ")
        lbl1.place(x=3,y=5)        
        self.txtid=Entry(frame2)
        self.txtid.place(x=3,y=25,width=120, height=20)                
        lbl2 = Label(frame2,text="Nombres: ")
        lbl2.place(x=3,y=55)        
        self.txtname=Entry(frame2)
        self.txtname.place(x=3,y=75,width=120, height=20)        
        lbl3 = Label(frame2,text="Apellidos: ")
        lbl3.place(x=3,y=105)        
        self.txtapell=Entry(frame2)
        self.txtapell.place(x=3,y=125,width=120, height=20)        
        lbl4 = Label(frame2,text="Despacho: ")
        lbl4.place(x=3,y=155)        
        self.txtdesp=Entry(frame2)
        self.txtdesp.place(x=3,y=175,width=120, height=20)  
        lbl5 = Label(frame2,text="Telefono: ")
        lbl5.place(x=3,y=205)        
        self.txttef=Entry(frame2)
        self.txttef.place(x=3,y=225,width=120, height=20) 
        lbl6 = Label(frame2,text="Tipo: ")
        lbl6.place(x=3,y=255)        
        self.txttipo=Entry(frame2)
        self.txttipo.place(x=3,y=275,width=120, height=20)   
        self.btnGuardar=Button(frame2,text="Guardar", command=self.fGuardar, bg="green", fg="white")
        self.btnGuardar.place(x=10,y=310,width=60, height=30)
        self.btnCancelar=Button(frame2,text="Cancelar", command=self.fCancelar, bg="red", fg="white")
        self.btnCancelar.place(x=80,y=310,width=60, height=30)         
        frame3 = Frame(self,bg="#49A" )
        frame3.place(x=247,y=0,width=520, height=359)                      
        self.grid = ttk.Treeview(frame3, columns=("col1","col2","col3","col4","col5"))        
        self.grid.column("#0",width=60)
        self.grid.column("col1",width=60, anchor=CENTER)
        self.grid.column("col2",width=90, anchor=CENTER)
        self.grid.column("col3",width=90, anchor=CENTER)
        self.grid.column("col4",width=90, anchor=CENTER)     
        self.grid.column("col5",width=90, anchor=CENTER)    
        self.grid.heading("#0", text="Id", anchor=CENTER)
        self.grid.heading("col1", text="Nombre", anchor=CENTER)
        self.grid.heading("col2", text="Apellido", anchor=CENTER)
        self.grid.heading("col3", text="Despacho", anchor=CENTER)
        self.grid.heading("col4", text="Telefono", anchor=CENTER)
        self.grid.heading("col5", text="Tipo", anchor=CENTER)                    
        self.grid.pack(side=LEFT,fill = Y)        
        sb = Scrollbar(frame3, orient=VERTICAL)
        sb.pack(side=RIGHT, fill = Y)
        self.grid.config(yscrollcommand=sb.set)
        sb.config(command=self.grid.yview)
        self.grid['selectmode']='browse'    

        
        
        
        
        
        