create table profesor(
Id_prof int primary key,
nombre_prof varchar(50) not null,
apell_prof varchar(50) not null,
despacho_prof varchar(50) not null,
telefono int,
tipo varchar(10)
);

create table proyecto_investigación(
id_proyecto int unique primary key,
nombre_proyecto varchar(50) not null,
programa_id varchar(50) not null,
descripcion_proyecto text,
fecha_inicio_proy date not null,
fecha_fin_proy date not null,
prespuesto_proy int not null,
id_doctor int references profesor
);


create table profesor_trabaja_proyecto(
id_trabaja int primary key,
id_profesor int references profesor, 
id_proyecto int unique references proyecto_investigación,
fecha_inicio_trabajo date not null, 
fecha_fin_trabajo date not null
);

create table doc_sup_no_doc(
id_sup int primary key,
id_doctor int references profesor,
id_no_doctor int references profesor,
fecha_inicio_sup date not null, 
fecha_fin_sup date not null
);

create table publicacion(
id_publicacion int primary key,
titulo_publicacion varchar(50) not null,
tipo varchar(8) not null
);

create table revista(
id_revista int references publicacion,
volumen_rev int not null,
numero_rev int not null,
pagina_inicio int not null,
pagina_fin int not null
);

create table congreso(
id_congreso int references publicacion,
tipo_congreso varchar(50) not null,
ciudad varchar(50) not null,
pais varchar(50) not null,
fecha_inicio_congreso date not null,
fecha_fin_congreso date not null
);

create table escribe_publicacion(
id_profesor int references profesor,
id_publicacion int references publicacion
);