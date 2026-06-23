create table editorial (
    id_editorial INT primary key auto_increment,
    nombre varchar(100) unique key NOT NULL
);

create table estadoPrestamo (
    id_estadoPrestamo int primary key auto_increment,
    nombre varchar(100) NOT NULL
);

create table descripcionSancion (
    id_descripcion int primary key auto_increment,
    nombre varchar(100) NOT NULL
);

create table tipoSocio (
    id_tipoSocio int primary key auto_increment,
    nombre varchar(100) NOT NULL
);

create table tipoSancion (
    id_tipoSancion int primary key auto_increment,
    nombre varchar(100) NOT NULL
);

create table nacionalidad (
    id_nacionalidad int primary key auto_increment,
    nombre varchar(100) unique key NOT NULL
);

create table genero (
    id_genero int primary key auto_increment,
    nombre varchar (100) unique key NOT NULL
);

create table estadoFisico (
    id_estadoFisico int primary key auto_increment,
    nombre varchar(100) NOT NULL
);

create table autor (
    id_autor int primary key auto_increment,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL
);

create table libro (
    isbn varchar(20) primary key,
    titulo varchar(150) NOT NULL,
    anio_publicacion int NOT NULL check(anio_publicacion > 0),
    stock_total int NOT NULL check(stock_total >= 0),
    stock_disponible int NOT NULL check(stock_disponible >= 0),
    edicion int NOT NULL,
    id_editorial int NOT NULL,
    foreign key (id_editorial) references editorial(id_editorial),
    check (stock_disponible <= stock_total)
);

create table libroAutor (
    isbn varchar(20),
    id_autor int,
    primary key (isbn, id_autor),
    foreign key (isbn) references libro(isbn),
    foreign key (id_autor) references autor(id_autor)
);

create table generoLibro (
    id_genero int,
    isbn varchar(20),
    primary key (id_genero, isbn),
    foreign key (id_genero) references genero(id_genero),
    foreign key (isbn) references libro(isbn)
);

create table socio (
    id_socio int primary key auto_increment,
    dni varchar(15) NOT NULL,
    nombre varchar(100) NOT NULL,
    apellido varchar(100) NOT NULL,
    email varchar(150) unique key NOT NULL,
    fecha_alta date NOT NULL,
    fecha_baja date NULL,
    id_nacionalidad int,
    id_tipoSocio int,
    foreign key (id_tipoSocio) references tipoSocio(id_tipoSocio),
    foreign key (id_nacionalidad) references nacionalidad(id_nacionalidad)
);

create table sancion (
    id_sancion int primary key auto_increment,
    fecha_inicio date not null,
    fecha_fin date not null,
    id_descripcion int,
    id_tipoSancion int,
    id_socio int,
    foreign key (id_socio) references socio(id_socio),
    foreign key (id_descripcion) references descripcionSancion(id_descripcion),
    foreign key (id_tipoSancion) references tipoSancion(id_tipoSancion),
    check (fecha_fin > fecha_inicio)
);

create table ejemplar (
    id_ejemplar int primary key auto_increment,
    nro_ejemplar int check (nro_ejemplar > 0) not null,
    id_estadoFisico int,
    isbn varchar(20),
    foreign key (isbn) references libro(isbn) on delete cascade,
    foreign key (id_estadoFisico) references estadoFisico(id_estadoFisico)
);

create table prestamo (
    id_prestamo int primary key auto_increment,
    fecha_prestamo date not null,
    fecha_vencimiento date not null,
    fecha_devolucion date null,
    id_socio int,
    id_ejemplar int,
    id_estadoPrestamo int,
    foreign key (id_estadoPrestamo) references estadoPrestamo(id_estadoPrestamo),
    foreign key (id_ejemplar) references ejemplar(id_ejemplar),
    foreign key (id_socio) references socio(id_socio),
    check (fecha_vencimiento > fecha_prestamo),
    check (
        fecha_devolucion is null
        or fecha_devolucion > fecha_prestamo
    )
);

CREATE TABLE IF NOT EXISTS auditoria_prestamos (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT,
    accion VARCHAR(10),            -- 'INSERT', 'UPDATE' o 'DELETE'
    id_socio_anterior INT,
    id_socio_nuevo INT,
    id_ejemplar_anterior INT,
    id_ejemplar_nuevo INT,
    estado_anterior INT,
    estado_nuevo INT,
    usuario_bd VARCHAR(100),      
    fecha_auditoria TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);