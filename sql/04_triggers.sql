DELIMITER $$

DROP TRIGGER IF EXISTS trg_actualizar_stock_insert $$
DROP TRIGGER IF EXISTS trg_actualizar_stock_update $$
DROP TRIGGER IF EXISTS trg_audit_prestamo_delete $$
DROP TRIGGER IF EXISTS trg_audit_prestamo_insert $$
DROP TRIGGER IF EXISTS trg_audit_prestamo_update $$
DROP TRIGGER IF EXISTS trg_estado_socio $$
DROP TRIGGER IF EXISTS trg_prestamos_simultaneos $$

-- 1. Controlar máximo 3 préstamos activos
CREATE TRIGGER trg_prestamos_simultaneos 
BEFORE INSERT ON prestamo 
FOR EACH ROW 
BEGIN 
    DECLARE prestamos_activos INT; -- Se agregó el tipo de dato INT

    SELECT COUNT(*) INTO prestamos_activos
    FROM prestamo
    WHERE fecha_devolucion IS NULL
      AND id_socio = NEW.id_socio; -- Se corrigió id.socio por id_socio

    -- Si ya tiene 3 activos, no puede pedir un 4to
    IF prestamos_activos >= 3 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El socio ya tiene el límite de 3 préstamos activos.';
    END IF; 
END $$

-- 2. Socio con suspensión 
CREATE TRIGGER trg_estado_socio
AFTER INSERT ON sancion 
FOR EACH ROW 
BEGIN
    UPDATE socio
    SET fecha_baja = curdate()
    WHERE id_socio = NEW.id_socio; 
END $$

-- 3. Recalcular stock al insertar préstamo
CREATE TRIGGER trg_actualizar_stock_insert
AFTER INSERT ON prestamo 
FOR EACH ROW 
BEGIN 
    DECLARE var_isbn VARCHAR(20);

    SELECT isbn INTO var_isbn
    FROM ejemplar
    WHERE id_ejemplar = NEW.id_ejemplar; 

    UPDATE libro
    SET stock_disponible = stock_disponible - 1
    WHERE isbn = var_isbn; 
END $$

-- 4. Recalcular stock al devolver un libro
CREATE TRIGGER trg_actualizar_stock_update
AFTER UPDATE ON prestamo 
FOR EACH ROW 
BEGIN 
    DECLARE var_isbn VARCHAR(200);

    SELECT isbn INTO var_isbn
    FROM ejemplar
    WHERE id_ejemplar = NEW.id_ejemplar; 

    IF OLD.fecha_devolucion IS NULL AND NEW.fecha_devolucion IS NOT NULL THEN
        UPDATE libro
        SET stock_disponible = stock_disponible + 1
        WHERE isbn = var_isbn; 
    END IF; 
END $$

-- 5. Auditoría préstamos: INSERT
CREATE TRIGGER trg_audit_prestamo_insert
AFTER INSERT ON prestamo
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (
        id_prestamo, accion, id_socio_anterior, id_socio_nuevo, 
        id_ejemplar_anterior, id_ejemplar_nuevo, estado_anterior, estado_nuevo, usuario_bd
    )
    VALUES (
        NEW.id_prestamo, 'INSERT', NULL, NEW.id_socio, 
        NULL, NEW.id_ejemplar, NULL, NEW.id_estadoPrestamo, USER()
    ); 
END $$

-- 6. Auditoría préstamos: UPDATE
CREATE TRIGGER trg_audit_prestamo_update
AFTER UPDATE ON prestamo
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (
        id_prestamo, accion, id_socio_anterior, id_socio_nuevo, 
        id_ejemplar_anterior, id_ejemplar_nuevo, estado_anterior, estado_nuevo, usuario_bd
    )
    VALUES (
        NEW.id_prestamo, 'UPDATE', OLD.id_socio, NEW.id_socio, 
        OLD.id_ejemplar, NEW.id_ejemplar, OLD.id_estadoPrestamo, NEW.id_estadoPrestamo, USER()
    ); 
END $$

-- 7. Auditoría préstamos: DELETE
CREATE TRIGGER trg_audit_prestamo_delete
AFTER DELETE ON prestamo
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_prestamos (
        id_prestamo, accion, id_socio_anterior, id_socio_nuevo, 
        id_ejemplar_anterior, id_ejemplar_nuevo, estado_anterior, estado_nuevo, usuario_bd
    )
    VALUES (
        OLD.id_prestamo, 'DELETE', OLD.id_socio, NULL, 
        OLD.id_ejemplar, NULL, OLD.id_estadoPrestamo, NULL, USER()
    ); 
END $$

DELIMITER ;