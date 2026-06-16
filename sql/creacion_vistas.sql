-- socios activos
-- create view vista_socios_activos as
select
	s.id_socio,
	concat(s.nombre, ' ', s.apellido) as socio,
	ts.nombre as tipo,
	s.email as correo,
	s.dni as dni,
	n.nombre as nacionalidad
from
	socio s
join nacionalidad n on
	s.id_nacionalidad = n.id_nacionalidad
join tipoSocio ts on
	s.id_tipoSocio = ts.id_tipoSocio
where
	s.activo = false;


-- préstamos activos, ordenados por días restantes (próximos a vencer primero)
-- create view vista_prestamos_activos as
select 
	s.id_socio, 
	concat(s.nombre, ' ', s.apellido) as socio,
	p.fecha_prestamo,
	p.fecha_vencimiento,
	datediff(p.fecha_vencimiento, curdate() ) as dias_restantes,
	l.isbn,
	concat(l.titulo, ' (ed. ', l.edicion, ')') as libro,
	e.nombre as editorial,
	ej.id_ejemplar as ejemplar,
	-- autores (generado por ia):
    (
	select
		group_concat(concat(a.nombre, ' ', a.apellido) separator ', ')
	from
		libroAutor la
	inner join autor a on
		la.id_autor = a.id_autor
	where
		la.isbn = l.isbn
    ) as autores
from
	prestamo p
join socio s on
	p.id_socio = s.id_socio
join ejemplar ej on
	p.id_ejemplar = ej.id_ejemplar
join libro l on
	ej.isbn = l.isbn
join editorial e on
	l.id_editorial = e.id_editorial
where
	p.fecha_devolucion is null
order by
	dias_restantes desc;


-- préstamos vencidos
-- create view vista_prestamos_vencidos as 
select 
	s.id_socio, 
	concat(s.nombre, ' ', s.apellido) as socio,
	datediff(curdate(), p.fecha_vencimiento) as dias_atraso,
	l.isbn,
	concat(l.titulo, ' (ed. ', l.edicion, ')') as libro,
	e.nombre as editorial,
	ej.id_ejemplar as ejemplar,
	-- autores (generado por ia):
    (
	select
		group_concat(concat(a.nombre, ' ', a.apellido) separator ', ')
	from
		libroAutor la
	inner join autor a on
		la.id_autor = a.id_autor
	where
		la.isbn = l.isbn
    ) as autores,
	p.fecha_prestamo,
	p.fecha_vencimiento
from
	prestamo p
join socio s on
	p.id_socio = s.id_socio
join ejemplar ej on
	p.id_ejemplar = ej.id_ejemplar
join libro l on
	ej.isbn = l.isbn
join editorial e on
	l.id_editorial = e.id_editorial
where
	p.fecha_devolucion is null
	and p.fecha_vencimiento<curdate()
	and s.activo = true
order by
	dias_atraso desc;
