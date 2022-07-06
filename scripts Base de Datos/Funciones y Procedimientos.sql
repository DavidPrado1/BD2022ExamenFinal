--FUNCIONES PARA CONSULTAS EN LA BASE DE DATOS

--1 Participaciones de un Proyectos (con su nombre del profesor)

create or replace function participaciones(integer) 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select t2.id_proyecto,id_trabaja,nombre_prof,apell_prof,nombre_proyecto from profesor_trabaja_proyecto t1
		inner join proyecto_investigación t2 on t1.id_proyecto = t2.id_proyecto
		inner join profesor t3 on t1.id_profesor = t3.id_prof
	loop
		if rec.id_proyecto = $1  then
  			raise notice '% -- % %', rec.id_trabaja, rec.nombre_prof, rec.apell_prof;
		END if;
	end loop;
end;
$$

select participaciones(1)

--2 Participaciones de un Proyectos, doctores, (con su nombre del profesor)

create or replace function participacionesDoc(integer) 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select id_trabaja,nombre_prof,apell_prof,nombre_proyecto,tipo,t1.id_proyecto from profesor_trabaja_proyecto t1
		inner join proyecto_investigación t2 on t1.id_proyecto = t2.id_proyecto
		inner join profesor t3 on t1.id_profesor = t3.id_prof
	loop
		if rec.id_proyecto = $1  then
  			if rec.tipo = 'doctor'  then
  				raise notice '% -- % %', rec.id_trabaja, rec.nombre_prof, rec.apellido_prof;
			END if;
		END if;
	end loop;
end;
$$

select participacionesDoc(11)

--3 Participaciones de un Proyectos, no doctores, (con su nombre del profesor)

create or replace function participacionesNoDoc(integer) 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select id_trabaja,nombre_prof,apell_prof,nombre_proyecto,tipo,t1.id_proyecto from profesor_trabaja_proyecto t1
		inner join proyecto_investigación t2 on t1.id_proyecto = t2.id_proyecto
		inner join profesor t3 on t1.id_profesor = t3.id_prof
	loop
		if rec.id_proyecto = $1  then
  			if rec.tipo = 'no doctor'  then
  				raise notice '% -- % %', rec.id_trabaja, rec.nombre_prof, rec.apell_prof;
			END if;
		END if;
	end loop;
end;
$$

select participacionesNoDoc(1)

--4 Participaciones de profesores de un determinado despacho:
create or replace function participacionesDespacho(varchar) 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select id_trabaja,nombre_prof,apell_prof,nombre_proyecto,despacho_prof from profesor_trabaja_proyecto t1
		inner join proyecto_investigación t2 on t1.id_proyecto = t2.id_proyecto
		inner join profesor t3 on t1.id_profesor = t3.id_prof
	loop
		if rec.despacho_prof = $1  then
  			raise notice '% -- % %', rec.id_trabaja, rec.nombre_prof, rec.apell_prof;
		END if;
	end loop;
end;
$$


select participacionesDespacho('despacho11') 

--5 Autores de una determinada publicacion, que esten en proyectos

create or replace function autoresPubli(int) 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select id_publicacion,nombre_prof,apell_prof from escribe_publicacion t1
		inner join profesor t2 on t1.id_profesor = t2.id_prof
		where exists(select * from profesor_trabaja_proyecto t3
		where t1.id_profesor=t3.id_profesor)
	loop
		if rec.id_publicacion = $1  then
  			raise notice '% %', rec.nombre_prof, rec.apell_prof;
		END if;
	end loop;
end;
$$

select autoresPubli(1) 

--6 Publicacion tipo Congreso con autores doctores:

create or replace function publiCongresoDoc() 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select t2.titulo_publicacion,tipo_congreso,ciudad ,pais from congreso t1
		inner join publicacion t2 on t1.id_congreso = t2.id_publicacion
		where exists(select * from escribe_publicacion t3
		inner join profesor t4 on t3.id_profesor  = t4.id_prof
		where t4.tipo='doctor')
	loop
		raise notice '% -- % -- % -- %', rec.titulo_publicacion,rec.tipo_congreso,rec.ciudad ,rec.pais;
	end loop;
end;
$$

select publiCongresoDoc()

--7 Publicacion tipo Revista con autores no doctores:

create or replace function publiRevistaNoDoc() 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select t2.titulo_publicacion,volumen_rev,numero_rev  from revista t1
		inner join publicacion t2 on t1.id_revista = t2.id_publicacion
		where exists(select * from escribe_publicacion t3
		inner join profesor t4 on t3.id_profesor  = t4.id_prof
		where t4.tipo='no doctor')
	loop
		raise notice '% -- % -- %', rec.titulo_publicacion,rec.volumen_rev,rec.numero_rev;
	end loop;
end;
$$

select publiRevistaNoDoc();


--8 Supervisiones donde el doctor que supervisa tenga publicaciones:

create or replace function superviPubli() 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select t1.id_sup,t2.nombre_prof as docnom,t2.apell_prof as docap,t3.nombre_prof as nodocnom,t3.apell_prof as nodocap from doc_sup_no_doc t1
		inner join profesor t2 on t1.id_doctor  = t2.id_prof
		inner join profesor t3 on t1.id_no_doctor = t3.id_prof
		where exists(select * from escribe_publicacion t4
		where t2.id_prof=t4.id_profesor)
	loop
		raise notice '% -- % % -- % %', rec.id_sup,rec.docnom,rec.docap,rec.nodocnom,rec.nodocap  ;
	end loop;
end;
$$

select superviPubli();

--9 Proyectos donde el encargado doctor no tenga publicaciones:

create or replace function proyectoNoPubli() 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select nombre_proyecto,descripcion_proyecto,prespuesto_proy,t2.nombre_prof,t2.apell_prof  from proyecto_investigación t1
		inner join profesor t2 on t1.id_doctor = t2.id_prof
		where not exists(select * from escribe_publicacion t3
		where t2.id_prof=t3.id_profesor)
	loop
		raise notice '% -- % % -- % %', rec.nombre_proyecto,rec.descripcion_proyecto,rec.prespuesto_proy,rec.nombre_prof,rec.apell_prof  ;
	end loop;
end;
$$

select proyectoNoPubli();

--10 Participaciones donde el profesor no tenga supervisiones:

create or replace function participacionNoSup() 
returns void 
language plpgsql
as 
$$
declare
	rec record;
begin 
	for rec in select t2.nombre_proyecto,t3.nombre_prof,t3.apell_prof from profesor_trabaja_proyecto t1
		inner join proyecto_investigación t2 on t1.id_trabaja = t2.id_proyecto 
		inner join profesor t3 on t1.id_profesor = t3.id_prof
		where not exists(select * from doc_sup_no_doc t4
		where t4.id_no_doctor=t1.id_profesor)
	loop
		raise notice '% -- % %', rec.nombre_proyecto, rec.nombre_prof, rec.apell_prof  ;
	end loop;
end;
$$

select participacionNoSup();

-- PROCEDIMIENTOS INSERTAR,ACTUALIZAR Y ELIMINAR EN TABLAS ENTIDADES.

--Profesores:

create or replace procedure profesorInsertar(integer,varchar,varchar,varchar,integer, varchar)
language plpgsql
as
$$ 
begin
	insert into profesor(id_prof,nombre_prof ,apell_prof ,despacho_prof ,telefono,tipo)
	values($1,$2,$3,$4,$5,$6);
end;
$$

call profesorInsertar(23453,'Luis Manuel','Perez Gomez','Despacho 1',219341238,'doctor')
call profesorInsertar(12454,'Pedro Luis','Paredes Lopez','Despacho 4',452141238,'no doctor')

select * from profesor p  where p.id_prof = 23453;
select * from profesor;

create or replace procedure profesorActualizar(integer,varchar,varchar,varchar,integer, varchar)
language plpgsql
as
$$ 
begin
	update profesor
	set nombre_prof = $2,
		apell_prof = $3,
		despacho_prof  = $4,
		telefono  = $5,
		tipo = $6
	where id_prof = $1;
end;
$$

call profesorActualizar(23453,'Luis Miguel','Perez Gomez','Despacho 4',219341232,'doctor')

select * from profesor p  where p.id_prof = 23453;
select * from profesor;

create or replace procedure profesorEliminar(integer)
language plpgsql
as
$$ 
begin
	delete from profesor
	where id_prof = $1;
end;
$$

call profesorEliminar(23453);
select * from profesor;

--Proyectos:

create or replace procedure proyectosInsertar(integer,varchar,varchar,text,date, date,int,int)
language plpgsql
as
$$ 
begin
	if exists(select * from profesor
	where id_prof = $8 and tipo = 'doctor') then 
		insert into proyecto_investigación(id_proyecto,nombre_proyecto ,programa_id ,descripcion_proyecto ,fecha_inicio_proy ,fecha_fin_proy ,prespuesto_proy ,id_doctor)
		values($1,$2,$3,$4,$5,$6,$7,$8);
	else
		raise notice 'No se puede insertar ya que el encargado no es doctor';
	end if;
	commit;
end;
$$

call proyectosInsertar(12323,'Proyecto Futuro','217','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.','2022-03-21','2022-08-21',32443430,23453)
call proyectosInsertar(12323,'Proyecto Futuro','217','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.','2022-03-21','2022-08-21',32443430,12454)
select * from proyecto_investigación;

create or replace procedure proyectosActualizar(integer,varchar,varchar,text,date, date,int,int)
language plpgsql
as
$$ 
begin
	if exists(select * from profesor
	where id_prof = $8 and tipo = 'doctor') then 
		update compras.productos 
		set nombre_proyecto = $2,
			programa_id = $3,
			descripcion_proyecto = $4,
			fecha_inicio_proy = $5,
			fecha_fin_proy = $6,
			prespuesto_proy = $7,
			id_doctor = $8
		where id_proyecto = $1;
	else
		raise notice 'No se puede actualizar ya que el encargado no es doctor';
	end if;
	commit;
end;
$$

call proyectosActualizar(12323,'Proyecto Futuro','217','Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.','2022-03-21','2022-08-21',32443430,12454)
select * from proyecto_investigación;


create or replace procedure proyectosEliminar(integer)
language plpgsql
as
$$ 
begin
	delete from proyecto_investigación
	where id_proyecto = $1;
end;
$$

call proyectosEliminar(12323);
select * from proyecto_investigación;

--Publicaciones:

create or replace procedure publiCongresoInsertar(integer,varchar,varchar,varchar,varchar,varchar, date,date)
language plpgsql
as
$$ 
begin
	insert into publicacion (id_publicacion,titulo_publicacion,tipo)
	values($1,$2,$3);
	insert into congreso (id_congreso,tipo_congreso ,ciudad,pais,fecha_inicio_congreso,fecha_fin_congreso)
	values($1,$4,$5,$6,$7,$8);
end;
$$

call publiCongresoInsertar(124343,'Lorem Ipsum','Congreso','Marcial','Medellin','Colombia','2022-08-21','2022-09-21')
select * from publicacion;
select * from congreso;


create or replace procedure publiCongresoActualizar(integer,varchar,varchar,varchar,varchar, date,date)
language plpgsql
as
$$ 
begin
	update publicacion 
	set titulo_publicacion = $2
	where id_publicacion= $1;
	update congreso
	set tipo_congreso = $3,
		ciudad = $4,
		pais = $5,
		fecha_inicio_congreso = $6,
		fecha_fin_congreso = $7
	where id_congreso = $1;
end;
$$

call publiCongresoActualizar(124343,'Lorem Ipsam','Privado','Caracas','Venezuela','2022-06-21','2022-09-21')

select * from publicacion;
select * from congreso;

create or replace procedure publiCongresoEliminar(integer)
language plpgsql
as
$$ 
begin
	delete from congreso
	where id_congreso = $1;
	delete from publicacion
	where id_publicacion = $1;
end;
$$

call publiCongresoEliminar(124343);

select * from publicacion;
select * from congreso;

create or replace procedure publiRevistaInsertar(integer,varchar,varchar,integer, integer, integer, integer)
language plpgsql
as
$$ 
begin
	insert into publicacion (id_publicacion,titulo_publicacion,tipo)
	values($1,$2,$3);
	insert into revista (id_revista,volumen_rev ,numero_rev ,pagina_inicio,pagina_fin)
	values($1,$4,$5,$6,$7);
end;
$$

call publiRevistaInsertar(1245,'Lorem','Revista',4,2,1,200);
select * from publicacion;
select * from revista;


create or replace procedure publiRevistaActualizar(integer,varchar,integer, integer, integer, integer)
language plpgsql
as
$$ 
begin
	update publicacion
	set titulo_publicacion = $2
	where id_publicacion= $1;
	update revista
	set volumen_rev = $3,
		numero_rev = $4,
		pagina_inicio = $5,
		pagina_fin = $6
	where id_revista = $1;
end;
$$

call publiRevistaActualizar(1245,'Lorem Ipsam',3,5,1,199)

select * from publicacion;
select * from revista;

create or replace procedure publiRevistaEliminar(integer)
language plpgsql
as
$$ 
begin
	delete from revista
	where id_revista = $1;
	delete from publicacion
	where id_publicacion = $1;
end;
$$

call publiRevistaEliminar(1245);

select * from publicacion;
select * from revista;