DROP SCHEMA IF EXISTS tp_fabrica_automovil_bd1;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema tp_fabrica_automovil_bd1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tp_fabrica_automovil_bd1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tp_fabrica_automovil_bd1` DEFAULT CHARACTER SET utf8 ;
USE `tp_fabrica_automovil_bd1` ;

-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`fabrica_automovil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`fabrica_automovil` (
  `fabrica_automovil_id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`fabrica_automovil_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`concesionaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`concesionaria` (
  `concesionaria_id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(40) NOT NULL,
  `fabrica_automovil_id` INT NOT NULL,
  PRIMARY KEY (`concesionaria_id`),
  INDEX `fk_Concesionaria_FabricaAutomoviles1_idx` (`fabrica_automovil_id` ASC) VISIBLE,
  CONSTRAINT `fk_Concesionaria_FabricaAutomoviles1`
    FOREIGN KEY (`fabrica_automovil_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`fabrica_automovil` (`fabrica_automovil_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`modelo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`modelo` (
  `modelo_id` INT NOT NULL AUTO_INCREMENT,
  `modelo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`modelo_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`linea_montaje`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`linea_montaje` (
  `linea_montaje_id` INT NOT NULL AUTO_INCREMENT,
  `capacidad_productiva_promedio` DOUBLE NOT NULL,
  `estado` VARCHAR(40) NOT NULL,
  `cantidad_vehiculos_actual` INT NOT NULL,
  `fabrica_automovil_id` INT NOT NULL,
  `modelo_id` INT NOT NULL,
  PRIMARY KEY (`linea_montaje_id`, `fabrica_automovil_id`, `modelo_id`),
  INDEX `fk_LineaMontaje_FabricaAutomoviles1_idx` (`fabrica_automovil_id` ASC) VISIBLE,
  INDEX `fk_linea_montaje_modelo1_idx` (`modelo_id` ASC) VISIBLE,
  CONSTRAINT `fk_LineaMontaje_FabricaAutomoviles1`
    FOREIGN KEY (`fabrica_automovil_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`fabrica_automovil` (`fabrica_automovil_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_linea_montaje_modelo1`
    FOREIGN KEY (`modelo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`modelo` (`modelo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`pedido` (
  `pedido_id` INT NOT NULL AUTO_INCREMENT,
  `fecha_emision` DATETIME(4) NOT NULL,
  `fecha_entrega_estimada` DATETIME(4) NULL,
  `total` INT NULL,
  `concesionaria_id` INT NOT NULL,
  PRIMARY KEY (`pedido_id`),
  INDEX `FK_Pedido_Concesionaria_idx` (`concesionaria_id` ASC) VISIBLE,
  CONSTRAINT `FK_Pedido_Concesionaria`
    FOREIGN KEY (`concesionaria_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`concesionaria` (`concesionaria_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`pedido_detalle`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`pedido_detalle` (
  `pedido_detalle_id` INT NOT NULL AUTO_INCREMENT,
  `estado` VARCHAR(50) NOT NULL,
  `total` DOUBLE NULL,
  `cantidad` INT NOT NULL,
  `modelo_id` INT NOT NULL,
  `pedido_id` INT NOT NULL,
  PRIMARY KEY (`pedido_detalle_id`, `pedido_id`),
  INDEX `fk_PedidoDetalle_Pedido1_idx` (`pedido_id` ASC) VISIBLE,
  INDEX `FK_PedidoDetalle_Modelo_idx` (`modelo_id` ASC) VISIBLE,
  CONSTRAINT `fk_PedidoDetalle_Pedido1`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`pedido` (`pedido_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PedidoDetalle_Modelo`
    FOREIGN KEY (`modelo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`modelo` (`modelo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`vehiculo` (
  `vehiculo_id` INT NOT NULL AUTO_INCREMENT,
  `numero_chasis` VARCHAR(40) NOT NULL,
  `modelo_id` INT NOT NULL,
  `fecha_ingreso` DATETIME(4) NOT NULL,
  `fecha_egreso` DATETIME(4) NULL,
  `precio` DOUBLE NOT NULL,
  `fabrica_automovil_id` INT NOT NULL,
  `linea_montaje_id` INT NULL,
  `pedido_detalle_id` INT NULL,
  PRIMARY KEY (`vehiculo_id`, `fabrica_automovil_id`),
  INDEX `FK_Vehiculo_FabricaAutomoviles_idx` (`fabrica_automovil_id` ASC) VISIBLE,
  UNIQUE INDEX `NumeroChasis_UNIQUE` (`numero_chasis` ASC) VISIBLE,
  INDEX `FK_Vehiculo_LineaMontaje_idx` (`linea_montaje_id` ASC) VISIBLE,
  INDEX `FK_Vehiculo_pedido_detalle_idx` (`pedido_detalle_id` ASC) VISIBLE,
  INDEX `FK_Vehiculo_Modelo_idx` (`modelo_id` ASC) VISIBLE,
  CONSTRAINT `FK_Vehiculo_FabricaAutomoviles`
    FOREIGN KEY (`fabrica_automovil_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`fabrica_automovil` (`fabrica_automovil_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Vehiculo_LineaMontaje`
    FOREIGN KEY (`linea_montaje_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`linea_montaje` (`linea_montaje_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Vehiculo_pedido_detalle`
    FOREIGN KEY (`pedido_detalle_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`pedido_detalle` (`pedido_detalle_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_Vehiculo_Modelo`
    FOREIGN KEY (`modelo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`modelo` (`modelo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`estacion_trabajo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`estacion_trabajo` (
  `estacion_trabajo_id` INT NOT NULL AUTO_INCREMENT,
  `tarea` VARCHAR(40) NOT NULL,
  `demora_estimada_dias` INT NOT NULL,
  `estado` VARCHAR(50) NOT NULL,
  `linea_montaje_id` INT NOT NULL,
  `vehiculo_id` INT NULL,
  PRIMARY KEY (`estacion_trabajo_id`, `linea_montaje_id`),
  INDEX `fk_EstacionTrabajo_LineaMontaje1_idx` (`linea_montaje_id` ASC) VISIBLE,
  INDEX `FK_EstacionTrabajo_Vehiculo_idx` (`vehiculo_id` ASC) VISIBLE,
  CONSTRAINT `fk_EstacionTrabajo_LineaMontaje1`
    FOREIGN KEY (`linea_montaje_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`linea_montaje` (`linea_montaje_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_EstacionTrabajo_Vehiculo`
    FOREIGN KEY (`vehiculo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`vehiculo` (`vehiculo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`producto` (
  `producto_id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(40) NOT NULL,
  `descripcion` VARCHAR(80) NOT NULL,
  `fabrica_automovil_id` INT NOT NULL,
  PRIMARY KEY (`producto_id`),
  INDEX `FK_Producto_FabricaAutomoviles_idx` (`fabrica_automovil_id` ASC) VISIBLE,
  CONSTRAINT `FK_Producto_FabricaAutomoviles`
    FOREIGN KEY (`fabrica_automovil_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`fabrica_automovil` (`fabrica_automovil_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`proveedor` (
  `proveedor_id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`proveedor_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`producto_proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`producto_proveedor` (
  `producto_id` INT NOT NULL,
  `proveedor_id` INT NOT NULL,
  `precio` DOUBLE NOT NULL,
  `cantidad` INT NOT NULL,
  INDEX `FK_ProductoProveedor_Proveedor_idx` (`proveedor_id` ASC) VISIBLE,
  INDEX `fk_ProductoProveedor_Producto1_idx` (`producto_id` ASC) VISIBLE,
  CONSTRAINT `FK_ProductoProveedor_Proveedor`
    FOREIGN KEY (`proveedor_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`proveedor` (`proveedor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Fk_ProductoProveedor_Producto1`
    FOREIGN KEY (`producto_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`producto` (`producto_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`registro_venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`registro_venta` (
  `registro_venta_id` INT NOT NULL AUTO_INCREMENT,
  `fecha_emision` DATE NOT NULL,
  `total` DOUBLE NOT NULL,
  `concesionaria_id` INT NOT NULL,
  PRIMARY KEY (`registro_venta_id`, `concesionaria_id`),
  INDEX `FK_RegistroVenta_Concesionaria_idx` (`concesionaria_id` ASC) VISIBLE,
  CONSTRAINT `FK_RegistroVenta_Concesionaria`
    FOREIGN KEY (`concesionaria_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`concesionaria` (`concesionaria_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`producto_vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`producto_vehiculo` (
  `producto_id` INT NOT NULL,
  `modelo_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  INDEX `FK_ProductoVehiculo_Producto_idx` (`producto_id` ASC) VISIBLE,
  PRIMARY KEY (`producto_id`, `modelo_id`),
  INDEX `FK_ProductoVehiculo_modelo_idx` (`modelo_id` ASC) VISIBLE,
  CONSTRAINT `FK_ProductoVehiculo_Producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`producto` (`producto_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_ProductoVehiculo_modelo`
    FOREIGN KEY (`modelo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`modelo` (`modelo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`estacion_trabajo_vehiculo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`estacion_trabajo_vehiculo` (
  `estacion_trabajo_id` INT NOT NULL,
  `vehiculo_id` INT NOT NULL,
  `fecha_ingreso` DATETIME(4) NOT NULL,
  `fecha_egreso` DATETIME(4) NULL,
  `finalizado` TINYINT NULL,
  INDEX `FK_estacion_trabajo_vehiculo_estacion_trabajo_idx` (`estacion_trabajo_id` ASC) VISIBLE,
  INDEX `FK_estacion_trabajo_vehiculo_vehiculo_idx` (`vehiculo_id` ASC) VISIBLE,
  CONSTRAINT `FK_estacion_trabajo_vehiculo_estacion_trabajo`
    FOREIGN KEY (`estacion_trabajo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`estacion_trabajo` (`estacion_trabajo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_estacion_trabajo_vehiculo_vehiculo`
    FOREIGN KEY (`vehiculo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`vehiculo` (`vehiculo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tp_fabrica_automovil_bd1`.`estacion_trabajo_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tp_fabrica_automovil_bd1`.`estacion_trabajo_producto` (
  `estacion_trabajo_id` INT NOT NULL,
  `producto_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  INDEX `FK_estacion_trabajo_producto_estacion_trabajo_idx` (`estacion_trabajo_id` ASC) VISIBLE,
  INDEX `FK_estacion_trabajo_producto_producto_idx` (`producto_id` ASC) VISIBLE,
  CONSTRAINT `FK_estacion_trabajo_producto_estacion_trabajo`
    FOREIGN KEY (`estacion_trabajo_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`estacion_trabajo` (`estacion_trabajo_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_estacion_trabajo_producto_producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `tp_fabrica_automovil_bd1`.`producto` (`producto_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- STORED PROCEDURES ABM

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Concesionaria

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_concesionaria`(
    IN p_nombre VARCHAR(40),
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el nombre ya existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.concesionaria
    WHERE nombre = p_nombre;

    IF v_count > 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El nombre de la concesionaria ya existe.';
    ELSE
        -- Verificar si la fábrica de automóviles existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.fabrica_automovil
        WHERE fabrica_automovil_id = p_fabrica_automovil_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La fábrica de automóviles no existe.';
        ELSE
            -- Insertar nueva concesionaria
            INSERT INTO tp_fabrica_automovil_bd1.concesionaria (nombre, fabrica_automovil_id)
            VALUES (p_nombre, p_fabrica_automovil_id);

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_concesionaria`(
    IN p_concesionaria_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la concesionaria existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.concesionaria
    WHERE concesionaria_id = p_concesionaria_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La concesionaria no existe.';
    ELSE
        -- Verificar si hay registros dependientes en otras tablas
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.pedido
        WHERE concesionaria_id = p_concesionaria_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'No se puede eliminar la concesionaria, tiene pedidos asociados.';
        ELSE
            SELECT COUNT(*) INTO v_count
            FROM tp_fabrica_automovil_bd1.registro_venta
            WHERE concesionaria_id = p_concesionaria_id;

            IF v_count > 0 THEN
                SET p_nResultado = -3;
                SET p_cMensaje = 'No se puede eliminar la concesionaria, tiene registros de venta asociados.';
            ELSE
                -- Eliminar concesionaria
                DELETE FROM tp_fabrica_automovil_bd1.concesionaria
                WHERE concesionaria_id = p_concesionaria_id;

                SET p_nResultado = 0;
                SET p_cMensaje = '';
            END IF;
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_concesionaria`(
    IN p_concesionaria_id INT,
    IN p_nombre VARCHAR(40),
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la concesionaria existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.concesionaria
    WHERE concesionaria_id = p_concesionaria_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La concesionaria no existe.';
    ELSE
        -- Verificar si el nombre ya existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.concesionaria
        WHERE nombre = p_nombre
          AND concesionaria_id <> p_concesionaria_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'El nombre de la concesionaria ya existe.';
        ELSE
            -- Verificar si la fábrica de automóviles existe
            SELECT COUNT(*) INTO v_count
            FROM tp_fabrica_automovil_bd1.fabrica_automovil
            WHERE fabrica_automovil_id = p_fabrica_automovil_id;

            IF v_count = 0 THEN
                SET p_nResultado = -3;
                SET p_cMensaje = 'La fábrica de automóviles no existe.';
            ELSE
                -- Actualizar concesionaria
                UPDATE tp_fabrica_automovil_bd1.concesionaria
                SET nombre = p_nombre, fabrica_automovil_id = p_fabrica_automovil_id
                WHERE concesionaria_id = p_concesionaria_id;

                SET p_nResultado = 0;
                SET p_cMensaje = '';
            END IF;
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Estacion trabajo

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_estacion_trabajo`(
    IN p_tarea VARCHAR(40),
    IN p_demora_estimada_dias INT,
    IN p_estado ENUM('Ocupado', 'Libre'),
    IN p_linea_montaje_id INT,
    IN p_vehiculo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la línea de montaje existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.linea_montaje
    WHERE linea_montaje_id = p_linea_montaje_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La línea de montaje no existe.';
    ELSE
        -- Verificar si el vehículo existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.vehiculo
        WHERE vehiculo_id = p_vehiculo_id;

		-- Verificar si la tarea ya existe
		SELECT COUNT(*) INTO v_count
		FROM tp_fabrica_automovil_bd1.estacion_trabajo
		WHERE tarea = p_tarea;

		-- Insertar nueva estación de trabajo
		INSERT INTO tp_fabrica_automovil_bd1.estacion_trabajo (tarea, demora_estimada_dias, estado, linea_montaje_id, vehiculo_id)
		VALUES (p_tarea, p_demora_estimada_dias, p_estado, p_linea_montaje_id, p_vehiculo_id);

		SET p_nResultado = 0;
		SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_estacion_trabajo`(
    IN p_estacion_trabajo_id INT,
    IN p_tarea VARCHAR(40),
    IN p_demora_estimada_dias INT,
    IN p_estado ENUM('Ocupado', 'Libre'),
    IN p_linea_montaje_id INT,
    IN p_vehiculo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la estación de trabajo existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.estacion_trabajo
    WHERE estacion_trabajo_id = p_estacion_trabajo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La estación de trabajo no existe.';
    ELSE
        -- Verificar si la línea de montaje existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.linea_montaje
        WHERE linea_montaje_id = p_linea_montaje_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La línea de montaje no existe.';
        ELSE
            -- Verificar si el vehículo existe
            SELECT COUNT(*) INTO v_count
            FROM tp_fabrica_automovil_bd1.vehiculo
            WHERE vehiculo_id = p_vehiculo_id;

			-- Actualizar estación de trabajo
			UPDATE tp_fabrica_automovil_bd1.estacion_trabajo
			SET tarea = p_tarea,
				demora_estimada_dias = p_demora_estimada_dias,
				estado = p_estado,
				linea_montaje_id = p_linea_montaje_id,
				vehiculo_id = p_vehiculo_id
			WHERE estacion_trabajo_id = p_estacion_trabajo_id;

			SET p_nResultado = 0;
			SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_estacion_trabajo`(
    IN p_estacion_trabajo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la estación de trabajo existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.estacion_trabajo
    WHERE estacion_trabajo_id = p_estacion_trabajo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La estación de trabajo no existe.';
    ELSE
		-- Actualizar estación de trabajo
        DELETE FROM estacion_trabajo et WHERE et.estacion_trabajo_id = p_estacion_trabajo_id;

		SET p_nResultado = 0;
		SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Fabrica automovil

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_fabrica_automovil`(
    IN p_nombre VARCHAR(40),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el nombre ya existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.fabrica_automovil
    WHERE nombre = p_nombre;

    IF v_count > 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El nombre de la fábrica de automóviles ya existe.';
    ELSE
        -- Insertar nueva fábrica de automóviles
        INSERT INTO tp_fabrica_automovil_bd1.fabrica_automovil (nombre)
        VALUES (p_nombre);

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_fabrica_automovil`(
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la fábrica de automóviles existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.fabrica_automovil
    WHERE fabrica_automovil_id = p_fabrica_automovil_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La fábrica de automóviles no existe.';
    ELSE
        -- Verificar si hay registros dependientes en otras tablas
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.vehiculo
        WHERE fabrica_automovil_id = p_fabrica_automovil_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'No se puede eliminar la fábrica de automóviles, tiene vehículos asociados.';
        ELSE
            SELECT COUNT(*) INTO v_count
            FROM tp_fabrica_automovil_bd1.linea_montaje
            WHERE fabrica_automovil_id = p_fabrica_automovil_id;

            IF v_count > 0 THEN
                SET p_nResultado = -3;
                SET p_cMensaje = 'No se puede eliminar la fábrica de automóviles, tiene líneas de montaje asociadas.';
            ELSE
                SELECT COUNT(*) INTO v_count
                FROM tp_fabrica_automovil_bd1.producto
                WHERE fabrica_automovil_id = p_fabrica_automovil_id;

                IF v_count > 0 THEN
                    SET p_nResultado = -4;
                    SET p_cMensaje = 'No se puede eliminar la fábrica de automóviles, tiene productos asociados.';
                ELSE
                    -- Eliminar fábrica de automóviles
                    DELETE FROM tp_fabrica_automovil_bd1.fabrica_automovil
                    WHERE fabrica_automovil_id = p_fabrica_automovil_id;

                    SET p_nResultado = 0;
                    SET p_cMensaje = '';
                END IF;
            END IF;
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_fabrica_automovil`(
    IN p_fabrica_automovil_id INT,
    IN p_nombre VARCHAR(40),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la fábrica de automóviles existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.fabrica_automovil
    WHERE fabrica_automovil_id = p_fabrica_automovil_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La fábrica de automóviles no existe.';
    ELSE
        -- Verificar si el nombre ya existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.fabrica_automovil
        WHERE nombre = p_nombre
          AND fabrica_automovil_id <> p_fabrica_automovil_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'El nombre de la fábrica de automóviles ya existe.';
        ELSE
            -- Actualizar fábrica de automóviles
            UPDATE tp_fabrica_automovil_bd1.fabrica_automovil
            SET nombre = p_nombre
            WHERE fabrica_automovil_id = p_fabrica_automovil_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Linea montaje

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_linea_montaje`(
    IN p_capacidad_productiva_promedio DOUBLE,
    IN p_estado VARCHAR(50),
    IN p_cantidad_vehiculos_actual INT,
    IN p_modelo VARCHAR(50),
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la fábrica de automóviles existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.fabrica_automovil
    WHERE fabrica_automovil_id = p_fabrica_automovil_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La fábrica de automóviles no existe.';
    ELSE
		CALL sp_alta_modelo(p_modelo, p_nResultado, p_cMensaje);
		SELECT modelo_id INTO @v_modelo_id FROM tp_fabrica_automovil_bd1.modelo m WHERE m.modelo = p_modelo;
    
		IF p_nResultado = 0 THEN
        
			-- Insertar nueva línea de montaje
			INSERT INTO tp_fabrica_automovil_bd1.linea_montaje (capacidad_productiva_promedio, estado, cantidad_vehiculos_actual, modelo_id, fabrica_automovil_id) 
			VALUES (p_capacidad_productiva_promedio, p_estado, p_cantidad_vehiculos_actual, @v_modelo_id, p_fabrica_automovil_id);
			
			SET @v_linea_montaje_id = LAST_INSERT_ID(); 
            CALL asignar_estaciones_trabajo(@v_linea_montaje_id, p_nResultado, p_cMensaje);
            
			CALL generar_productos_para_modelo(p_modelo, p_nResultado, p_cMensaje);
            
			SET p_nResultado = 0;
			SET p_cMensaje = '';
        END IF;
	
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_linea_montaje`(
    IN p_linea_montaje_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_modelo_id INT;

    -- Verificar si la línea de montaje existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.linea_montaje
    WHERE linea_montaje_id = p_linea_montaje_id;
    
	SELECT modelo_id INTO v_modelo_id
    FROM tp_fabrica_automovil_bd1.linea_montaje
    WHERE linea_montaje_id = p_linea_montaje_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La línea de montaje no existe.';
    ELSE
        -- Eliminar línea de montaje
        DELETE FROM tp_fabrica_automovil_bd1.linea_montaje
        WHERE linea_montaje_id = p_linea_montaje_id;
        
        CALL sp_baja_modelo(v_modelo_id, p_nResultado, p_cMensaje);

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_linea_montaje`(
    IN p_linea_montaje_id INT,
    IN p_capacidad_productiva_promedio DOUBLE,
    IN p_estado VARCHAR(50),
    IN p_cantidad_vehiculos_actual INT,
    IN p_modelo_id INT,
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_count_modelo_id INT;

    -- Verificar si la línea de montaje existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.linea_montaje
    WHERE linea_montaje_id = p_linea_montaje_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La línea de montaje no existe.';
    ELSE
        -- Verificar si la fábrica de automóviles existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.fabrica_automovil
        WHERE fabrica_automovil_id = p_fabrica_automovil_id;
        
        SELECT COUNT(*) INTO v_count_modelo_id
        FROM tp_fabrica_automovil_bd1.modelo m
        WHERE m.modelo_id = p_modelo_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La fábrica de automóviles no existe.';
		ELSEIF v_count_modelo_id = 0 THEN
			SET p_nResultado = -3;
            SET p_cMensaje = 'El modelo no existe.';
        ELSE
            -- Actualizar línea de montaje
            UPDATE tp_fabrica_automovil_bd1.linea_montaje
            SET capacidad_productiva_promedio = p_capacidad_productiva_promedio,
                estado = p_estado,
                cantidad_vehiculos_actual = p_cantidad_vehiculos_actual,
                modelo_id = p_modelo_id,
                fabrica_automovil_id = p_fabrica_automovil_id
            WHERE linea_montaje_id = p_linea_montaje_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pedido

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_pedido`(
    IN p_fecha_emision DATE,
    IN p_total INT,
    IN p_concesionaria_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE p_fecha_entrega_estimada DATE;
    DECLARE v_pedido_id INT;
    DECLARE v_modelo_id INT;
    DECLARE v_dias_totales INT DEFAULT 0;
    DECLARE v_fecha_entrega DATE;
    DECLARE v_cantidad_vehiculos INT;
    DECLARE v_dias_por_vehiculo INT;
    DECLARE done INT DEFAULT 0;
    
	-- Obtener los detalles del pedido y calcular fechas de entrega para cada vehículo
	DECLARE cur CURSOR FOR 
		SELECT modelo_id FROM tp_fabrica_automovil_bd1.pedido_detalle WHERE pedido_id = v_pedido_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Inicializar variables
    SET p_fecha_entrega_estimada = ADDDATE(CURDATE(), INTERVAL 7 DAY);

    -- Verificar si la concesionaria existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.concesionaria
    WHERE concesionaria_id = p_concesionaria_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La concesionaria no existe.';
    ELSE
        -- Insertar nuevo pedido
        INSERT INTO tp_fabrica_automovil_bd1.pedido (fecha_emision, fecha_entrega_estimada, total, concesionaria_id)
        VALUES (p_fecha_emision, p_fecha_entrega_estimada, p_total, p_concesionaria_id);

        -- Obtener el ID del pedido recién insertado
        SET v_pedido_id = LAST_INSERT_ID();

        OPEN cur;

        read_loop: LOOP
            FETCH cur INTO v_modelo_id;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Calcular el total de días necesarios para todas las estaciones de trabajo asociadas al modelo del vehículo
            SELECT SUM(et.demora_estimada_dias) INTO v_dias_totales
            FROM tp_fabrica_automovil_bd1.estacion_trabajo et
            JOIN tp_fabrica_automovil_bd1.linea_montaje lm ON lm.linea_montaje_id = et.linea_montaje_id
            WHERE lm.modelo_id = v_modelo_id;

            -- Contar la cantidad de vehículos del mismo modelo en pedidos pendientes (excluyendo el actual)
            SELECT COUNT(*) INTO v_cantidad_vehiculos
            FROM tp_fabrica_automovil_bd1.pedido_detalle pd
            JOIN tp_fabrica_automovil_bd1.vehiculo v ON v.pedido_detalle_id = pd.pedido_detalle_id
            WHERE v.modelo_id = v_modelo_id
            AND pd.pedido_id <> v_pedido_id;

            -- Calcular el tiempo total requerido (días por vehículo multiplicado por la cantidad)
            SET v_dias_por_vehiculo = v_dias_totales * v_cantidad_vehiculos;

            -- Calcular la nueva fecha de entrega
            SET v_fecha_entrega = DATE_ADD(p_fecha_entrega_estimada, INTERVAL v_dias_por_vehiculo DAY);

            -- Actualizar la fecha de entrega estimada en la tabla de pedidos
            UPDATE tp_fabrica_automovil_bd1.pedido
            SET fecha_entrega_estimada = v_fecha_entrega
            WHERE pedido_id = v_pedido_id;
        END LOOP;

        CLOSE cur;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_pedido`(
    IN p_pedido_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el pedido existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.pedido
    WHERE pedido_id = p_pedido_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El pedido no existe.';
    ELSE
        -- Verificar si hay detalles de pedido asociados
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.pedido_detalle
        WHERE pedido_id = p_pedido_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'No se puede eliminar el pedido, tiene detalles asociados.';
        ELSE
            -- Eliminar pedido
            DELETE FROM tp_fabrica_automovil_bd1.pedido
            WHERE pedido_id = p_pedido_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_pedido`(
    IN p_pedido_id INT,
    IN p_fecha_emision DATE,
    IN p_fecha_entrega_estimada DATE,
    IN p_total INT,
    IN p_concesionaria_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el pedido existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.pedido
    WHERE pedido_id = p_pedido_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El pedido no existe.';
    ELSE
        -- Verificar si la concesionaria existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.concesionaria
        WHERE concesionaria_id = p_concesionaria_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La concesionaria no existe.';
        ELSE
            -- Actualizar pedido
            UPDATE tp_fabrica_automovil_bd1.pedido
            SET fecha_emision = p_fecha_emision,
                fecha_entrega_estimada = p_fecha_entrega_estimada,
                total = p_total,
                concesionaria_id = p_concesionaria_id
            WHERE pedido_id = p_pedido_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pedido detalle

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_pedido_detalle`(
    IN p_pedido_id INT,
    IN p_vehiculo_modelo VARCHAR(40),
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_modelo_id INT;
    DECLARE v_precio_vehiculo DOUBLE;
    DECLARE v_total_actual DOUBLE;
    DECLARE v_total_nuevo DOUBLE;
    DECLARE v_total_dias INT DEFAULT 0;
    DECLARE v_fecha_entrega_pedido DATETIME;
    DECLARE v_fecha_entrega_pedido_detalle DATETIME;
    DECLARE v_cantidad_pedidos_entregados INT;
    DECLARE v_cantidad_dias_porcentaje INT;
    DECLARE v_precio_modelo DOUBLE;
    
	-- Establecer el resultado y mensaje
	SET p_nResultado = 0;
	SET p_cMensaje = '';

    -- Verificar si el pedido existe
    SELECT pedido_id INTO v_count
    FROM tp_fabrica_automovil_bd1.pedido
    WHERE pedido_id = p_pedido_id;
    
	-- Obtener el modelo_id del vehículo
	SELECT modelo_id INTO v_modelo_id 
	FROM tp_fabrica_automovil_bd1.modelo 
	WHERE modelo = p_vehiculo_modelo;

    IF v_count IS NULL THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El pedido no existe.';
	ELSEIF v_modelo_id IS NULL THEN
        SET p_nResultado = -2;
        SET p_cMensaje = 'El modelo no existe.';
    ELSE
		SET v_precio_modelo = obtener_precio_por_modelo(v_modelo_id);
        
		IF v_precio_modelo = 10000.00 THEN
			SET p_nResultado = -3;
			SET p_cMensaje = 'El modelo tiene precio generico.';
		END IF;
        
		-- Obtener el precio del vehículo basado en el modelo_id
		SET v_precio_vehiculo = obtener_precio_por_modelo(v_modelo_id);
		
		-- Insertar el detalle del pedido
		INSERT INTO tp_fabrica_automovil_bd1.pedido_detalle (estado, total, cantidad, modelo_id, pedido_id) 
		VALUES ('Recibido', p_cantidad * v_precio_vehiculo, p_cantidad, v_modelo_id, p_pedido_id);
		
		-- Obtener el total actual del pedido
		SELECT COALESCE(total, 0) INTO v_total_actual
		FROM tp_fabrica_automovil_bd1.pedido
		WHERE pedido_id = p_pedido_id;

		-- Calcular el nuevo total del pedido
		SET v_total_nuevo = v_total_actual + (p_cantidad * v_precio_vehiculo);

		-- Actualizar el total del pedido
		UPDATE tp_fabrica_automovil_bd1.pedido 
		SET total = v_total_nuevo
		WHERE pedido_id = p_pedido_id;

		-- Obtener el tiempo de construcción total para el modelo
		SET v_total_dias = calcular_tiempo_construccion(v_modelo_id) + 7;
		
		-- Calcular la fecha de entrega del pedido detalle
		SET v_fecha_entrega_pedido_detalle = DATE_ADD(CURDATE(), INTERVAL v_total_dias DAY);

		-- Obtener la fecha de entrega estimada actual del pedido
		SELECT fecha_entrega_estimada INTO v_fecha_entrega_pedido
		FROM tp_fabrica_automovil_bd1.pedido
		WHERE pedido_id = p_pedido_id;

		SELECT COUNT(*) INTO v_cantidad_pedidos_entregados
		FROM tp_fabrica_automovil_bd1.pedido
		WHERE fecha_entrega_estimada > CURDATE();
		
		IF v_cantidad_pedidos_entregados > 0 THEN
			SET v_cantidad_dias_porcentaje = (((v_total_dias * 50) / 100) * v_cantidad_pedidos_entregados-1) + v_total_dias;
			SET v_fecha_entrega_pedido_detalle = DATE_ADD(CURDATE(), INTERVAL v_cantidad_dias_porcentaje DAY);
		END IF;

		-- Actualizar la fecha de entrega estimada si es necesario
		IF v_fecha_entrega_pedido_detalle > v_fecha_entrega_pedido THEN
			UPDATE tp_fabrica_automovil_bd1.pedido 
			SET fecha_entrega_estimada = v_fecha_entrega_pedido_detalle
			WHERE pedido_id = p_pedido_id;
		END IF;
        
    END IF;

    -- Retornar el mensaje
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- DROP PROCEDURE `sp_alta_pedido_detalle`;

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_pedido_detalle`(
    IN p_pedido_detalle_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el detalle de pedido existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.pedido_detalle
    WHERE pedido_detalle_id = p_pedido_detalle_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El detalle de pedido no existe.';
    ELSE
        -- Eliminar detalle de pedido
        DELETE FROM tp_fabrica_automovil_bd1.pedido_detalle
        WHERE pedido_detalle_id = p_pedido_detalle_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_pedido_detalle`(
    IN p_pedido_detalle_id INT,
	IN p_estado VARCHAR(50),
    IN p_total DOUBLE,
	IN p_cantidad INT,
    IN p_modelo_id INT,
    IN p_pedido_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_count_modelo_id INT;

    -- Verificar si el detalle de pedido existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.pedido_detalle
    WHERE pedido_detalle_id = p_pedido_detalle_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El detalle de pedido no existe.';
    ELSE
        -- Verificar si el pedido existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.pedido
        WHERE pedido_id = p_pedido_id;
        
		SELECT modelo_id INTO v_count_modelo_id
        FROM tp_fabrica_automovil_bd1.modelo m
        WHERE m.modelo_id = p_modelo_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'El pedido no existe.';
        ELSEIF v_count_modelo_id = 0 THEN
			SET p_nResultado = -3;
            SET p_cMensaje = 'El modelo no existe.';
        ELSE 
			-- Actualizar detalle de pedido
			UPDATE tp_fabrica_automovil_bd1.pedido_detalle
			SET cantidad = p_cantidad,
				estado = p_estado,
				total = p_total,
				pedido_id = p_pedido_id
			WHERE pedido_detalle_id = p_pedido_detalle_id;

			SET p_nResultado = 0;
			SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Producto

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_producto`(
    IN p_nombre VARCHAR(40),
    IN p_descripcion VARCHAR(80),
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la fábrica de automóviles existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.fabrica_automovil
    WHERE fabrica_automovil_id = p_fabrica_automovil_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La fábrica de automóviles no existe.';
    ELSE
        -- Insertar nuevo producto
        INSERT INTO tp_fabrica_automovil_bd1.producto (nombre, descripcion, fabrica_automovil_id)
        VALUES (p_nombre, p_descripcion, p_fabrica_automovil_id);

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_producto`(
    IN p_producto_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el producto existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto
    WHERE producto_id = p_producto_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El producto no existe.';
    ELSE
        -- Eliminar producto
        DELETE FROM tp_fabrica_automovil_bd1.producto
        WHERE producto_id = p_producto_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_producto`(
    IN p_producto_id INT,
    IN p_nombre VARCHAR(40),
    IN p_descripcion VARCHAR(80),
    IN p_fabrica_automovil_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el producto existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto
    WHERE producto_id = p_producto_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El producto no existe.';
    ELSE
        -- Verificar si la fábrica de automóviles existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.fabrica_automovil
        WHERE fabrica_automovil_id = p_fabrica_automovil_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La fábrica de automóviles no existe.';
        ELSE
            -- Actualizar producto
            UPDATE tp_fabrica_automovil_bd1.producto
            SET nombre = p_nombre,
                descripcion = p_descripcion,
                fabrica_automovil_id = p_fabrica_automovil_id
            WHERE producto_id = p_producto_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Producto proveedor

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_producto_proveedor`(
    IN p_producto_id INT,
    IN p_proveedor_id INT,
    IN p_precio DOUBLE,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
	DECLARE existe_producto_id INT;
    DECLARE existe_proveedor_id INT;
	SET p_nResultado = 0;
	SET p_cMensaje = '';
    
    SELECT producto_id INTO existe_producto_id FROM producto p WHERE p.producto_id = p_producto_id;
    SELECT proveedor_id INTO existe_proveedor_id FROM proveedor p WHERE p.proveedor_id = p_proveedor_id;
    
    IF existe_producto_id IS NULL THEN
		SET p_nResultado = -1;
		SET p_cMensaje = 'No existe el producto';
	ELSEIF existe_proveedor_id IS NULL THEN
    	SET p_nResultado = -2;
		SET p_cMensaje = 'No existe el proveedor';
    ELSE 
		INSERT INTO producto_proveedor(producto_id, proveedor_id, precio, cantidad) VALUES (p_producto_id, p_proveedor_id, p_precio, p_cantidad);
	END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_producto_proveedor`(
    IN p_producto_id INT,
    IN p_proveedor_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la relación existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto_proveedor
    WHERE producto_id = p_producto_id AND proveedor_id = p_proveedor_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La relación producto-proveedor no existe.';
    ELSE
        -- Eliminar relación
        DELETE FROM tp_fabrica_automovil_bd1.producto_proveedor
        WHERE producto_id = p_producto_id AND proveedor_id = p_proveedor_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_producto_proveedor`(
    IN p_producto_id INT,
    IN p_proveedor_id INT,
    IN p_precio DOUBLE,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la relación existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto_proveedor
    WHERE producto_id = p_producto_id AND proveedor_id = p_proveedor_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La relación producto-proveedor no existe.';
    ELSE
        -- Actualizar relación
        UPDATE tp_fabrica_automovil_bd1.producto_proveedor
        SET precio = p_precio,
            cantidad = p_cantidad
        WHERE producto_id = p_producto_id AND proveedor_id = p_proveedor_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Producto vehiculo

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_producto_vehiculo`(
    IN p_producto_id INT,
    IN p_modelo_id INT,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_count_producto_id INT;
    DECLARE v_count_modelo_id INT;
    
	SET p_nResultado = 0;
	SET p_cMensaje = '';

    -- Verificar si la relación ya existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto_vehiculo
    WHERE producto_id = p_producto_id AND modelo_id = p_modelo_id;
    
	SELECT COUNT(*) INTO v_count_producto_id
    FROM tp_fabrica_automovil_bd1.producto
    WHERE producto_id = p_producto_id;
	
    SELECT COUNT(*) INTO v_count_modelo_id
    FROM tp_fabrica_automovil_bd1.modelo
    WHERE modelo_id = p_modelo_id;

    IF v_count > 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La relación producto-vehículo-proveedor ya existe.';
	ELSEIF v_count_modelo_id = 0 THEN
		SET p_nResultado = -2;
        SET p_cMensaje = 'El modelo no existe';
	ELSEIF v_count_producto_id = 0 THEN
		SET p_nResultado = -3;
        SET p_cMensaje = 'El producto no existe';
    ELSE
        INSERT INTO tp_fabrica_automovil_bd1.producto_vehiculo (producto_id, modelo_id, cantidad)
        VALUES (p_producto_id, p_modelo_id, p_cantidad);
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_producto_vehiculo`(
    IN p_producto_id INT,
    IN p_modelo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la relación existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto_vehiculo
    WHERE producto_id = p_producto_id AND modelo_id = p_modelo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La relación producto-vehículo-proveedor no existe.';
    ELSE
        -- Eliminar relación
        DELETE FROM tp_fabrica_automovil_bd1.producto_vehiculo
        WHERE producto_id = p_producto_id AND modelo_id = p_modelo_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_producto_vehiculo`(
    IN p_producto_id INT,
    IN p_modelo_id INT,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
	DECLARE v_count_producto_id INT;
    DECLARE v_count_modelo_id INT;
    
	SET p_nResultado = 0;
	SET p_cMensaje = '';

    -- Verificar si la relación existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.producto_vehiculo
    WHERE producto_id = p_producto_id AND modelo_id = p_modelo_id;
    
	SELECT COUNT(*) INTO v_count_producto_id
    FROM tp_fabrica_automovil_bd1.producto
    WHERE producto_id = p_producto_id;
    
	SELECT COUNT(*) INTO v_count_modelo_id
    FROM tp_fabrica_automovil_bd1.modelo
    WHERE modelo_id = p_modelo_id;
    
    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La relación producto-vehículo no existe.';
	ELSEIF v_count_producto_id = 0 THEN
		SET p_nResultado = -2;
        SET p_cMensaje = 'El producto no existe.';
    ELSEIF v_count_modelo_id = 0 THEN
		SET p_nResultado = -3;
        SET p_cMensaje = 'El modelo no existe.';
    ELSE 
		UPDATE producto_vehiculo SET producto_id = p_producto_id, modelo_id = p_modelo_id, cantidad = p_cantidad WHERE producto_id = p_producto_id AND modelo_id = p_modelo_id;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Proveedor

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_proveedor`(
    IN p_nombre VARCHAR(40),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el proveedor ya existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.proveedor
    WHERE nombre = p_nombre;

    IF v_count > 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El proveedor ya existe.';
    ELSE
        -- Insertar nuevo proveedor
        INSERT INTO tp_fabrica_automovil_bd1.proveedor (nombre)
        VALUES (p_nombre);

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_proveedor`(
    IN p_proveedor_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el proveedor existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.proveedor
    WHERE proveedor_id = p_proveedor_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El proveedor no existe.';
    ELSE
        -- Verificar si el proveedor está en uso en otras tablas
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.producto_proveedor
        WHERE proveedor_id = p_proveedor_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'El proveedor no se puede eliminar porque está asociado a productos.';
        ELSE
            -- Eliminar proveedor
            DELETE FROM tp_fabrica_automovil_bd1.proveedor
            WHERE proveedor_id = p_proveedor_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_proveedor`(
    IN p_proveedor_id INT,
    IN p_nombre VARCHAR(40),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el proveedor existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.proveedor
    WHERE proveedor_id = p_proveedor_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El proveedor no existe.';
    ELSE
        -- Verificar si el nuevo nombre ya está en uso
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.proveedor
        WHERE nombre = p_nombre AND proveedor_id != p_proveedor_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'El nombre del proveedor ya está en uso.';
        ELSE
            -- Actualizar proveedor
            UPDATE tp_fabrica_automovil_bd1.proveedor
            SET nombre = p_nombre
            WHERE proveedor_id = p_proveedor_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registro venta

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_registro_venta`(
    IN p_fecha_emision DATE,
    IN p_total DOUBLE,
    IN p_concesionaria_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si la concesionaria existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.concesionaria
    WHERE concesionaria_id = p_concesionaria_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'La concesionaria no existe.';
    ELSE
        -- Insertar nuevo registro de venta
        INSERT INTO tp_fabrica_automovil_bd1.registro_venta (fecha_emision, total, concesionaria_id)
        VALUES (p_fecha_emision, p_total, p_concesionaria_id);

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_registro_venta`(
    IN p_registro_venta_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el registro de venta existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.registro_venta
    WHERE registro_venta_id = p_registro_venta_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El registro de venta no existe.';
    ELSE
        -- Eliminar registro de venta
        DELETE FROM tp_fabrica_automovil_bd1.registro_venta
        WHERE registro_venta_id = p_registro_venta_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER


DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_registro_venta`(
    IN p_registro_venta_id INT,
    IN p_fecha_emision DATE,
    IN p_total DOUBLE,
    IN p_concesionaria_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el registro de venta existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.registro_venta
    WHERE registro_venta_id = p_registro_venta_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El registro de venta no existe.';
    ELSE
        -- Verificar si la concesionaria existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.concesionaria
        WHERE concesionaria_id = p_concesionaria_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La concesionaria no existe.';
        ELSE
            -- Actualizar registro de venta
            UPDATE tp_fabrica_automovil_bd1.registro_venta
            SET fecha_emision = p_fecha_emision,
                total = p_total,
                concesionaria_id = p_concesionaria_id
            WHERE registro_venta_id = p_registro_venta_id;

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Vehiculo

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_vehiculo`(
    IN p_numero_chasis VARCHAR(40),
    IN p_modelo_id INT,  
    IN p_fecha_ingreso DATE,
    IN p_fecha_egreso DATE,
    IN p_precio DOUBLE,
    IN p_fabrica_automovil_id INT,
    IN p_linea_montaje_id INT,
    IN p_pedido_detalle_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el número de chasis ya existe
    SELECT COUNT(*) INTO v_count FROM tp_fabrica_automovil_bd1.vehiculo WHERE numero_chasis = p_numero_chasis;

    IF v_count > 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El número de chasis ya existe.';
    ELSE
        -- Verificar si la fábrica de automóviles existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.fabrica_automovil
        WHERE fabrica_automovil_id = p_fabrica_automovil_id;

        IF v_count = 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'La fábrica de automóviles no existe.';
        ELSE
            -- Insertar nuevo vehículo
			INSERT INTO tp_fabrica_automovil_bd1.vehiculo (numero_chasis, modelo_id, fecha_ingreso, fecha_egreso, precio, fabrica_automovil_id, linea_montaje_id, pedido_detalle_id) 
			VALUES (p_numero_chasis, p_modelo_id, p_fecha_ingreso, p_fecha_egreso, p_precio, p_fabrica_automovil_id, p_linea_montaje_id, p_pedido_detalle_id);

            SET p_nResultado = 0;
            SET p_cMensaje = '';
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_vehiculo`(
    IN p_vehiculo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el vehículo existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.vehiculo
    WHERE vehiculo_id = p_vehiculo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El vehículo no existe.';
    ELSE
        -- Eliminar vehículo
        DELETE FROM tp_fabrica_automovil_bd1.vehiculo
        WHERE vehiculo_id = p_vehiculo_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_vehiculo`(
    IN p_vehiculo_id INT,
    IN p_numero_chasis VARCHAR(10),
    IN p_modelo_id INT,
    IN p_fecha_ingreso DATE,
    IN p_fecha_egreso DATE,
    IN p_precio DOUBLE,
    IN p_fabrica_automovil_id INT,
    IN p_linea_montaje_id INT,
    IN p_pedido_detalle_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el vehículo existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.vehiculo
    WHERE vehiculo_id = p_vehiculo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El vehículo no existe.';
    ELSE
        -- Verificar si el número de chasis ya existe (para otros vehículos)
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.vehiculo
        WHERE numero_chasis = p_numero_chasis AND vehiculo_id <> p_vehiculo_id;

        IF v_count > 0 THEN
            SET p_nResultado = -2;
            SET p_cMensaje = 'El número de chasis ya existe.';
        ELSE
            -- Verificar si la fábrica de automóviles existe
            SELECT COUNT(*) INTO v_count
            FROM tp_fabrica_automovil_bd1.fabrica_automovil
            WHERE fabrica_automovil_id = p_fabrica_automovil_id;

            IF v_count = 0 THEN
                SET p_nResultado = -3;
                SET p_cMensaje = 'La fábrica de automóviles no existe.';
            ELSE
                -- Actualizar vehículo
                UPDATE tp_fabrica_automovil_bd1.vehiculo
                SET numero_chasis = p_numero_chasis,
                    modelo_id = p_modelo_id,
                    fecha_ingreso = p_fecha_ingreso,
                    fecha_egreso = p_fecha_egreso,
                    precio = p_precio,
                    fabrica_automovil_id = p_fabrica_automovil_id,
                    linea_montaje_id = p_linea_montaje_id,
                    pedido_detalle_id = p_pedido_detalle_id
                WHERE vehiculo_id = p_vehiculo_id;

                SET p_nResultado = 0;
                SET p_cMensaje = '';
            END IF;
        END IF;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Estacion trabajo vehiculo

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_estacion_trabajo_vehiculo`(
    IN p_estacion_trabajo_id INT,
    IN p_vehiculo_id INT,
    IN p_fecha_ingreso DATE,
    IN p_fecha_egreso DATE,
    IN p_finalizado TINYINT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_estacion_trabajo_id INT;
    DECLARE v_vehiculo_id INT;
    
	SET p_nResultado = 0;
	SET p_cMensaje = '';

    -- Verificar si ya existe el registro estacion_trabajo_vehiculo
    SELECT COUNT(*) INTO v_estacion_trabajo_id
    FROM tp_fabrica_automovil_bd1.estacion_trabajo et
    WHERE et.estacion_trabajo_id = p_estacion_trabajo_id;
    
	SELECT COUNT(*) INTO v_vehiculo_id
    FROM tp_fabrica_automovil_bd1.vehiculo v
    WHERE v.vehiculo_id = p_vehiculo_id;

	IF v_estacion_trabajo_id = 0 THEN
		SET p_nResultado = -1;
		SET p_cMensaje = 'La estacion de trabajo no existe';
    ELSEIF v_vehiculo_id = 0 THEN
		SET p_nResultado = -2;
		SET p_cMensaje = 'El vehiculo no existe';
    ELSE 
    	INSERT INTO tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo (estacion_trabajo_id, vehiculo_id, fecha_ingreso, fecha_egreso, finalizado)
		VALUES (p_estacion_trabajo_id, p_vehiculo_id, p_fecha_ingreso, p_fecha_egreso, p_finalizado);
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;

END


&& DELIMITER

DELIMITER &&

CREATE PROCEDURE sp_baja_estacion_trabajo_vehiculo(
    IN p_estacion_trabajo_id INT,
    IN p_vehiculo_id INT,
    OUT nResultado INT,
    OUT cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_existente INT;

    -- Verificar si el registro estacion_trabajo_vehiculo existe
    SELECT COUNT(*) INTO v_existente
    FROM tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo
    WHERE estacion_trabajo_id = p_estacion_trabajo_id AND vehiculo_id = p_vehiculo_id;

    IF v_existente = 0 THEN
        SET nResultado = -1;
        SET cMensaje = 'El registro de estacion_trabajo_vehiculo no existe.';
    ELSE
        DELETE FROM tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo
        WHERE estacion_trabajo_id = p_estacion_trabajo_id AND vehiculo_id = p_vehiculo_id;

        SET nResultado = 0;
        SET cMensaje = '';
    END IF;
END


&& DELIMITER


DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_estacion_trabajo_vehiculo`(
    IN p_estacion_trabajo_id INT,
    IN p_vehiculo_id INT,
    IN p_fecha_ingreso DATE,
    IN p_fecha_egreso DATE,
    IN p_finalizado TINYINT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_estacion_trabajo_id INT;
    DECLARE v_vehiculo_id INT;
    
	SET p_nResultado = 0;
	SET p_cMensaje = '';

    -- Verificar si ya existe el registro estacion_trabajo_vehiculo
    SELECT COUNT(*) INTO v_estacion_trabajo_id
    FROM tp_fabrica_automovil_bd1.estacion_trabajo et
    WHERE et.estacion_trabajo_id = p_estacion_trabajo_id;
    
	SELECT COUNT(*) INTO v_vehiculo_id
    FROM tp_fabrica_automovil_bd1.vehiculo v
    WHERE v.vehiculo_id = p_vehiculo_id;

	IF v_estacion_trabajo_id = 0 THEN
		SET p_nResultado = -1;
		SET p_cMensaje = 'La estacion de trabajo no existe';
    ELSEIF v_vehiculo_id = 0 THEN
		SET p_nResultado = -2;
		SET p_cMensaje = 'El vehiculo no existe';
    ELSE 
    	UPDATE tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo etv
		SET 
			estacion_trabajo_id = p_estacion_trabajo_id, 
            vehiculo_id = p_vehiculo_id, 
            fecha_ingreso = p_fecha_ingreso, 
            fecha_egreso = p_fecha_egreso, 
            finalizado = p_finalizado
		WHERE etv.vehiculo_id = p_vehiculo_id
			AND etv.estacion_trabajo_id = p_estacion_trabajo_id;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Estacion trabajo producto

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_alta_estacion_trabajo_producto`(
    IN p_estacion_trabajo_id INT,
    IN p_producto_id INT,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count_estacion_trabajo_id INT;
    DECLARE v_count_producto_id INT;
    
	SET p_nResultado = 0;
	SET p_cMensaje = '';

    -- Verificar si ya existe un registro con las mismas claves
    SELECT COUNT(*) INTO v_count_estacion_trabajo_id
    FROM tp_fabrica_automovil_bd1.estacion_trabajo
    WHERE estacion_trabajo_id = p_estacion_trabajo_id;
    
	SELECT COUNT(*) INTO v_count_producto_id
    FROM tp_fabrica_automovil_bd1.producto
	WHERE producto_id = p_producto_id;

	IF v_count_estacion_trabajo_id = 0 THEN
    	SET p_nResultado = -1;
		SET p_cMensaje = 'La estacion de trabajo no existe';
    ELSEIF v_count_producto_id = 0 THEN
    	SET p_nResultado = -2;
		SET p_cMensaje = 'El producto no existe';
    ELSE
    	-- Insertar el nuevo registro
		INSERT INTO tp_fabrica_automovil_bd1.estacion_trabajo_producto (estacion_trabajo_id, producto_id, cantidad)
		VALUES (p_estacion_trabajo_id, p_producto_id, p_cantidad);
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_baja_estacion_trabajo_producto`(
    IN p_estacion_trabajo_id INT,
    IN p_producto_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el registro existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.estacion_trabajo_producto
    WHERE estacion_trabajo_id = p_estacion_trabajo_id
    AND producto_id = p_producto_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El registro no existe';
    ELSE
        -- Eliminar el registro
        DELETE FROM tp_fabrica_automovil_bd1.estacion_trabajo_producto
        WHERE estacion_trabajo_id = p_estacion_trabajo_id
        AND producto_id = p_producto_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
END


&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_modificacion_estacion_trabajo_producto`(
    IN p_estacion_trabajo_id INT,
    IN p_producto_id INT,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;
    DECLARE v_count_estacion_trabajo_id INT;
    DECLARE v_count_producto_id INT;

    -- Verificar si el registro original existe
    SELECT COUNT(*) INTO v_count
    FROM tp_fabrica_automovil_bd1.estacion_trabajo_producto
    WHERE estacion_trabajo_id = p_estacion_trabajo_id
    AND producto_id = p_producto_id;
    
	SELECT COUNT(*) INTO v_count_estacion_trabajo_id
    FROM tp_fabrica_automovil_bd1.estacion_trabajo
    WHERE estacion_trabajo_id = p_estacion_trabajo_id;
    
	SELECT COUNT(*) INTO v_count_producto_id
    FROM tp_fabrica_automovil_bd1.producto
    WHERE producto_id = p_producto_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El registro original no existe';
    ELSEIF v_count_estacion_trabajo_id = 0 THEN
		SET p_nResultado = -2;
        SET p_cMensaje = 'La estacion de trabajo no existe';
    ELSEIF v_count_producto_id = 0 THEN
		SET p_nResultado = -3;
        SET p_cMensaje = 'El producto no existe';
    ELSE
		-- Actualizar el registro
		UPDATE tp_fabrica_automovil_bd1.estacion_trabajo_producto
		SET estacion_trabajo_id = p_estacion_trabajo_id,
			producto_id = p_producto_id,
			cantidad = p_cantidad
		WHERE estacion_trabajo_id = p_estacion_trabajo_id
		AND producto_id = p_producto_id;

		SET p_nResultado = 0;
		SET p_cMensaje = '';
    END IF;
END

&& DELIMITER

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Modelo

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE PROCEDURE sp_alta_modelo(
    IN p_modelo VARCHAR(50),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el modelo ya existe
    SELECT COUNT(*) INTO v_count
    FROM modelo
    WHERE modelo = p_modelo;

    IF v_count > 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El modelo ya existe.';
    ELSE
        -- Insertar nuevo modelo
        INSERT INTO modelo (modelo)
        VALUES (p_modelo);

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
END 

&& DELIMITER;

DELIMITER &&

CREATE PROCEDURE sp_baja_modelo(
    IN p_modelo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el modelo existe
    SELECT COUNT(*) INTO v_count
    FROM modelo
    WHERE modelo_id = p_modelo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El modelo no existe.';
    ELSE
        -- Eliminar el modelo
        DELETE FROM modelo
        WHERE modelo_id = p_modelo_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
END 

&& DELIMITER ;

DELIMITER &&

CREATE PROCEDURE sp_modificacion_modelo(
    IN p_modelo_id INT,
    IN p_nuevo_modelo VARCHAR(50),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    -- Verificar si el modelo existe
    SELECT COUNT(*) INTO v_count
    FROM modelo
    WHERE modelo_id = p_modelo_id;

    IF v_count = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El modelo no existe.';
    ELSE
        -- Actualizar el modelo
        UPDATE modelo
        SET modelo = p_nuevo_modelo
        WHERE modelo_id = p_modelo_id;

        SET p_nResultado = 0;
        SET p_cMensaje = '';
    END IF;
END 

&& DELIMITER ;


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Stored Procedures Auxiliares

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_proveedor_precio`(
    IN p_modelo_id INT,
    IN p_cantidad INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_producto_id INT;
    DECLARE v_proveedor_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_precio DECIMAL(10, 2);
    DECLARE v_precio_modelo DOUBLE;
    DECLARE v_precio_minimo DOUBLE;
    DECLARE v_precio_maximo DOUBLE;
    DECLARE v_cantidad_estaciones INT;
    DECLARE done INT DEFAULT 0;
    
    -- Cursor para recorrer la tabla producto_vehiculo
    DECLARE cur CURSOR FOR
        SELECT producto_id, cantidad
        FROM tp_fabrica_automovil_bd1.producto_vehiculo
        WHERE modelo_id = p_modelo_id;
    
    -- Manejador para el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	SET v_precio_modelo = obtener_precio_por_modelo(p_modelo_id);

    -- Abrir el cursor
    OPEN cur;

    -- Recorrer los productos asociados al modelo
    read_loop: LOOP
        FETCH cur INTO v_producto_id, v_cantidad;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Seleccionar un proveedor aleatorio
        SET v_proveedor_id = (
            SELECT proveedor_id 
            FROM tp_fabrica_automovil_bd1.proveedor 
            ORDER BY RAND() 
            LIMIT 1
        );

		-- Contar la cantidad de estaciones de trabajo para un modelo específico
		SELECT COUNT(et.estacion_trabajo_id) INTO v_cantidad_estaciones
		FROM tp_fabrica_automovil_bd1.linea_montaje lm
		JOIN tp_fabrica_automovil_bd1.estacion_trabajo et ON lm.linea_montaje_id = et.linea_montaje_id
		WHERE lm.modelo_id = p_modelo_id;
        SET v_precio = (v_precio_modelo / v_cantidad_estaciones);
        SET v_precio_minimo = v_precio - ((v_precio_modelo * 5) / 100);
		SET v_precio_maximo = v_precio + ((v_precio_modelo * 10) / 100);
		SET v_precio = FLOOR(v_precio_minimo + (RAND() * (v_precio_maximo - v_precio_minimo))) / v_cantidad;

		SET @i = 0;
		WHILE @i < p_cantidad DO
			-- Insertar en la tabla intermedia producto_proveedor
			INSERT INTO tp_fabrica_automovil_bd1.producto_proveedor (producto_id, proveedor_id, precio, cantidad)
			VALUES (v_producto_id, v_proveedor_id, v_precio, v_cantidad);
            SET @i = @i + 1;
        END WHILE;
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;
END

&& DELIMITER 