create index idx_dni_socio on socio(dni);

create index idx_apellido_nombre_socio on socio(apellido, nombre);

create index idx_titulo_libro on libro(titulo);

create index idx_genero on genero(nombre);

create index idx_apellido_nombre_autor on autor(apellido, nombre);