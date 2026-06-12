-- Un socio no puede tener más de 3 préstamos activos simultáneos.

DELIMITER // 
CREATE TRIGGER trg_prestamos_simultaneos BEFORE
INSERT
    ON prestamo FOR EACH ROW BEGIN DECLARE prestamos_activos
SELECT
    COUNT(*) INTO prestamos_activos
FROM
    préstamo
WHERE
    fecha_devolucion IS NULL
    AND id.socio = NEW.id_socio IF prestamos_activos > 3 THEN SIGNAL SQLSTATE '45000'
SET
    MESSAGE_TEXT = 'No se pueden prestar mas de tres libros'
END IF;

END 
// DELIMITER;

--Socio con suspensión 
DELIMITER // 
CREATE TRIGGER trg_estado_socio
AFTER
INSERT
    ON sancion FOR EACH ROW BEGIN
UPDATE
    socio
SET
    activo = false
WHERE
    id_socio = NEW.id_socio;

END 
// DELIMITER; 

--Recalcular stock 
DELIMITER // 
CREATE TRIGGER trg_actualizar_stock_insert
AFTER
INSERT
    ON prestamo FOR EACH ROW BEGIN 
    
DECLARE var_isbn VARCHAR(20);

SELECT
    isbn INTO var_isbn
FROM
    ejemplar
WHERE
    id_ejemplar = NEW.id_ejemplar
UPDATE
    libro
SET
    stock_disponible = stock_disponible - 1
WHERE
    isbn = var_isbn;

END 
// DELIMITER;

DELIMITER // 

CREATE TRIGGER trg_actualizar_stock_update
AFTER
UPDATE
    ON prestamo FOR EACH ROW BEGIN DECLARE var_isbn VARCHAR(200);

SELECT
    isbn INTO var_isbn
FROM
    ejemplar
WHERE
    id_ejemplar = NEW.id_ejemplar IF OLD.fecha_devolucion IS NULL
    AND NEW.fecha_devolucion IS NOT NULL THEN
UPDATE
    libro
SET
    stock_disponible = stock_disponible + 1
WHERE
    isbn = var_isbn;

END IF;

END 
// DELIMITER;