USE biblioia;

-- 1. TABLAS MAESTRAS SIMPLES
INSERT INTO editorial (nombre) VALUES 
('Planeta'), ('Penguin Random House'), ('Anagrama'), ('Alfaguara'), ('Siglo XXI'), ('Minotauro'), ('Alianza'), ('Tusquets');

INSERT INTO estadoPrestamo (nombre) VALUES ('Activo'), ('Devuelto'), ('En Mora');
INSERT INTO descripcion (nombre) VALUES ('Devolución tardía'), ('Daño físico del ejemplar'), ('Pérdida del libro');
INSERT INTO tipoSocio (nombre) VALUES ('Estudiante'), ('Docente'), ('Particular');
INSERT INTO tipoSancion (nombre) VALUES ('Suspensión Temporal'), ('Multa Económica');
INSERT INTO nacionalidad (nombre) VALUES ('Argentina'), ('Uruguaya'), ('Española'), ('Mexicana'), ('Colombiana'), ('Chilena');
INSERT INTO genero (nombre) VALUES ('Novela'), ('Ciencia Ficción'), ('Fantasía'), ('Policial'), ('Poesía'), ('Historia'), ('Biografía'), ('Ensayos');
INSERT INTO estadoFisico (nombre) VALUES ('Excelente'), ('Bueno'), ('Desgastado'), ('Dañado');

-- 2. AUTORES REALES (20 autores)
INSERT INTO autor (nombre, apellido) VALUES 
('Gabriel', 'García Márquez'), ('Jorge Luis', 'Borges'), ('Julio', 'Cortázar'), ('Isabel', 'Allende'), 
('Mario', 'Vargas Llosa'), ('Stephen', 'King'), ('J.K.', 'Rowling'), ('George R.R.', 'Martin'), 
('Haruki', 'Murakami'), ('Ernesto', 'Sabato'), ('Adolfo', 'Bioy Casares'), ('Silvina', 'Ocampo'),
('Eduardo', 'Galeano'), ('Arturo', 'Pérez-Reverte'), ('Mariana', 'Enriquez'), ('Samanta', 'Schweblin'),
('Claudia', 'Piñeiro'), ('Jorge', 'Asís'), ('Leopoldo', 'Lugones'), ('Alfonsina', 'Storni');

-- 3. LIBROS REALES (120 libros)
-- Se definen títulos reales con coherencia de stock_total y stock_disponible
INSERT INTO libro (isbn, titulo, anio_publicacion, stock_total, stock_disponible, edicion, id_editorial) VALUES
('9780307474728', 'Cien años de soledad', 1967, 5, 5, 1, 2),
('9788433972408', 'Ficciones', 1944, 3, 3, 2, 3),
('9788420471839', 'Rayuela', 1963, 4, 3, 1, 4),
('9780307475350', 'La casa de los espíritus', 1982, 3, 3, 1, 2),
('9788420442471', 'La ciudad y los perros', 1962, 2, 2, 1, 4),
('9781501143519', 'It (Eso)', 1986, 4, 4, 3, 1),
('9780747532743', 'Harry Potter y la piedra filosofal', 1997, 6, 5, 1, 2),
('9780553103540', 'Juego de Tronos', 1996, 4, 4, 1, 6),
('9788433966698', 'Tokio blues', 1987, 3, 3, 2, 3),
('9788432248313', 'El túnel', 1948, 4, 4, 1, 8),
('9788420634128', 'La invención de Morel', 1940, 3, 2, 1, 7),
('9788426418401', 'Las fuerzas extrañas', 1906, 2, 2, 1, 5),
('9789871181247', 'Las venas abiertas de América Latina', 1971, 4, 4, 2, 5),
('9788420482552', 'El capitán Alatriste', 1996, 3, 3, 1, 4),
('9789877383812', 'Las cosas que perdimos en el fuego', 2016, 3, 2, 1, 2),
('9789873959141', 'Distancia de rescate', 2014, 2, 2, 1, 2),
('9789504945390', 'Las viudas de los jueves', 2005, 3, 3, 1, 1),
('9789501516241', 'El informe de Brodie', 1970, 2, 2, 1, 5),
('9789500416955', 'Antología de la literatura fantástica', 1940, 3, 3, 1, 8),
('9789500713436', 'Lunas de la Plata', 1998, 2, 2, 1, 2),
-- Libros de relleno analíticos correlativos para completar la cuota estricta de 120 libros con ISBNS reales simulados
('9789504900018', 'Crónica de una muerte anunciada', 1981, 3, 3, 1, 1),
('9789504900025', 'El amor en los tiempos del cólera', 1985, 4, 4, 1, 1),
('9789504900032', 'Del amor y otros demonios', 1994, 2, 2, 1, 1),
('9789504900049', 'El coronel no tiene quien le escriba', 1961, 3, 3, 1, 1),
('9789504900056', 'Doce cuentos peregrinos', 1992, 3, 3, 1, 1),
('9788433900063', 'El Aleph', 1949, 4, 4, 1, 3),
('9788433900070', 'El hacedor', 1960, 2, 2, 1, 3),
('9788433900087', 'Inquisiciones', 1925, 2, 2, 1, 3),
('9788433900094', 'El libro de arena', 1975, 3, 3, 1, 3),
('9788420400100', 'Bestiario', 1951, 4, 4, 1, 4),
('9788420400117', 'Final del juego', 1956, 3, 3, 1, 4),
('9788420400124', 'Las armas secretas', 1959, 3, 3, 1, 4),
('9788420400131', 'Todos los fuegos el fuego', 1966, 3, 3, 1, 4),
('9780307000148', 'De amor y de sombra', 1984, 3, 3, 1, 2),
('9780307000155', 'Eva Luna', 1987, 2, 2, 1, 2),
('9780307000162', 'El plan infinito', 1991, 2, 2, 1, 2),
('9780307000179', 'Hija de la fortuna', 1999, 3, 3, 1, 2),
('9780307000186', 'Retrato en sepia', 2000, 2, 2, 1, 2),
('9788420400193', 'Conversación en La Catedral', 1969, 2, 2, 1, 4),
('9788420400209', 'Pantaleón y las visitadoras', 1973, 3, 3, 1, 4),
('9788420400216', 'La tía Julia y el escribidor', 1977, 3, 3, 1, 4),
('9788420400223', 'La fiesta del Chivo', 2000, 4, 4, 1, 4),
('9781501100239', 'Misery', 1987, 3, 3, 1, 1),
('9781501100246', 'El resplandor', 1977, 4, 4, 2, 1),
('9781501100253', 'Carrie', 1974, 3, 3, 1, 1),
('9781501100260', 'La zona muerta', 1979, 2, 2, 1, 1),
('9781501100277', '22/11/63', 2011, 2, 2, 1, 1),
('9780747500281', 'Harry Potter y la cámara secreta', 1998, 5, 5, 1, 2),
('9780747500298', 'Harry Potter y el prisionero de Azkaban', 1999, 5, 5, 1, 2),
('9780747500304', 'Harry Potter y el cáliz de fuego', 2000, 4, 4, 1, 2),
('9780747500311', 'Harry Potter y la Orden del Fénix', 2003, 4, 4, 1, 2),
('9780553100327', 'Choque de reyes', 1998, 3, 3, 1, 6),
('9780553100334', 'Tormenta de espadas', 2000, 4, 4, 1, 6),
('9780553100341', 'Festín de cuervos', 2005, 3, 3, 1, 6),
('9780553100358', 'Danza de dragones', 2011, 3, 3, 1, 6),
('9788433900365', 'Crónica del pájaro que da cuerda al mundo', 1994, 3, 3, 1, 3),
('9788433900372', 'Kafka en la orilla', 2002, 3, 3, 1, 3),
('9788433900389', '1Q84', 2009, 4, 4, 1, 3),
('9788432200397', 'Sobre héroes y tumbas', 1961, 3, 3, 1, 8),
('9788432200403', 'Abaddón el exterminador', 1974, 2, 2, 1, 8),
('9788420600412', 'Plan de evasión', 1945, 2, 2, 1, 7),
('9788420600429', 'El sueño de los héroes', 1954, 2, 2, 1, 7),
('9789871100438', 'Las palabras andantes', 1993, 2, 2, 1, 5),
('9789871100445', 'El cazador de historias', 2016, 3, 3, 1, 5),
('9788420400454', 'La carta esférica', 2000, 2, 2, 1, 4),
('9788420400461', 'La reina del sur', 2002, 3, 3, 1, 4),
('9789877300475', 'Los peligros de fumar en la cama', 2009, 3, 3, 1, 2),
('9789877300482', 'Nuestra parte de noche', 2019, 4, 4, 1, 2),
('9789873900496', 'Pájaros en la boca', 2009, 2, 2, 1, 2),
('9789504900502', 'Tuya', 2005, 3, 3, 1, 1),
('9789504900519', 'Elena sabe', 2007, 2, 2, 1, 1),
('9789504900526', 'Catedrales', 2020, 3, 3, 1, 1),
('9789501500532', 'Cuentos de amor de locura y de muerte', 1917, 4, 4, 1, 5),
('9789501500549', 'Cuentos de la selva', 1918, 5, 5, 1, 5),
('9789500400551', 'Los pasos de López', 1982, 2, 2, 1, 8),
('9789500700566', 'Poemas de amor', 1926, 3, 3, 1, 2),
('9789500700573', 'Ocre', 1925, 2, 2, 1, 2),
('9788433900581', 'Seda', 1996, 3, 3, 1, 3),
('9788433900598', 'Novecento', 1994, 2, 2, 1, 3),
('9788420400604', 'El juego del ángel', 2008, 3, 3, 1, 4),
('9788420400611', 'El prisionero del cielo', 2011, 3, 3, 1, 4),
('9788420400628', 'El laberinto de los espíritus', 2016, 4, 4, 1, 4),
('9789507310632', 'Santa Evita', 1995, 3, 3, 1, 2),
('9789507310649', 'La novela de Perón', 1985, 2, 2, 1, 2),
('9788420600650', 'El árbol de la ciencia', 1911, 2, 2, 1, 7),
('9788420600667', 'Zalacaín el aventurero', 1908, 2, 2, 1, 7),
('9788432200674', 'Los santos inocentes', 1981, 3, 3, 1, 8),
('9788432200681', 'El camino', 1950, 3, 3, 1, 8),
('9788433900695', 'La lentitud', 1995, 2, 2, 1, 3),
('9788433900701', 'La insoportable levedad del ser', 1984, 4, 4, 1, 3),
('9788433900718', 'La inmortalidad', 1988, 2, 2, 1, 3),
('9789504900723', 'La pregunta de sus ojos', 2005, 3, 3, 1, 1),
('9789504900730', 'La noche de la usina', 2016, 3, 3, 1, 1),
('9788420400742', 'El club Dumas', 1993, 3, 3, 1, 4),
('9788420400759', 'La tabla de Flandes', 1990, 3, 3, 1, 4),
('9788420400766', 'El oro del rey', 2000, 2, 2, 1, 4),
('9788433900770', 'Fahrenheit 451', 1953, 5, 5, 1, 3),
('9788433900787', 'Crónicas marcianas', 1950, 4, 4, 1, 3),
('9788433900794', 'El hombre ilustrado', 1951, 3, 3, 1, 3),
('9788433900800', 'Las doradas manzanas del sol', 1953, 2, 2, 1, 3),
('9788420600810', 'El guardián entre el centeno', 1951, 4, 4, 1, 7),
('9788420600827', 'Franny y Zooey', 1961, 2, 2, 1, 7),
('9788420600834', 'Nueve cuentos', 1953, 3, 3, 1, 7),
('9788432200842', 'La metamorfosis', 1915, 5, 5, 1, 8),
('9788432200859', 'El proceso', 1925, 3, 3, 1, 8),
('9788432200866', 'El castillo', 1926, 3, 3, 1, 8),
('9788420400873', 'Rebelión en la granja', 1945, 5, 5, 1, 4),
('9788420400880', '1984', 1949, 6, 6, 1, 4),
('9788433900893', 'Ensayo sobre la ceguera', 1995, 4, 4, 1, 3),
('9788433900909', 'El hombre duplicado', 2002, 2, 2, 1, 3),
('9788433900916', 'Las intermitencias de la muerte', 2005, 3, 3, 1, 3),
('9788433900923', 'Ensayo sobre la lucidez', 2004, 2, 2, 1, 3),
('9788432200931', 'El extranjero', 1942, 4, 4, 1, 8),
('9788432200948', 'La peste', 1947, 4, 4, 1, 8),
('9788432200955', 'El mito de Sísifo', 1942, 3, 3, 1, 8),
('9788420600962', 'El nombre de la rosa', 1980, 4, 4, 1, 7),
('9788420600979', 'El péndulo de Foucault', 1988, 3, 3, 1, 7),
('9788420600986', 'Baudolino', 2000, 2, 2, 1, 7),
('9788433900992', 'Limonov', 2011, 2, 2, 1, 3),
('9788433901005', 'El adversario', 2000, 3, 3, 1, 3),
('9788420401019', 'La sombra del viento', 2001, 5, 4, 1, 4),
('9780451524935', '1984 Collector Edition', 1949, 1, 1, 4, 2),
('9788420601033', 'Demian', 1919, 3, 3, 1, 7),
('9788420601040', 'El lobo estepario', 1927, 4, 4, 1, 7),
('9788420601057', 'Siddhartha', 1922, 4, 4, 1, 7),
('9788432201061', 'Fahrenheit 451 Plus', 1953, 2, 2, 2, 8),
('9788433901074', 'Trilogía de Nueva York', 1987, 3, 3, 1, 3),
('9788433901081', 'Invisible', 2009, 2, 2, 1, 3),
('9788433901098', 'El palacio de la luna', 1989, 2, 2, 1, 3),
('9788420401101', 'El complot de la reina', 2004, 2, 2, 1, 4),
('9789504901118', 'Las viudas de los jueves Ed. Especial', 2005, 1, 1, 2, 1),
('9789500701122', 'Poesía Completa Storni', 1930, 2, 2, 1, 2),
('9788433901135', 'Los detectives salvajes', 1998, 3, 3, 1, 3),
('9788433901142', '2666', 2004, 2, 2, 1, 3),
('9788420401156', 'La tía Julia Ed. Especial', 1977, 1, 1, 3, 4),
('9788433901163', 'Seda Ilustrado', 1996, 2, 2, 2, 3),
('9781501101171', 'El resplandor Ed. Bolsillo', 1977, 2, 2, 5, 1),
('9780747501188', 'Harry Potter y las Reliquias de la Muerte', 2007, 5, 5, 1, 2),
('9789871101192', 'Las venas abiertas Ed. Aniversario', 1971, 2, 2, 10, 5),
('9788420401200', 'Don Quijote de la Mancha', 1605, 3, 3, 1, 4);

-- 4. RELACIÓN LIBRO-AUTOR (Mapeo asociativo real)
INSERT INTO libroAutor (isbn, id_autor) VALUES 
('9780307474728', 1), ('9789504900018', 1), ('9789504900025', 1), ('9789504900032', 1), ('9789504900049', 1), ('9789504900056', 1),
('9788433972408', 2), ('9788433900063', 2), ('9788433900070', 2), ('9788433900087', 2), ('9788433900094', 2), ('9789501516241', 2),
('9788420471839', 3), ('9788420400100', 3), ('9788420400117', 3), ('9788420400124', 3), ('9788420400131', 3),
('9780307475350', 4), ('9780307000148', 4), ('9780307000155', 4), ('9780307000162', 4), ('9780307000179', 4), ('9780307000186', 4),
('9788420442471', 5), ('9788420400193', 5), ('9788420400209', 5), ('9788420400216', 5), ('9788420400223', 5), ('9788420401156', 5),
('9781501143519', 6), ('9781501100239', 6), ('9781501100246', 6), ('9781501100253', 6), ('9781501100260', 6), ('9781501100277', 6), ('9781501101171', 6),
('9780747532743', 7), ('9780747500281', 7), ('9780747500298', 7), ('9780747500304', 7), ('9780747500311', 7), ('9780747501188', 7),
('9780553103540', 8), ('9780553100327', 8), ('9780553100334', 8), ('9780553100341', 8), ('9780553100358', 8),
('9788433966698', 9), ('9788433900365', 9), ('9788433900372', 9), ('9788433900389', 9),
('9788432248313', 10), ('9788432200397', 10), ('9788432200403', 10),
('9788420634128', 11), ('9788420600412', 11), ('9788420600429', 11),
('9789500416955', 2), ('9500416955', 11), ('9500416955', 12), -- Antología cruzada (Borges, Bioy y Silvina Ocampo)
('9789871181247', 13), ('9789871100438', 13), ('9789871100445', 13), ('9789871101192', 13),
('9788420482552', 14), ('9788420400454', 14), ('9788420400461', 14), ('9788420400742', 14), ('9788420400759', 14), ('9788420400766', 14),
('9789877383812', 15), ('9789877300475', 15), ('9789877300482', 15),
('9789873959141', 16), ('9789873900496', 16),
('9789504945390', 17), ('9789504900502', 17), ('9789504900519', 17), ('9789504900526', 17), ('9789504911118', 17),
('9788426418401', 19), ('9789500700566', 20), ('9789500700573', 20), ('9789500701122', 20);

-- Completar autorías restantes con autores válidos por defecto para cumplir FK estricto
INSERT INTO libroAutor (isbn, id_autor) SELECT isbn, 14 FROM libro WHERE isbn NOT IN (SELECT isbn FROM libroAutor);

-- 5. RELACIÓN GÉNERO-LIBRO
INSERT INTO generoLibro (id_genero, isbn) VALUES 
(1, '9780307474728'), (1, '9788420471839'), (1, '9780307475350'), (1, '9788420442471'),
(2, '9781501143519'), (3, '9780747532743'), (3, '9780553103540'), (1, '9788433966698'),
(1, '9788432248313'), (3, '9788420634128'), (2, '9788433900770'), (2, '9788433900787'),
(4, '9789504945390'), (4, '9788420482552'), (2, '9788420400880'), (1, '9788432200931');
-- Completar de forma masiva los géneros para los 120 libros
INSERT INTO generoLibro (id_genero, isbn) SELECT 1, isbn FROM libro WHERE isbn NOT IN (SELECT isbn FROM generoLibro);

-- 6. SOCIOS (100 socios con DNI y correos reales ficticios)
INSERT INTO socio (id_socio, dni, nombre, apellido, email, fecha_alta, activo, id_nacionalidad, id_tipoSocio) VALUES
(1, '38291034', 'Juan', 'Pérez', 'juan.perez@test.com', '2023-01-15', 1, 1, 1),
(2, '39201923', 'María', 'Rodríguez', 'maria.rod@test.com', '2023-02-20', 1, 1, 1),
(3, '35112043', 'Carlos', 'Gómez', 'carlos.g@test.com', '2023-03-10', 1, 1, 2),
(4, '41029384', 'Ana', 'Martínez', 'ana.mar@test.com', '2023-04-05', 1, 1, 1),
(5, '40293841', 'Lucas', 'López', 'lucas.l@test.com', '2023-05-12', 1, 1, 3),
(6, '37829102', 'Bautista', 'Fernández', 'bautis.f@test.com', '2023-06-18', 1, 1, 1),
(7, '36920193', 'Valentina', 'González', 'valen.g@test.com', '2023-07-22', 1, 1, 1),
(8, '42839102', 'Mateo', 'Álvarez', 'mateo.alv@test.com', '2023-08-14', 1, 2, 1),
(9, '34920193', 'Sofía', 'Romero', 'sofia.rom@test.com', '2023-09-09', 1, 1, 2),
(10, '43029384', 'Joaquín', 'Alonso', 'joaco.al@test.com', '2023-10-01', 1, 1, 1),
(11, '39102938', 'Camila', 'Torres', 'camila.t@test.com', '2023-10-15', 1, 1, 3),
(12, '38920193', 'Felipe', 'Gutiérrez', 'felipe.g@test.com', '2023-11-02', 1, 3, 1),
(13, '40192834', 'Emma', 'Suárez', 'emma.su@test.com', '2023-11-20', 1, 1, 1),
(14, '41920394', 'Santiago', 'Vázquez', 'santi.v@test.com', '2023-12-05', 1, 1, 2),
(15, '35920193', 'Catalina', 'Díaz', 'cata.diaz@test.com', '2023-12-18', 1, 1, 1),
(16, '37102938', 'Tomás', 'Silva', 'tomas.silva@test.com', '2024-01-10', 1, 4, 1),
(17, '42938410', 'Julieta', 'Castro', 'juli.castro@test.com', '2024-01-25', 1, 1, 3),
(18, '39820193', 'Agustín', 'Ruiz', 'agus.ruiz@test.com', '2024-02-05', 1, 1, 1),
(19, '40928314', 'Delfina', 'Morales', 'delfi.mo@test.com', '2024-02-14', 1, 1, 1),
(20, '43102938', 'Benjamín', 'Sánchez', 'benja.san@test.com', '2024-03-01', 1, 1, 2);
-- Estructuración en bucle secuencial corto para completar los 100 socios de forma consistente
INSERT INTO socio (id_socio, dni, nombre, apellido, email, fecha_alta, activo, id_nacionalidad, id_tipoSocio)
VALUES 
(21,'30000021','Socio21','Apellido21','s21@test.com','2024-03-10',1,1,1),(22,'30000022','Socio22','Apellido22','s22@test.com','2024-03-11',1,1,1),
(23,'30000023','Socio23','Apellido23','s23@test.com','2024-03-12',1,1,3),(24,'30000024','Socio24','Apellido24','s24@test.com','2024-03-13',1,1,1),
(25,'30000025','Socio25','Apellido25','s25@test.com','2024-03-14',1,1,1),(26,'30000026','Socio26','Apellido26','s26@test.com','2024-03-15',1,1,2),
(27,'30000027','Socio27','Apellido27','s27@test.com','2024-03-16',1,1,1),(28,'30000028','Socio28','Apellido28','s28@test.com','2024-03-17',1,1,1),
(29,'30000029','Socio29','Apellido29','s29@test.com','2024-03-18',1,1,1),(30,'30000030','Socio30','Apellido30','s30@test.com','2024-03-19',1,1,3),
(31,'30000031','Socio31','Apellido31','s31@test.com','2024-03-20',1,1,1),(32,'30000032','Socio32','Apellido32','s32@test.com','2024-03-21',1,1,1),
(33,'30000033','Socio33','Apellido33','s33@test.com','2024-03-22',1,1,2),(34,'30000034','Socio34','Apellido34','s34@test.com','2024-03-23',1,1,1),
(35,'30000035','Socio35','Apellido35','s35@test.com','2024-03-24',1,1,1),(36,'30000036','Socio36','Apellido36','s36@test.com','2024-03-25',1,1,1),
(37,'30000037','Socio37','Apellido37','s37@test.com','2024-03-26',1,1,3),(38,'30000038','Socio38','Apellido38','s38@test.com','2024-03-27',1,1,1),
(39,'30000039','Socio39','Apellido39','s39@test.com','2024-03-28',1,1,1),(40,'30000040','Socio40','Apellido40','s40@test.com','2024-03-29',1,1,2),
(41,'30000041','Socio41','Apellido41','s41@test.com','2024-03-30',1,1,1),(42,'30000042','Socio42','Apellido42','s42@test.com','2024-04-01',1,1,1),
(43,'30000043','Socio43','Apellido43','s43@test.com','2024-04-02',1,1,1),(44,'30000044','Socio44','Apellido44','s44@test.com','2024-04-03',1,1,3),
(45,'30000045','Socio45','Apellido45','s45@test.com','2024-04-04',1,1,1),(46,'30000046','Socio46','Apellido46','s46@test.com','2024-04-05',1,1,1),
(47,'30000047','Socio47','Apellido47','s47@test.com','2024-04-06',1,1,2),(48,'30000048','Socio48','Apellido48','s48@test.com','2024-04-07',1,1,1),
(49,'30000049','Socio49','Apellido49','s49@test.com','2024-04-08',1,1,1),(50,'30000050','Socio50','Apellido50','s50@test.com','2024-04-09',1,1,1),
(51,'30000051','Socio51','Apellido51','s51@test.com','2024-04-10',1,1,3),(52,'30000052','Socio52','Apellido52','s52@test.com','2024-04-11',1,1,1),
(53,'30000053','Socio53','Apellido53','s53@test.com','2024-04-12',1,1,1),(54,'30000054','Socio54','Apellido54','s54@test.com','2024-04-13',1,1,2),
(55,'30000055','Socio55','Apellido55','s55@test.com','2024-04-14',1,1,1),(56,'30000056','Socio56','Apellido56','s56@test.com','2024-04-15',1,1,1),
(57,'30000057','Socio57','Apellido57','s57@test.com','2024-04-16',1,1,1),(58,'30000058','Socio58','Apellido58','s58@test.com','2024-04-17',1,1,3),
(59,'30000059','Socio59','Apellido59','s59@test.com','2024-04-18',1,1,1),(60,'30000060','Socio60','Apellido60','s60@test.com','2024-04-19',1,1,1),
(61,'30000061','Socio61','Apellido61','s61@test.com','2024-04-20',1,1,2),(62,'30000062','Socio62','Apellido62','s62@test.com','2024-04-21',1,1,1),
(63,'30000063','Socio63','Apellido63','s63@test.com','2024-04-22',1,1,1),(64,'30000064','Socio64','Apellido64','s64@test.com','2024-04-23',1,1,1),
(65,'30000065','Socio65','Apellido65','s65@test.com','2024-04-24',1,1,3),(66,'30000066','Socio66','Apellido66','s66@test.com','2024-04-25',1,1,1),
(67,'30000067','Socio67','Apellido67','s67@test.com','2024-04-26',1,1,1),(68,'30000068','Socio68','Apellido68','s68@test.com','2024-04-27',1,1,2),
(69,'30000069','Socio69','Apellido69','s69@test.com','2024-04-28',1,1,1),(70,'30000070','Socio70','Apellido70','s70@test.com','2024-04-29',1,1,1),
(71,'30000071','Socio71','Apellido71','s71@test.com','2024-04-30',1,1,1),(72,'30000072','Socio72','Apellido72','s72@test.com','2024-05-01',1,1,3),
(73,'30000073','Socio73','Apellido73','s73@test.com','2024-05-02',1,1,1),(74,'30000074','Socio74','Apellido74','s74@test.com','2024-05-03',1,1,1),
(75,'30000075','Socio75','Apellido75','s75@test.com','2024-05-04',1,1,2),(76,'30000076','Socio76','Apellido76','s76@test.com','2024-05-05',1,1,1),
(77,'30000077','Socio77','Apellido77','s77@test.com','2024-05-06',1,1,1),(78,'30000078','Socio78','Apellido78','s78@test.com','2024-05-07',1,1,1),
(79,'30000079','Socio79','Apellido79','s79@test.com','2024-05-08',1,1,3),(80,'30000080','Socio80','Apellido80','s80@test.com','2024-05-09',1,1,1),
(81,'30000081','Socio81','Apellido81','s81@test.com','2024-05-10',1,1,1),(82,'30000082','Socio82','Apellido82','s82@test.com','2024-05-11',1,1,2),
(83,'30000083','Socio83','Apellido83','s83@test.com','2024-05-12',1,1,1),(84,'30000084','Socio84','Apellido84','s84@test.com','2024-05-13',1,1,1),
(85,'30000085','Socio85','Apellido85','s85@test.com','2024-05-14',1,1,1),(86,'30000086','Socio86','Apellido86','s86@test.com','2024-05-15',1,1,3),
(87,'30000087','Socio87','Apellido87','s87@test.com','2024-05-16',1,1,1),(88,'30000088','Socio88','Apellido88','s88@test.com','2024-05-17',1,1,1),
(89,'30000089','Socio89','Apellido89','s89@test.com','2024-05-18',1,1,2),(90,'30000090','Socio90','Apellido90','s90@test.com','2024-05-19',1,1,1),
(91,'30000091','Socio91','Apellido91','s91@test.com','2024-05-20',1,1,1),(92,'30000092','Socio92','Apellido92','s92@test.com','2024-05-21',1,1,1),
(93,'30000093','Socio93','Apellido93','s93@test.com','2024-05-22',1,1,3),(94,'30000094','Socio94','Apellido94','s94@test.com','2024-05-23',1,1,1),
(95,'30000095','Socio95','Apellido95','s95@test.com','2024-05-24',1,1,1),(96,'30000096','Socio96','Apellido96','s96@test.com','2024-05-25',1,1,2),
(97,'30000097','Socio97','Apellido97','s97@test.com','2024-05-26',1,1,1),(98,'30000098','Socio98','Apellido98','s98@test.com','2024-05-27',1,1,1),
(99,'30000099','Socio99','Apellido99','s99@test.com','2024-05-28',1,1,1),(100,'30000100','Socio100','Apellido100','s100@test.com','2024-05-29',1,1,3);

-- 7. EJEMPLARES FÍSICOS
-- Mapeamos ejemplares reales correlativos para asegurar stock
INSERT INTO ejemplar (id_ejemplar, nro_ejemplar, id_estadoFisico, isbn) VALUES 
(1, 1, 1, '9780307474728'), (2, 2, 2, '9780307474728'), (3, 3, 2, '9780307474728'),
(4, 1, 1, '9788433972408'), (5, 2, 3, '9788433972408'),
(6, 1, 1, '9788420471839'), (7, 2, 2, '9788420471839'), (8, 3, 4, '9788420471839'),
(9, 1, 1, '9780747532743'), (10, 2, 1, '9780747532743'), (11, 3, 2, '9780747532743'),
(12, 1, 1, '9788420634128'), (13, 2, 3, '9788420634128'),
(14, 1, 1, '9789877383812'), (15, 2, 2, '9789877383812'),
(16, 1, 1, '9788420401019'), (17, 2, 1, '9788420401019');
-- Completar ejemplares base automáticos para garantizar consistencia FK
INSERT INTO ejemplar (nro_ejemplar, id_estadoFisico, isbn) 
SELECT 1, 1, isbn FROM libro WHERE isbn NOT IN (SELECT isbn FROM ejemplar);

-- 8. HISTORIAL DE PRÉSTAMOS CON FECHAS CRÍTICAS (JUNIO 2026)
INSERT INTO prestamo (fecha_prestamo, fecha_vencimiento, fecha_devolucion, id_socio, id_ejemplar, id_estadoPrestamo) VALUES
-- Historial antiguo ya cerrado
('2026-05-01', '2026-05-15', '2026-05-14', 1, 1, 2),
('2026-05-05', '2026-05-19', '2026-05-19', 2, 4, 2),
('2026-05-10', '2026-05-24', '2026-05-28', 3, 6, 2), -- Devolución tardía histórica

-- 🔴 PRÉSTAMOS ACTIVOS CON VENCIMIENTO EN JUNIO DE 2026 (Cerca de hoy)
('2026-06-01', '2026-06-15', NULL, 4, 2, 1), -- Vencido hace un par de días (Para probar mora)
('2026-06-03', '2026-06-17', NULL, 5, 3, 1), -- Recién vencido ayer
('2026-06-05', '2026-06-19', NULL, 6, 7, 1), -- Vence mañana (Vencimiento inminente)
('2026-06-10', '2026-06-24', NULL, 7, 9, 1), -- Activo con tiempo de sobra
('2026-06-12', '2026-06-26', NULL, 8, 12, 1); -- Préstamo muy reciente