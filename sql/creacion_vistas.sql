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


-- Préstamos activos por socio
-- create view vista_prestamos_activos_socio as
select
	id_socio,
	socio,
	count(*) as prestamos_activos
from
	vista_prestamos_activos
group by
	id_socio,
	socio;


-- Catálogo de libros
-- create view vista_catalogo_libros as
SELECT
	l.isbn,
	l.titulo,
	GROUP_CONCAT(DISTINCT CONCAT(a.nombre, ' ', a.apellido) SEPARATOR ', ') AS autores,
	l.edicion,
	e.nombre AS editorial,
	GROUP_CONCAT(DISTINCT g.nombre SEPARATOR ', ') AS generos,
	l.anio_publicacion as "año publicación",
	l.stock_disponible,
	l.stock_total
FROM
	libro l
INNER JOIN editorial e ON
	l.id_editorial = e.id_editorial
LEFT JOIN libroAutor la ON
	l.isbn = la.isbn
LEFT JOIN autor a ON
	la.id_autor = a.id_autor
LEFT JOIN generoLibro gl ON
	l.isbn = gl.isbn
LEFT JOIN genero g ON
	gl.id_genero = g.id_genero
GROUP BY
	l.isbn;


-- Libros más prestados
-- create view vista_libros_populares as
SELECT 
    l.isbn,
    l.titulo,
    l.autores, 
    l.edicion, 
    l.editorial, 
    COUNT(p.id_prestamo) AS total_prestamos
FROM vista_libros l
JOIN ejemplar ej ON l.isbn = ej.isbn
JOIN prestamo p ON ej.id_ejemplar=p.id_ejemplar
GROUP BY 
  	l.isbn, 
  	l.titulo,
  	l.autores, 
	l.edicion, 
	l.editorial
order by total_prestamos desc;

