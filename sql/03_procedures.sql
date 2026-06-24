DELIMITER $$

DROP PROCEDURE IF EXISTS sp_generar_sancion $$
DROP PROCEDURE IF EXISTS sp_registrar_devolucion $$
DROP PROCEDURE IF EXISTS sp_registrar_prestamo $$
DROP PROCEDURE IF EXISTS sp_renovar_prestamo $$

-- =========================================================
-- 1. sp_registrar_prestamo(id_socio, id_ejemplar)
-- =========================================================
CREATE PROCEDURE sp_registrar_prestamo(
    IN p_id_socio INT,
    IN p_id_ejemplar INT
)
BEGIN
    DECLARE v_inactivo INT;
    DECLARE v_cant_prestamos INT;
    DECLARE v_stock_disp INT;
    DECLARE v_isbn VARCHAR(20);
    DECLARE v_sanciones_activas INT;

    -- Validación 1: Socio activo y sin sanciones vigentes
    SELECT (fecha_baja IS NOT NULL) INTO v_inactivo FROM socio WHERE id_socio = p_id_socio;
    SELECT COUNT(*) INTO v_sanciones_activas FROM sancion WHERE id_socio = p_id_socio AND fecha_fin >= CURDATE();

    IF v_inactivo = 1 OR v_sanciones_activas > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El socio tiene sanciones activas o está inactivo.';
    END IF;

    -- Validación 2: Límite de préstamos (máximo 3 activos por socio)
    -- Nota: el trigger trg_prestamos_simultaneos también lo controla
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

    -- Obtener datos del préstamo activo
    SELECT id_socio, fecha_vencimiento INTO v_id_socio, v_fecha_venc
    FROM prestamo WHERE id_prestamo = p_id_prestamo AND fecha_devolucion IS NULL;

    IF v_id_socio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Préstamo no encontrado o ya devuelto.';
    END IF;

    -- Asentar devolución
    -- Nota: la actualización del stock la maneja trg_actualizar_stock_update
    UPDATE prestamo
    SET fecha_devolucion = CURDATE(), id_estadoPrestamo = 2
    WHERE id_prestamo = p_id_prestamo;

    -- Si hay mora, generar sanción automáticamente
    IF CURDATE() > v_fecha_venc THEN
        SET v_dias_mora = DATEDIFF(CURDATE(), v_fecha_venc);
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

    -- La sanción dura el doble de los días de mora
    SET v_dias_sancion = p_dias_mora * 2;

    -- Insertar sanción (id_descripcion = 1)
    -- Nota: el trigger trg_estado_socio se encarga de setear fecha_baja en socio automáticamente luego de este INSERT.
    INSERT INTO sancion (fecha_inicio, fecha_fin, id_descripcion, id_tipoSancion, id_socio)
    VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL v_dias_sancion DAY), 1, p_tipo, p_id_socio);
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
    DECLARE v_inactivo INT;

    -- Validar que el préstamo esté activo
    SELECT id_socio INTO v_id_socio FROM prestamo WHERE id_prestamo = p_id_prestamo AND fecha_devolucion IS NULL;

    IF v_id_socio IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El préstamo no está activo y no se puede renovar.';
    END IF;

    -- Validar que el socio esté activo (fecha_baja IS NULL)
    SELECT (fecha_baja IS NOT NULL) INTO v_inactivo
    FROM socio
    WHERE id_socio = v_id_socio;

    IF v_inactivo = 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede renovar. El socio no está activo.';
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

-- =========================================================
-- sp_reactivar_socio(p_id_socio) 
-- Reactiva el socio si no tiene sanciones vigentes
-- =========================================================
CREATE PROCEDURE sp_reactivar_socio(IN p_id_socio INT)
BEGIN
    IF (SELECT COUNT(*) FROM sancion 
        WHERE id_socio = p_id_socio AND fecha_fin >= CURDATE()) = 0 THEN
        UPDATE socio SET fecha_baja = NULL WHERE id_socio = p_id_socio;
    END IF;
END$$

DELIMITER ;