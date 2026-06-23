DELIMITER $$

-- =========================================================
-- 1. sp_registrar_prestamo(id_socio, id_ejemplar)
-- =========================================================
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_id_socio INT,
    IN p_id_ejemplar INT
)
BEGIN
    DECLARE v_activo INT;
    DECLARE v_cant_prestamos INT;
    DECLARE v_stock_disp INT;
    DECLARE v_isbn VARCHAR(20);
    DECLARE v_sanciones_activas INT;

    -- Validación 1: Sanciones activas e integridad del socio
    SELECT activo INTO v_activo FROM socio WHERE id_socio = p_id_socio;
    SELECT COUNT(*) INTO v_sanciones_activas FROM sancion WHERE id_socio = p_id_socio AND fecha_fin >= CURDATE();
    
    IF v_activo = 0 OR v_sanciones_activas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El socio tiene sanciones activas o está inactivo.';
    END IF;

    -- Validación 2: Límite de préstamos (Supongamos un máximo de 3 activos por socio)
    SELECT COUNT(*) INTO v_cant_prestamos FROM prestamo WHERE id_socio = p_id_socio AND fecha_devolucion IS NULL;
    IF v_cant_prestamos >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El socio alcanzó el límite máximo de préstamos simultáneos.';
    END IF;

    -- Validación 3: Disponibilidad del ejemplar y stock
    SELECT isbn INTO v_isbn FROM ejemplar WHERE id_ejemplar = p_id_ejemplar;
    SELECT stock_disponible INTO v_stock_disp FROM libro WHERE isbn = v_isbn;
    
    IF v_stock_disp <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No hay stock disponible de este ejemplar.';
    END IF;

    -- Registrar Préstamo
    INSERT INTO prestamo (fecha_prestamo, fecha_vencimiento, fecha_devolucion, id_socio, id_ejemplar, id_estadoPrestamo)
    VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, p_id_socio, p_id_ejemplar, 1);

    -- Nota: La actualización del stock del libro y el estado del ejemplar se maneja con el TRIGGER.
    SELECT 'Préstamo registrado correctamente' AS resultado;
END$$

-- =========================================================
-- 2. sp_registrar_devolucion(id_prestamo)
-- =========================================================
CREATE PROCEDURE sp_registrar_devolucion(
    IN p_id_prestamo INT
)
BEGIN
    DECLARE v_id_socio INT;
    DECLARE v_fecha_venc DATE;
    DECLARE v_dias_mora INT;

    -- Obtener datos del préstamo
    SELECT id_socio, fecha_vencimiento INTO v_id_socio, v_fecha_venc 
    FROM prestamo WHERE id_prestamo = p_id_prestamo AND fecha_devolucion IS NULL;

    IF v_id_socio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Préstamo no encontrado o ya devuelto.';
    END IF;

    -- Asentar devolución
    UPDATE prestamo 
    SET fecha_devolucion = CURDATE(), id_estadoPrestamo = 2 
    WHERE id_prestamo = p_id_prestamo;

    -- Si hay mora, llamamos automáticamente a sp_generar_sancion
    IF CURDATE() > v_fecha_venc THEN
        SET v_dias_mora = DATEDIFF(CURDATE(), v_v_fecha_venc);
        -- Pasamos id_socio, tipo_sancion (1) y los días calculados
        CALL sp_generar_sancion(v_id_socio, 1, v_dias_mora);
    END IF;

    SELECT 'Devolución registrada correctamente.' AS resultado;
END$$

-- =========================================================
-- 3. sp_generar_sancion(id_socio, tipo, dias_mora)
-- =========================================================
CREATE PROCEDURE sp_generar_sancion(
    IN p_id_socio INT,
    IN p_tipo INT,
    IN p_dias_mora INT
)
BEGIN
    DECLARE v_dias_sancion INT;
    
    -- Supongamos que la sanción es el doble de los días de mora atrasados
    SET v_dias_sancion = p_dias_mora * 2;

    -- Creamos el registro en la tabla sancion (id_descripcion = 1)
    INSERT INTO sancion (fecha_inicio, fecha_fin, id_descripcion, id_tipoSancion, id_socio)
    VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL v_dias_sancion DAY), 1, p_tipo, p_id_socio);

    -- Actualizamos el estado del socio a inactivo
    UPDATE socio SET activo = 0 WHERE id_socio = p_id_socio;
END$$

-- =========================================================
-- 4. sp_renovar_prestamo(id_prestamo) [BONUS]
-- =========================================================
CREATE PROCEDURE sp_renovar_prestamo(
    IN p_id_prestamo INT
)
BEGIN
    DECLARE v_id_socio INT;
    DECLARE v_sanciones INT;
    -- Nota: Si implementan reservas agregan el control aquí, sino con el socio alcanza.

    SELECT id_socio INTO v_id_socio FROM prestamo WHERE id_prestamo = p_id_prestamo AND fecha_devolucion IS NULL;

    IF v_id_socio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El préstamo no está activo y no se puede renovar.';
    END IF;

    -- Validar que el socio no tenga sanciones vigentes
    SELECT COUNT(*) INTO v_sanciones FROM sancion WHERE id_socio = v_id_socio AND fecha_fin >= CURDATE();
    
    IF v_sanciones > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede renovar. El socio cuenta con sanciones vigentes.';
    END IF;

    -- Extender la fecha de vencimiento por 14 días más a partir de hoy
    UPDATE prestamo 
    SET fecha_vencimiento = DATE_ADD(CURDATE(), INTERVAL 14 DAY)
    WHERE id_prestamo = p_id_prestamo;

    SELECT 'Préstamo renovado con éxito.' AS resultado;
END$$

DELIMITER ;