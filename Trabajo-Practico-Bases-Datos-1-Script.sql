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

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_productos_a_estaciones`(
    IN p_linea_montaje_id INT,
    IN p_modelo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_estacion_trabajo_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE i INT;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad INT;

    -- Cursor para obtener las estaciones de trabajo en la línea de montaje
    DECLARE cur_estaciones CURSOR FOR
        SELECT estacion_trabajo_id
        FROM tp_fabrica_automovil_bd1.estacion_trabajo
        WHERE linea_montaje_id = p_linea_montaje_id
        ORDER BY estacion_trabajo_id ASC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';
    
	SELECT producto_id INTO v_producto_id FROM tp_fabrica_automovil_bd1.producto_vehiculo pv WHERE pv.modelo_id = p_modelo_id ORDER BY pv.producto_id ASC LIMIT 1;

    -- Abrir el cursor de estaciones de trabajo
    OPEN cur_estaciones;

    -- Recorrer las estaciones de trabajo de la línea de montaje
    read_estaciones_loop: LOOP
        FETCH cur_estaciones INTO v_estacion_trabajo_id;
        IF done THEN
            LEAVE read_estaciones_loop;
        END IF;
        
		IF (SELECT producto_id FROM tp_fabrica_automovil_bd1.producto p WHERE p.producto_id = v_producto_id) IS NOT NULL THEN
			SELECT cantidad INTO v_cantidad FROM tp_fabrica_automovil_bd1.producto_vehiculo pv WHERE pv.modelo_id = p_modelo_id AND pv.producto_id = v_producto_id ORDER BY pv.producto_id ASC LIMIT 1;
			-- Llamar al procedimiento para asignar productos a la estación de trabajo
			INSERT INTO tp_fabrica_automovil_bd1.estacion_trabajo_producto (estacion_trabajo_id, producto_id, cantidad) VALUES (v_estacion_trabajo_id, v_producto_id, v_cantidad);
        END IF;
        
        SET v_producto_id = v_producto_id + 1;
        
        -- Verificar si hubo un error en la asignación de productos
        IF p_nResultado < 0 THEN
            LEAVE read_estaciones_loop;
        END IF;

    END LOOP;

    -- Cerrar el cursor de estaciones de trabajo
    CLOSE cur_estaciones;

    -- Devolver el mensaje de resultado
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `generar_productos_para_modelo`(
    IN p_modelo VARCHAR(50),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_linea_montaje_id INT;
    DECLARE v_producto_id INT;
    DECLARE v_cantidad_requerida INT;
    DECLARE v_cantidad_final INT;
    DECLARE v_modelo_id INT;
    
    DECLARE v_producto_id_1 INT;
    DECLARE v_producto_id_2 INT;
    DECLARE v_producto_id_3 INT;
    DECLARE v_producto_id_4 INT;
    DECLARE v_producto_id_5 INT;
    DECLARE v_producto_id_6 INT;
    DECLARE v_producto_id_7 INT;
	DECLARE v_producto_id_8 INT;
	DECLARE v_producto_id_9 INT;
	DECLARE v_producto_id_10 INT;
	DECLARE v_producto_id_11 INT;
	DECLARE v_producto_id_12 INT;
    
    SELECT producto_id INTO v_producto_id_1 FROM producto p WHERE p.nombre = 'Chasis';
    SELECT producto_id INTO v_producto_id_2 FROM producto p WHERE p.nombre = 'Motor';
    SELECT producto_id INTO v_producto_id_3 FROM producto p WHERE p.nombre = 'Sistema de transmision';
    SELECT producto_id INTO v_producto_id_4 FROM producto p WHERE p.nombre = 'Sistema de suspension';
    SELECT producto_id INTO v_producto_id_5 FROM producto p WHERE p.nombre = 'Sistema de frenos';
    SELECT producto_id INTO v_producto_id_6 FROM producto p WHERE p.nombre = 'Sistema de direccion';
    SELECT producto_id INTO v_producto_id_7 FROM producto p WHERE p.nombre = 'Sistema de escape';
    SELECT producto_id INTO v_producto_id_8 FROM producto p WHERE p.nombre = 'Sistema electrico';
    SELECT producto_id INTO v_producto_id_9 FROM producto p WHERE p.nombre = 'Interior';
    SELECT producto_id INTO v_producto_id_10 FROM producto p WHERE p.nombre = 'Carroceria';
    SELECT producto_id INTO v_producto_id_11 FROM producto p WHERE p.nombre = 'Cristales';
    SELECT producto_id INTO v_producto_id_12 FROM producto p WHERE p.nombre = 'Pintura';
    
	-- Finalización exitosa
    SET p_nResultado = 0;
    SET p_cMensaje = '';
    
	SELECT modelo_id INTO v_modelo_id FROM tp_fabrica_automovil_bd1.modelo m WHERE m.modelo = p_modelo;
    SELECT linea_montaje_id INTO v_linea_montaje_id FROM tp_fabrica_automovil_bd1.linea_montaje lm WHERE lm.modelo_id = v_modelo_id;
	
    IF v_modelo_id IS NULL THEN
		SET p_nResultado = -1;
        SET p_cMensaje = 'El modelo no existe.';
    ELSEIF v_linea_montaje_id IS NULL THEN
        SET p_nResultado = -2;
        SET p_cMensaje = 'La linea de montaje no existe.';
	ELSE 
    	-- Aplicar lógica según el modelo con CASE
		CASE p_modelo
		
			WHEN 'Renault 12' THEN
				CALL sp_alta_producto_vehiculo(v_producto_id_1, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_2, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_3, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_4, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_5, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_6, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_7, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_8, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_9, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_10, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_11, v_modelo_id, 6, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_12, v_modelo_id, 15, @nResultado, @cMensaje);
                
			WHEN 'Toyota Corolla' THEN
				CALL sp_alta_producto_vehiculo(v_producto_id_1, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_2, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_3, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_4, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_5, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_6, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_7, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_8, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_9, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_10, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_11, v_modelo_id, 6, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_12, v_modelo_id, 20, @nResultado, @cMensaje);
				
			WHEN 'Honda Civic' THEN 
				CALL sp_alta_producto_vehiculo(v_producto_id_1, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_2, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_3, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_4, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_5, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_6, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_7, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_8, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_9, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_10, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_11, v_modelo_id, 6, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_12, v_modelo_id, 25, @nResultado, @cMensaje);

			WHEN 'Ford Mustang' THEN 
				CALL sp_alta_producto_vehiculo(v_producto_id_1, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_2, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_3, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_4, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_5, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_6, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_7, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_8, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_9, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_10, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_11, v_modelo_id, 6, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_12, v_modelo_id, 30, @nResultado, @cMensaje);
				
			WHEN 'Chevrolet Camaro' THEN 
				CALL sp_alta_producto_vehiculo(v_producto_id_1, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_2, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_3, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_4, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_5, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_6, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_7, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_8, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_9, v_modelo_id, 1, @nResultado, @cMensaje);
				CALL sp_alta_producto_vehiculo(v_producto_id_10, v_modelo_id, 1, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_11, v_modelo_id, 6, @nResultado, @cMensaje);
                CALL sp_alta_producto_vehiculo(v_producto_id_12, v_modelo_id, 40, @nResultado, @cMensaje);
				
			ELSE
				SET p_nResultado = -1;
                SET p_cMensaje = CONCAT("Cuidado con el modelo_id = ", v_modelo_id, ", no se le asignaron productos");
		END CASE;
    END IF;
    
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_linea_montaje_vehiculo`(
    IN p_vehiculo_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_modelo VARCHAR(40);
    DECLARE v_precio DOUBLE;
    DECLARE v_fabrica_automovil_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_linea_montaje_id INT;
    DECLARE v_capacidad_productiva_promedio INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur_linea_montaje CURSOR FOR 
        SELECT lm.linea_montaje_id, lm.capacidad_productiva_promedio 
        FROM tp_fabrica_automovil_bd1.linea_montaje lm 
        WHERE lm.fabrica_automovil_id = v_fabrica_automovil_id
        AND lm.modelo = v_modelo  -- Buscar la línea de montaje por modelo
        ORDER BY lm.linea_montaje_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';

    -- Obtener el modelo, fábrica y cantidad del vehículo
    SELECT v.modelo, v.precio, v.fabrica_automovil_id, pd.cantidad 
    INTO v_modelo, v_precio, v_fabrica_automovil_id, v_cantidad
    FROM tp_fabrica_automovil_bd1.vehiculo v 
    JOIN tp_fabrica_automovil_bd1.pedido_detalle pd ON pd.pedido_detalle_id = v.pedido_detalle_id 
    WHERE v.vehiculo_id = p_vehiculo_id;

    IF p_vehiculo_id IS NULL THEN
        SET p_nResultado = -2;
        SET p_cMensaje = 'El vehículo del pedido_detalle no existe';
    ELSE
        -- Verificar si el vehículo ya tiene asignada una línea de montaje
        SELECT linea_montaje_id INTO @tmp_v_linea_montaje_id 
        FROM tp_fabrica_automovil_bd1.vehiculo 
        WHERE vehiculo_id = p_vehiculo_id;

        IF @tmp_v_linea_montaje_id IS NOT NULL THEN
            SET p_nResultado = -8;
            SET p_cMensaje = 'El pedido ya ha sido asignado a una línea de montaje';
        ELSE
            -- Asignar línea de montaje al vehículo
            SET @asignacion_exitosa = FALSE;
            OPEN cur_linea_montaje;
            read_loop: LOOP
                FETCH cur_linea_montaje INTO v_linea_montaje_id, v_capacidad_productiva_promedio;
                IF done THEN
                    LEAVE read_loop;
                END IF;

                -- Asignar la primera línea de montaje disponible
                UPDATE tp_fabrica_automovil_bd1.vehiculo 
                SET linea_montaje_id = v_linea_montaje_id 
                WHERE vehiculo_id = p_vehiculo_id;

                SET @asignacion_exitosa = TRUE;
                LEAVE read_loop;
            END LOOP;
            CLOSE cur_linea_montaje;

            -- Si después de recorrer todas las líneas de montaje no se realizó una asignación exitosa
            IF NOT @asignacion_exitosa THEN
                SET p_nResultado = -9;
                SET p_cMensaje = 'No se pudo encontrar una línea de montaje para el modelo del vehículo.';
            END IF;
        END IF;
    END IF;
END;


&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `cargar_productos_a_estaciones`(
	IN p_pedido_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
	DECLARE v_pedido_detalle_id INT;
    DECLARE v_vehiculo_modelo_id INT;
    DECLARE v_cantidad INT;
    DECLARE v_numero_chasis VARCHAR(40);
    DECLARE v_precio DOUBLE;
    DECLARE v_fecha_ingreso DATETIME DEFAULT CURDATE();
    DECLARE v_fecha_egreso DATETIME;
    DECLARE v_linea_montaje_id INT;
    DECLARE i INT;
    DECLARE done INT DEFAULT 0;
    DECLARE v_fabrica_automovil_id INT DEFAULT 1;
    DECLARE v_linea_montaje_id_prueba INT; 
    
    -- Cursor para recorrer todos los detalles del pedido
    DECLARE cur CURSOR FOR
        SELECT 
            pd.pedido_detalle_id,
            pd.modelo_id,
            pd.cantidad
        FROM 
            tp_fabrica_automovil_bd1.pedido_detalle pd
        WHERE 
            pd.pedido_id = p_pedido_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';

	IF EXISTS (SELECT 1 FROM tp_fabrica_automovil_bd1.pedido WHERE pedido_id = p_pedido_id) THEN
		OPEN cur;

		-- Recorrer los detalles del pedido
		read_loop: LOOP
			FETCH cur INTO v_pedido_detalle_id, v_vehiculo_modelo_id, v_cantidad;
			IF done THEN
				LEAVE read_loop;
			END IF;
            
            SELECT linea_montaje_id INTO v_linea_montaje_id FROM tp_fabrica_automovil_bd1.vehiculo v WHERE v.pedido_detalle_id = v_pedido_detalle_id LIMIT 1;

			-- Reiniciar el contador
			SET i = 0;

			-- Bucle WHILE para ejecutar el procedimiento la cantidad de veces especificada
			WHILE i < v_cantidad DO
				-- Llamar al procedimiento para cargar los productos necesarios para el vehículo
				CALL asignar_productos_a_estaciones(v_linea_montaje_id, v_vehiculo_modelo_id, p_nResultado, p_cMensaje);
				
				-- Incrementar el contador
				SET i = i + 1;
			END WHILE;

		END LOOP;

		CLOSE cur;
	ELSE 
		SET p_nResultado = -1;
		SET p_cMensaje = 'No existe el pedido';
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `generar_vehiculos_pedido`(
    IN p_pedido_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_numero_chasis VARCHAR(50);
    DECLARE v_modelo_id INT;
    DECLARE v_fecha_ingreso DATETIME DEFAULT CURDATE();
    DECLARE v_fecha_egreso DATETIME;
    DECLARE v_precio DOUBLE;
    DECLARE v_fabrica_automovil_id INT;
    DECLARE v_linea_montaje_id INT;
    DECLARE v_pedido_detalle_id INT;
    DECLARE v_cantidad INT;
    DECLARE done INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    
    -- Cursor para recorrer los detalles del pedido
    DECLARE cur CURSOR FOR
        SELECT 
            pd.pedido_detalle_id,
            pd.modelo_id,
            pd.cantidad
        FROM 
            tp_fabrica_automovil_bd1.pedido_detalle pd
        WHERE 
            pd.pedido_id = p_pedido_id;

    -- Manejar el final del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SELECT fabrica_automovil_id INTO v_fabrica_automovil_id FROM concesionaria c JOIN pedido p ON p.concesionaria_id = c.concesionaria_id LIMIT 1;

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';

    -- Verificar si el pedido existe
    IF NOT EXISTS (SELECT 1 FROM tp_fabrica_automovil_bd1.pedido WHERE pedido_id = p_pedido_id) THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'No existe el pedido';
    ELSE 
        IF EXISTS (
            SELECT 1
            FROM tp_fabrica_automovil_bd1.vehiculo v
            JOIN tp_fabrica_automovil_bd1.pedido_detalle pd ON v.pedido_detalle_id = pd.pedido_detalle_id
            WHERE pd.pedido_id = p_pedido_id
        ) THEN
            SET p_nResultado = -1;
            SET p_cMensaje = 'Pedido ya asignado';    
        ELSE 
            OPEN cur;

            read_loop: LOOP
                FETCH cur INTO v_pedido_detalle_id, v_modelo_id, v_cantidad;
                IF done THEN
                    LEAVE read_loop;
                END IF;

                -- Obtener el precio del vehículo basado en el modelo
                SET v_precio = obtener_precio_por_modelo(v_modelo_id);

                -- Obtener la línea de montaje para el modelo
                SELECT linea_montaje_id INTO v_linea_montaje_id 
                FROM tp_fabrica_automovil_bd1.linea_montaje 
                WHERE modelo_id = v_modelo_id 
                LIMIT 1;

                -- Generar vehículos para cada detalle del pedido
                SET i = 0; -- Reiniciar el contador
                WHILE i < v_cantidad DO
                    -- Generar un número de chasis aleatorio
                    SELECT generar_patente_aleatoria_unica() INTO v_numero_chasis;

                    -- Insertar el nuevo vehículo
                    INSERT INTO tp_fabrica_automovil_bd1.vehiculo 
                        (numero_chasis, modelo_id, fecha_ingreso, fecha_egreso, precio, fabrica_automovil_id, linea_montaje_id, pedido_detalle_id) 
                    VALUES 
                        (v_numero_chasis, v_modelo_id, v_fecha_ingreso, v_fecha_egreso, v_precio, v_fabrica_automovil_id, v_linea_montaje_id, v_pedido_detalle_id);

                    -- Verificar si hubo un error en la inserción del vehículo
                    IF ROW_COUNT() = 0 THEN
                        SET p_nResultado = -2;
                        SET p_cMensaje = 'Error al insertar vehículo';
                        LEAVE read_loop;
                    END IF;

                    SET i = i + 1;
                END WHILE;

                -- Actualizar el detalle del pedido
                CALL sp_modificacion_pedido_detalle(v_pedido_detalle_id, 'Montado en la línea de montaje', v_precio * v_cantidad, v_cantidad, v_modelo_id, p_pedido_id, p_nResultado, p_cMensaje);

                -- Verificar si hubo un error al actualizar el detalle del pedido
                IF p_nResultado < 0 THEN
                    SET p_cMensaje = CONCAT('Error al actualizar detalle del pedido: ', p_cMensaje);
                    LEAVE read_loop;
                END IF;
                
				CALL asignar_proveedor_precio(v_modelo_id, v_cantidad, p_nResultado, p_cMensaje);
            END LOOP;

			-- Llamar al procedimiento para cargar los productos necesarios para el vehículo
			CALL cargar_productos_a_estaciones(p_pedido_id, p_nResultado, p_cMensaje);
            CLOSE cur;

        END IF;
    END IF;
    
    -- Devolver el mensaje de resultado
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciar_montaje`(
    IN p_numero_chasis VARCHAR(40),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_vehiculo_id INT;
    DECLARE v_linea_montaje_id INT;
    DECLARE v_estacion_trabajo_id INT;
    DECLARE v_vehiculo_id_ocupado INT;
    DECLARE p_nResultado INT;
    DECLARE p_cMensaje VARCHAR(255);
    DECLARE v_fecha_egreso DATE;
    DECLARE v_numero_chasis_ocupante VARCHAR(50);

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';

    -- Verificar si el vehículo existe y obtener su ID, línea de montaje, y fecha de egreso
    SELECT 
        vehiculo_id, 
        fecha_egreso, 
        linea_montaje_id 
    INTO 
        v_vehiculo_id, 
        v_fecha_egreso, 
        v_linea_montaje_id 
    FROM 
        tp_fabrica_automovil_bd1.vehiculo 
    WHERE 
        numero_chasis = p_numero_chasis;

	IF v_linea_montaje_id IS NOT NULL THEN
		-- Validar si el vehículo ya tiene una fecha de egreso
		IF v_fecha_egreso IS NOT NULL THEN
			SET p_nResultado = -4;
			SET p_cMensaje = 'El vehículo ya ha finalizado anteriormente.';
		ELSE 
			-- Validar si el vehículo existe
			IF v_vehiculo_id IS NULL THEN
				SET p_nResultado = -1;
				SET p_cMensaje = 'El vehículo con el número de chasis proporcionado no existe.';
			ELSE
				-- Verificar si el vehículo ya está asignado a una estación de trabajo
				SELECT 
					estacion_trabajo_id 
				INTO 
					v_estacion_trabajo_id 
				FROM 
					tp_fabrica_automovil_bd1.estacion_trabajo 
				WHERE 
					vehiculo_id = v_vehiculo_id 
				LIMIT 1;

				IF v_estacion_trabajo_id IS NOT NULL THEN
					SET p_nResultado = -6;
					SET p_cMensaje = 'El vehículo ya está asignado a una estación de trabajo.';
				ELSE
					-- Obtener la primera estación de la línea de montaje y verificar si está ocupada
					SELECT 
						et.estacion_trabajo_id, 
						et.vehiculo_id 
					INTO 
						v_estacion_trabajo_id, 
						v_vehiculo_id_ocupado 
					FROM 
						tp_fabrica_automovil_bd1.estacion_trabajo et 
					WHERE 
						et.linea_montaje_id = v_linea_montaje_id 
					ORDER BY 
						et.estacion_trabajo_id ASC 
					LIMIT 1;

					-- Validar si la estación está ocupada
					IF v_vehiculo_id_ocupado IS NOT NULL THEN
						SELECT numero_chasis INTO v_numero_chasis_ocupante 
						FROM tp_fabrica_automovil_bd1.vehiculo v 
						WHERE v.vehiculo_id = v_vehiculo_id_ocupado;
						SET p_nResultado = -5;
						SET p_cMensaje = CONCAT('La primera estación de trabajo está ocupada por el vehículo con número de chasis: ', v_numero_chasis_ocupante);
					ELSE
						-- Asignar el vehículo a la estación de trabajo
						UPDATE tp_fabrica_automovil_bd1.estacion_trabajo 
						SET vehiculo_id = v_vehiculo_id, estado = 'Ocupado' 
						WHERE estacion_trabajo_id = v_estacion_trabajo_id;

						-- Registrar el movimiento en la tabla `estacion_trabajo_vehiculo`
						CALL sp_alta_estacion_trabajo_vehiculo(v_estacion_trabajo_id, v_vehiculo_id, curdate(), null, false, p_nResultado, p_cMensaje);

						SET p_nResultado = 0;
						SET p_cMensaje = 'Vehículo asignado a la estación de trabajo correctamente.';
					END IF;
				END IF;
			END IF;
		END IF;
	ELSE 
		SET p_nResultado = -7;
		SET p_cMensaje = 'Vehículo no tiene asignado una linea de montaje.';
    END IF;

    -- Retornar el resultado y mensaje
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `mover_a_siguiente_estacion`(
    IN p_numero_chasis VARCHAR(40),
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_linea_montaje_id INT;
    DECLARE v_tarea VARCHAR(50);
    DECLARE p_nResultado INT;
    DECLARE p_cMensaje VARCHAR(255);
    DECLARE v_fecha_actual DATETIME;
    DECLARE v_fecha_egreso DATE;
    DECLARE v_numero_chasis_ocupante VARCHAR(50);
    
    DECLARE v_estacion_trabajo_id_actual INT;
    DECLARE v_estacion_trabajo_id_siguiente INT;
    DECLARE v_vehiculo_id_actual INT;
    DECLARE v_vehiculo_id_siguiente INT;
    DECLARE v_fecha_ingreso DATE;
    DECLARE v_demora_estimada_dias INT;

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';
    SET v_fecha_actual = NOW();
    
    -- Obtener el ID del vehículo, línea de montaje e ID de la estación actual
    SELECT 
        v.vehiculo_id, 
        v.linea_montaje_id, 
        et.estacion_trabajo_id,
        v.fecha_egreso
    INTO 
        v_vehiculo_id_actual, 
        v_linea_montaje_id, 
        v_estacion_trabajo_id_actual,
        v_fecha_egreso
    FROM 
        tp_fabrica_automovil_bd1.vehiculo v
    JOIN 
        tp_fabrica_automovil_bd1.estacion_trabajo et ON v.vehiculo_id = et.vehiculo_id
    WHERE 
        v.numero_chasis = p_numero_chasis
    LIMIT 1;  -- Asegura que solo se recupere una fila
    
    IF v_vehiculo_id_actual IS NULL THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'El vehículo con el número de chasis proporcionado no existe o no está en una estación de trabajo.';
    ELSEIF v_fecha_egreso IS NOT NULL THEN
        SET p_nResultado = -4;
        SET p_cMensaje = 'El vehículo ya ha finalizado anteriormente.';
    ELSE
        -- Obtener la siguiente estación de la línea de montaje
        SELECT 
            et.estacion_trabajo_id 
        INTO 
            v_estacion_trabajo_id_siguiente
        FROM 
            tp_fabrica_automovil_bd1.estacion_trabajo et
        JOIN 
            tp_fabrica_automovil_bd1.linea_montaje lm ON et.linea_montaje_id = lm.linea_montaje_id
        WHERE 
            lm.linea_montaje_id = v_linea_montaje_id
        AND 
            et.estacion_trabajo_id > v_estacion_trabajo_id_actual
        ORDER BY 
            et.estacion_trabajo_id ASC
        LIMIT 1;  -- Asegura que solo se recupere una fila
		
        IF v_estacion_trabajo_id_siguiente IS NULL THEN
            -- No hay siguiente estación, marcar el vehículo como finalizado
            SELECT fecha_ingreso INTO v_fecha_ingreso 
            FROM tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo 
            WHERE estacion_trabajo_id = v_estacion_trabajo_id_actual 
            AND vehiculo_id = v_vehiculo_id_actual;
            
            SELECT demora_estimada_dias INTO v_demora_estimada_dias 
            FROM tp_fabrica_automovil_bd1.estacion_trabajo 
            WHERE estacion_trabajo_id = v_estacion_trabajo_id_actual;
            
            CALL sp_modificacion_estacion_trabajo_vehiculo(
                v_estacion_trabajo_id_actual, 
                v_vehiculo_id_actual, 
                v_fecha_ingreso, 
                DATE_ADD(v_fecha_ingreso, INTERVAL v_demora_estimada_dias DAY), 
                true, 
                p_nResultado, 
                p_cMensaje
            );
        
            -- Actualizar el vehículo como finalizado
            UPDATE tp_fabrica_automovil_bd1.vehiculo
            SET fecha_egreso = DATE_ADD(v_fecha_ingreso, INTERVAL v_demora_estimada_dias DAY)
            WHERE vehiculo_id = v_vehiculo_id_actual;

            -- Eliminar el vehículo de la estación actual
            UPDATE tp_fabrica_automovil_bd1.estacion_trabajo
            SET vehiculo_id = NULL, estado = 'Libre'
            WHERE estacion_trabajo_id = v_estacion_trabajo_id_actual
            AND vehiculo_id = v_vehiculo_id_actual;
        
            SET p_nResultado = 0;
            SET p_cMensaje = 'El vehículo ha sido finalizado en la línea de montaje.';
        ELSE
            -- Verificar la tarea de la siguiente estación
            SELECT 
                et.tarea 
            INTO 
                v_tarea
            FROM 
                tp_fabrica_automovil_bd1.estacion_trabajo et
            WHERE 
                et.estacion_trabajo_id = v_estacion_trabajo_id_siguiente
            LIMIT 1;  -- Asegura que solo se recupere una fila

            -- Verificar si la siguiente estación está ocupada
            SELECT 
                et.vehiculo_id 
            INTO 
                v_vehiculo_id_siguiente
            FROM 
                tp_fabrica_automovil_bd1.estacion_trabajo et
            WHERE 
                et.estacion_trabajo_id = v_estacion_trabajo_id_siguiente
            LIMIT 1;  -- Asegura que solo se recupere una fila

            -- Mover el vehículo a la siguiente estación
            IF v_vehiculo_id_siguiente IS NOT NULL THEN
				SELECT numero_chasis INTO v_numero_chasis_ocupante 
				FROM tp_fabrica_automovil_bd1.vehiculo v 
				WHERE v.vehiculo_id = v_vehiculo_id_siguiente;
				SET p_nResultado = -5;
				SET p_cMensaje = CONCAT('La siguiente estación de trabajo está ocupada por el vehículo con número de chasis: ', v_numero_chasis_ocupante);
			ELSE
                SELECT fecha_ingreso INTO v_fecha_ingreso 
                FROM tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo 
                WHERE estacion_trabajo_id = v_estacion_trabajo_id_actual 
                AND vehiculo_id = v_vehiculo_id_actual;
                
                SELECT demora_estimada_dias INTO v_demora_estimada_dias 
                FROM tp_fabrica_automovil_bd1.estacion_trabajo 
                WHERE estacion_trabajo_id = v_estacion_trabajo_id_actual;
                
                CALL sp_modificacion_estacion_trabajo_vehiculo(
                    v_estacion_trabajo_id_actual, 
                    v_vehiculo_id_actual, 
                    v_fecha_ingreso, 
                    DATE_ADD(v_fecha_ingreso, INTERVAL v_demora_estimada_dias DAY), 
                    true, 
                    p_nResultado, 
                    p_cMensaje
                );
                
                CALL sp_alta_estacion_trabajo_vehiculo(
                    v_estacion_trabajo_id_siguiente, 
                    v_vehiculo_id_actual, 
                    DATE_ADD(v_fecha_ingreso, INTERVAL v_demora_estimada_dias DAY), 
                    null, 
                    false, 
                    p_nResultado, 
                    p_cMensaje
                );
                
                -- Asignar el vehículo a la siguiente estación
                UPDATE tp_fabrica_automovil_bd1.estacion_trabajo
                SET vehiculo_id = v_vehiculo_id_actual, estado = 'Ocupado'
                WHERE estacion_trabajo_id = v_estacion_trabajo_id_siguiente;

                -- Eliminar el vehículo de la estación actual
                UPDATE tp_fabrica_automovil_bd1.estacion_trabajo
                SET vehiculo_id = NULL, estado = 'Libre'
                WHERE estacion_trabajo_id = v_estacion_trabajo_id_actual
                AND vehiculo_id = v_vehiculo_id_actual;

                SET p_nResultado = 0;
                SET p_cMensaje = 'El vehículo ha sido movido a la siguiente estación.';
            END IF;
        END IF;
    END IF;

    -- Retornar el resultado y mensaje
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_vehiculo_pedido`(
    IN p_pedido_id INT
)
BEGIN
    SELECT 
        p_pedido_id AS NumeroPedido,
        pd.pedido_detalle_id AS NumeroPedidoDetalle,
        v.numero_chasis AS chasis,
        CASE 
            WHEN v.fecha_egreso IS NOT NULL THEN 'Finalizado'
            ELSE 
                COALESCE(
                    CONCAT('En estación: ', 
                    GROUP_CONCAT(et.estacion_trabajo_id SEPARATOR ', ')), 
                    'No asignado a ninguna estación'
                )
        END AS estado
    FROM 
        tp_fabrica_automovil_bd1.pedido_detalle pd
    JOIN 
        tp_fabrica_automovil_bd1.vehiculo v ON pd.pedido_detalle_id = v.pedido_detalle_id
    LEFT JOIN 
        tp_fabrica_automovil_bd1.estacion_trabajo et ON v.vehiculo_id = et.vehiculo_id
    WHERE 
        pd.pedido_id = p_pedido_id
    GROUP BY 
        p_pedido_id, pd.pedido_detalle_id, v.numero_chasis, v.fecha_egreso;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `sumar_productos_por_modelo`(
    IN p_modelo_id INT,
    OUT p_cantidad_chasis INT,
    OUT p_cantidad_motor INT,
    OUT p_cantidad_sistema_transmision INT,
    OUT p_cantidad_sistema_suspension INT,
    OUT p_cantidad_sistema_frenos INT,
    OUT p_cantidad_sistema_direccion INT,
    OUT p_cantidad_sistema_escape INT,
    OUT p_cantidad_sistema_electrico INT,
    OUT p_cantidad_interior INT,
    OUT p_cantidad_carroceria INT,
    OUT p_cantidad_cristales INT,
    OUT p_cantidad_pintura INT
)
BEGIN
    DECLARE v_producto_id INT;
    DECLARE v_producto_cantidad INT;
    DECLARE done_product INT DEFAULT 0;
    
	DECLARE v_producto_id_1 INT;
    DECLARE v_producto_id_2 INT;
    DECLARE v_producto_id_3 INT;
    DECLARE v_producto_id_4 INT;
    DECLARE v_producto_id_5 INT;
    DECLARE v_producto_id_6 INT;
    DECLARE v_producto_id_7 INT;
	DECLARE v_producto_id_8 INT;
	DECLARE v_producto_id_9 INT;
	DECLARE v_producto_id_10 INT;
	DECLARE v_producto_id_11 INT;
	DECLARE v_producto_id_12 INT;
    
    -- Cursor para recorrer los productos requeridos para el modelo actual
    DECLARE product_cursor CURSOR FOR 
        SELECT pv.producto_id, pv.cantidad 
        FROM tp_fabrica_automovil_bd1.producto_vehiculo pv 
        WHERE pv.modelo_id = p_modelo_id;

    -- Manejador para el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_product = 1;
    
    SELECT producto_id INTO v_producto_id_1 FROM producto p WHERE p.nombre = 'Chasis';
    SELECT producto_id INTO v_producto_id_2 FROM producto p WHERE p.nombre = 'Motor';
    SELECT producto_id INTO v_producto_id_3 FROM producto p WHERE p.nombre = 'Sistema de transmision';
    SELECT producto_id INTO v_producto_id_4 FROM producto p WHERE p.nombre = 'Sistema de suspension';
    SELECT producto_id INTO v_producto_id_5 FROM producto p WHERE p.nombre = 'Sistema de frenos';
    SELECT producto_id INTO v_producto_id_6 FROM producto p WHERE p.nombre = 'Sistema de direccion';
    SELECT producto_id INTO v_producto_id_7 FROM producto p WHERE p.nombre = 'Sistema de escape';
    SELECT producto_id INTO v_producto_id_8 FROM producto p WHERE p.nombre = 'Sistema electrico';
    SELECT producto_id INTO v_producto_id_9 FROM producto p WHERE p.nombre = 'Interior';
    SELECT producto_id INTO v_producto_id_10 FROM producto p WHERE p.nombre = 'Carroceria';
    SELECT producto_id INTO v_producto_id_11 FROM producto p WHERE p.nombre = 'Cristales';
    SELECT producto_id INTO v_producto_id_12 FROM producto p WHERE p.nombre = 'Pintura';

    -- Inicializar las variables de salida
    SET p_cantidad_chasis = 0;
    SET p_cantidad_motor = 0;
    SET p_cantidad_sistema_transmision = 0;
    SET p_cantidad_sistema_suspension = 0;
    SET p_cantidad_sistema_frenos = 0;
    SET p_cantidad_sistema_direccion = 0;
    SET p_cantidad_sistema_escape = 0;
    SET p_cantidad_sistema_electrico = 0;
    SET p_cantidad_interior = 0;
    SET p_cantidad_carroceria = 0;
    SET p_cantidad_cristales = 0;
    SET p_cantidad_pintura = 0;

    -- Abrir el cursor del producto
    OPEN product_cursor;

    -- Recorrer los productos requeridos para el modelo actual
    product_loop: LOOP
        FETCH product_cursor INTO v_producto_id, v_producto_cantidad;
        IF done_product THEN
            LEAVE product_loop;
        END IF;

        -- Incrementar las cantidades según el producto_id
        IF v_producto_id = v_producto_id_1 THEN
            SET p_cantidad_chasis = p_cantidad_chasis + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_2 THEN
            SET p_cantidad_motor = p_cantidad_motor + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_3 THEN
            SET p_cantidad_sistema_transmision = p_cantidad_sistema_transmision + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_4 THEN
            SET p_cantidad_sistema_suspension = p_cantidad_sistema_suspension + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_5 THEN
            SET p_cantidad_sistema_frenos = p_cantidad_sistema_frenos + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_6 THEN
            SET p_cantidad_sistema_direccion = p_cantidad_sistema_direccion + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_7 THEN
            SET p_cantidad_sistema_escape = p_cantidad_sistema_escape + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_8 THEN
            SET p_cantidad_sistema_electrico = p_cantidad_sistema_electrico + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_9 THEN
            SET p_cantidad_interior = p_cantidad_interior + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_10 THEN
            SET p_cantidad_carroceria = p_cantidad_carroceria + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_11 THEN
            SET p_cantidad_cristales = p_cantidad_cristales + v_producto_cantidad;
        ELSEIF v_producto_id = v_producto_id_12 THEN
            SET p_cantidad_pintura = p_cantidad_pintura + v_producto_cantidad;
        END IF;

    END LOOP;

    -- Cerrar el cursor del producto
    CLOSE product_cursor;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_cantidades_producto_pedido`(
    IN p_pedido_id INT
)
BEGIN
    DECLARE v_modelo_id INT;
    DECLARE v_numero_chasis VARCHAR(50);
    DECLARE v_pedido_detalle_id INT;
    DECLARE done INT DEFAULT 0;

    DECLARE v_cantidad_chasis INT DEFAULT 0;
    DECLARE v_cantidad_motor INT DEFAULT 0;
    DECLARE v_cantidad_sistema_transmision INT DEFAULT 0;
    DECLARE v_cantidad_sistema_suspension INT DEFAULT 0;
    DECLARE v_cantidad_sistema_frenos INT DEFAULT 0;
    DECLARE v_cantidad_sistema_direccion INT DEFAULT 0;
    DECLARE v_cantidad_sistema_escape INT DEFAULT 0;
    DECLARE v_cantidad_sistema_electrico INT DEFAULT 0;
    DECLARE v_cantidad_interior INT DEFAULT 0;
    DECLARE v_cantidad_carroceria INT DEFAULT 0;
    DECLARE v_cantidad_cristales INT DEFAULT 0;
    DECLARE v_cantidad_pintura INT DEFAULT 0;

    -- Cursor para recorrer los detalles del pedido
    DECLARE cur CURSOR FOR
        SELECT
            v.modelo_id,
            v.numero_chasis,
            pd.pedido_detalle_id
        FROM
            tp_fabrica_automovil_bd1.pedido_detalle pd
        JOIN
            tp_fabrica_automovil_bd1.vehiculo v ON pd.pedido_detalle_id = v.pedido_detalle_id
        WHERE
            pd.pedido_id = p_pedido_id;

    -- Manejador para el cursor del pedido
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Abrir el cursor para recorrer los detalles del pedido
    OPEN cur;

    -- Recorrer los detalles del pedido
    read_loop: LOOP
        FETCH cur INTO v_modelo_id, v_numero_chasis, v_pedido_detalle_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Llamar al procedimiento que suma los productos por modelo
        CALL sumar_productos_por_modelo(
            v_modelo_id,
            @tmp_cantidad_chasis,
            @tmp_cantidad_motor,
            @tmp_cantidad_sistema_transmision,
            @tmp_cantidad_sistema_suspension,
            @tmp_cantidad_sistema_frenos,
            @tmp_cantidad_sistema_direccion,
            @tmp_cantidad_sistema_escape,
            @tmp_cantidad_sistema_electrico,
            @tmp_cantidad_interior,
            @tmp_cantidad_carroceria,
            @tmp_cantidad_cristales,
            @tmp_cantidad_pintura
        );

        -- Acumular los resultados
        SET v_cantidad_chasis = v_cantidad_chasis + @tmp_cantidad_chasis;
        SET v_cantidad_motor = v_cantidad_motor + @tmp_cantidad_motor;
        SET v_cantidad_sistema_transmision = v_cantidad_sistema_transmision + @tmp_cantidad_sistema_transmision;
        SET v_cantidad_sistema_suspension = v_cantidad_sistema_suspension + @tmp_cantidad_sistema_suspension;
        SET v_cantidad_sistema_frenos = v_cantidad_sistema_frenos + @tmp_cantidad_sistema_frenos;
        SET v_cantidad_sistema_direccion = v_cantidad_sistema_direccion + @tmp_cantidad_sistema_direccion;
        SET v_cantidad_sistema_escape = v_cantidad_sistema_escape + @tmp_cantidad_sistema_escape;
        SET v_cantidad_sistema_electrico = v_cantidad_sistema_electrico + @tmp_cantidad_sistema_electrico;
        SET v_cantidad_interior = v_cantidad_interior + @tmp_cantidad_interior;
        SET v_cantidad_carroceria = v_cantidad_carroceria + @tmp_cantidad_carroceria;
        SET v_cantidad_cristales = v_cantidad_cristales + @tmp_cantidad_cristales;
        SET v_cantidad_pintura = v_cantidad_pintura + @tmp_cantidad_pintura;

    END LOOP;

    -- Cerrar el cursor del pedido
    CLOSE cur;

    -- Mostrar resultados acumulados
    SELECT 
        v_cantidad_chasis AS Chasis,
        v_cantidad_motor AS Motor,
        v_cantidad_sistema_transmision AS SistemaTransmision,
        v_cantidad_sistema_suspension AS SistemaSuspension,
        v_cantidad_sistema_frenos AS SistemaFrenos,
        v_cantidad_sistema_direccion AS SistemaDireccion,
        v_cantidad_sistema_escape AS SistemaEscape,
        v_cantidad_sistema_electrico AS SistemaElectrico,
        v_cantidad_interior AS Interior,
        v_cantidad_carroceria AS Carroceria,
        v_cantidad_cristales AS Cristales,
        v_cantidad_pintura AS Pintura;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `calcular_tiempo_promedio_construccion`(
    IN p_linea_montaje_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255),
    OUT p_tiempo_promedio DOUBLE
)
BEGIN
    DECLARE v_fecha_ingreso DATETIME;
    DECLARE v_fecha_egreso DATETIME;
    DECLARE v_tiempo_construccion DOUBLE;
    DECLARE v_total_tiempo DOUBLE;
    DECLARE v_numero_vehiculos INT;
    
    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';
    SET p_tiempo_promedio = 0;
    SET v_total_tiempo = 0;
    SET v_numero_vehiculos = 0;

    -- Calcular el número de vehículos terminados
    SELECT 
        COUNT(*) INTO v_numero_vehiculos
    FROM 
        tp_fabrica_automovil_bd1.vehiculo
    WHERE 
        linea_montaje_id = p_linea_montaje_id
        AND fecha_egreso IS NOT NULL;

    IF v_numero_vehiculos = 0 THEN
        SET p_nResultado = -1;
        SET p_cMensaje = 'No hay vehículos terminados en la línea de montaje especificada.';
    ELSE
        -- Calcular el tiempo total de construcción en días
        SELECT 
            SUM(DATEDIFF(fecha_egreso, fecha_ingreso)) INTO v_total_tiempo
        FROM 
            tp_fabrica_automovil_bd1.vehiculo
        WHERE 
            linea_montaje_id = p_linea_montaje_id
            AND fecha_egreso IS NOT NULL;

        -- Calcular el tiempo promedio en días
        SET p_tiempo_promedio = (v_total_tiempo / v_numero_vehiculos) / 30;

        SET p_cMensaje = 'El tiempo promedio de construcción ha sido calculado exitosamente.';
    END IF;
    
    -- Resultado
	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje, p_tiempo_promedio;
	END IF;
END

&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_estaciones_trabajo`(
    IN p_linea_montaje_id INT,
    OUT p_nResultado INT,
    OUT p_cMensaje VARCHAR(255)
)
BEGIN
    DECLARE v_demora_dias_estimada INT;
    DECLARE v_modelo_id INT;
    DECLARE v_modelo VARCHAR(50);
    DECLARE v_linea_montaje_id INT;
    
	-- Si todas las llamadas fueron exitosas
    SET p_nResultado = 0;
    SET p_cMensaje = '';
	
    SELECT linea_montaje_id INTO v_linea_montaje_id FROM tp_fabrica_automovil_bd1.linea_montaje lm WHERE lm.linea_montaje_id = p_linea_montaje_id;
	SELECT modelo_id INTO v_modelo_id FROM tp_fabrica_automovil_bd1.linea_montaje lm WHERE lm.linea_montaje_id = p_linea_montaje_id;
	SELECT modelo INTO v_modelo FROM tp_fabrica_automovil_bd1.modelo m WHERE m.modelo_id = v_modelo_id;
		
	IF v_linea_montaje_id IS NULL THEN
		SET p_nResultado = -1;
		SET p_cMensaje = 'La linea de montaje no existe';
	ELSEIF v_modelo_id IS NULL THEN
        SET p_nResultado = -2;
		SET p_cMensaje = 'El modelo no existe';
    ELSE 
		-- Aplicar lógica según el modelo con CASE
		CASE v_modelo
		
			WHEN 'Renault 12' THEN
				CALL sp_alta_estacion_trabajo('Montaje de chasis', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del motor', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje de transmisión', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de suspensión', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de frenos', 5, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema de dirección', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de escape', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema eléctrico', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del interior', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de la carrocería', 9, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de los cristales', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Pintura', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Inspección y pruebas de calidad', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				
			WHEN 'Toyota Corolla' THEN
				CALL sp_alta_estacion_trabajo('Montaje de chasis', 9, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del motor', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje de transmisión', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de suspensión', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de frenos', 7, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema de dirección', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de escape', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema eléctrico', 5, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del interior', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de la carrocería', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de los cristales', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Pintura', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Inspección y pruebas de calidad', 8, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				
			WHEN 'Honda Civic' THEN 
				CALL sp_alta_estacion_trabajo('Montaje de chasis', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del motor', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje de transmisión', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de suspensión', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de frenos', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema de dirección', 7, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de escape', 5, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema eléctrico', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del interior', 8, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de la carrocería', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de los cristales', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Pintura', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Inspección y pruebas de calidad', 8, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);

			WHEN 'Ford Mustang' THEN 
				CALL sp_alta_estacion_trabajo('Montaje de chasis', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del motor', 5, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje de transmisión', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de suspensión', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de frenos', 6, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema de dirección', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de escape', 8, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema eléctrico', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del interior', 5, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de la carrocería', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de los cristales', 9, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Pintura', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Inspección y pruebas de calidad', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				
			WHEN 'Chevrolet Camaro' THEN 
				CALL sp_alta_estacion_trabajo('Montaje de chasis', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del motor', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje de transmisión', 5, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de suspensión', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de frenos', 8, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema de dirección', 7, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación del sistema de escape', 9, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del sistema eléctrico', 1, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Montaje del interior', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de la carrocería', 3, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Instalación de los cristales', 2, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Pintura', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				CALL sp_alta_estacion_trabajo('Inspección y pruebas de calidad', 4, 'Libre', p_linea_montaje_id, null, p_nResultado, p_cMensaje);
				
			ELSE
				SET p_nResultado = -1;
				SET p_cMensaje = CONCAT("Cuidado con el modelo_id = ", v_modelo_id, " y linea_montaje_id = ", p_linea_montaje_id, ", no se le asignaron estaciones de trabajo");
	
		END CASE;
    
    END IF;

	IF p_cMensaje IS NOT NULL AND LENGTH(p_cMensaje) > 0 THEN
		SELECT p_nResultado, p_cMensaje;
	END IF;
END

&& DELIMITER 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Functions

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE DEFINER=`root`@`localhost` FUNCTION `obtener_precio_por_modelo`(
    p_vehiculo_modelo_id INT
) RETURNS DOUBLE
    DETERMINISTIC
    NO SQL
BEGIN
    DECLARE v_precio DOUBLE;
    DECLARE v_vehiculo_modelo VARCHAR(50);
    
    SELECT modelo INTO v_vehiculo_modelo FROM tp_fabrica_automovil_bd1.modelo m WHERE m.modelo_id = p_vehiculo_modelo_id;

    -- Asignar el precio basado en el modelo
    CASE v_vehiculo_modelo
        WHEN 'Renault 12' THEN
            SET v_precio = 15000.00;
        WHEN 'Toyota Corolla' THEN
            SET v_precio = 25000.00;
        WHEN 'Honda Civic' THEN
            SET v_precio = 30000.00;
		WHEN 'Ford Mustang' THEN
            SET v_precio = 20000.00;
		WHEN 'Chevrolet Camaro' THEN
            SET v_precio = 18000.00;
        ELSE
            SET v_precio = 10000.00; -- Precio por defecto si el modelo no coincide con ninguno de los anteriores
    END CASE;

    RETURN v_precio;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_costo_vehiculo`(vehiculo_id INT) RETURNS double
    DETERMINISTIC
BEGIN
    DECLARE costo_total DOUBLE;
    SELECT SUM(pp.precio) INTO costo_total
    FROM producto_vehiculo pv
    INNER JOIN producto_proveedor pp ON pv.producto_id = pp.producto_id
    WHERE pv.vehiculo_id = vehiculo_id;
    RETURN costo_total;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_tiempo_construccion`(modelo_id INT) RETURNS double
    DETERMINISTIC
BEGIN
	DECLARE cantidad_dias INT;
	SELECT SUM(et.demora_estimada_dias) INTO cantidad_dias FROM tp_fabrica_automovil_bd1.estacion_trabajo et JOIN tp_fabrica_automovil_bd1.linea_montaje lm 
    ON lm.linea_montaje_id = et.linea_montaje_id WHERE lm.modelo_id = modelo_id;
    RETURN cantidad_dias;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` FUNCTION `generar_patente_aleatoria_unica`() 
RETURNS varchar(10) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_numero_chasis VARCHAR(10);
    DECLARE v_count INT;
    DECLARE numero_chasis_unica BOOLEAN DEFAULT FALSE;

    -- Bucle para generar un número de chasis único
    WHILE NOT numero_chasis_unica DO
        -- Generar un número de chasis aleatorio con dos letras, tres números, y dos letras más
        SET v_numero_chasis = CONCAT(
            CHAR(FLOOR(65 + RAND() * 26)), 
            CHAR(FLOOR(65 + RAND() * 26)), 
            ' ', 
            FLOOR(RAND() * 10), 
            FLOOR(RAND() * 10), 
            FLOOR(RAND() * 10),
            ' ',
            CHAR(FLOOR(65 + RAND() * 26)), 
            CHAR(FLOOR(65 + RAND() * 26))
        );

        -- Verificar si el número de chasis ya existe
        SELECT COUNT(*) INTO v_count
        FROM tp_fabrica_automovil_bd1.vehiculo
        WHERE numero_chasis = v_numero_chasis;
        
        -- Si el número de chasis no existe, marcar como único
        IF v_count = 0 THEN
            SET numero_chasis_unica = TRUE;
        END IF;
    END WHILE;
    
    RETURN v_numero_chasis;
END;


&& DELIMITER

DELIMITER &&

CREATE DEFINER=`root`@`localhost` FUNCTION `total_pedidos_concesionaria`(concesionaria_id INT) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total 
    FROM pedido 
    WHERE concesionaria_id = concesionaria_id;
    RETURN total;
END

&& DELIMITER 

DELIMITER &&

CREATE DEFINER=`root`@`localhost` FUNCTION `verificar_estado_vehiculo`(vehiculo_id INT) RETURNS VARCHAR(50) 
    DETERMINISTIC
BEGIN
    DECLARE estado VARCHAR(50);
    DECLARE fecha_egreso DATE;
    SELECT fecha_egreso INTO fecha_egreso from vehiculo v WHERE v.vehiculo_id = vehiculo_id;
	IF fecha_egreso IS NOT NULL THEN
		RETURN 'No Finalizado';
	ELSE 
		RETURN 'Finalizado';
    END IF;
END

&& DELIMITER 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TRIGGERS

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE TRIGGER actualizar_estado_pedido_detalle
AFTER UPDATE ON vehiculo
FOR EACH ROW
BEGIN
    DECLARE vehiculos_terminados INT;
    DECLARE vehiculos_totales INT;

    -- Contar el total de vehículos asociados al pedido detalle
    SELECT COUNT(*) INTO vehiculos_totales
    FROM vehiculo
    WHERE pedido_detalle_id = OLD.pedido_detalle_id;

    -- Contar los vehículos terminados asociados al pedido detalle
    SELECT COUNT(*) INTO vehiculos_terminados
    FROM vehiculo
    WHERE pedido_detalle_id = OLD.pedido_detalle_id
      AND (fecha_egreso IS NOT NULL);

    -- Si todos los vehículos están terminados, actualizar el estado del pedido detalle
    IF vehiculos_totales = vehiculos_terminados THEN
        UPDATE pedido_detalle
        SET estado = 'Terminado'
        WHERE pedido_detalle_id = OLD.pedido_detalle_id;
    END IF;
END 

&& DELIMITER 

DELIMITER  &&

CREATE TRIGGER actualizar_capacidad_productiva_promedio
AFTER UPDATE ON tp_fabrica_automovil_bd1.vehiculo
FOR EACH ROW
BEGIN
    DECLARE p_nResultado INT;
    DECLARE p_cMensaje VARCHAR(255);
    DECLARE v_fecha_ingreso DATETIME;
    DECLARE v_fecha_egreso DATETIME;
    DECLARE v_tiempo_construccion DOUBLE;
    DECLARE v_total_tiempo DOUBLE;
    DECLARE v_numero_vehiculos INT;
    DECLARE p_tiempo_promedio DOUBLE;
    DECLARE v_linea_montaje_id INT;

    -- Inicializar valores
    SET p_nResultado = 0;
    SET p_cMensaje = '';
    SET p_tiempo_promedio = 0;
    SET v_total_tiempo = 0;
    SET v_numero_vehiculos = 0;

    -- Verificar si el vehículo ha finalizado
    IF NEW.fecha_egreso IS NOT NULL THEN
        -- Obtener la línea de montaje del vehículo
        SELECT 
            v.linea_montaje_id
        INTO 
            v_linea_montaje_id
        FROM 
            tp_fabrica_automovil_bd1.vehiculo v
        WHERE 
            v.vehiculo_id = NEW.vehiculo_id
        LIMIT 1;

        -- Calcular el número de vehículos terminados en la línea de montaje
        SELECT 
            COUNT(*) INTO v_numero_vehiculos
        FROM 
            tp_fabrica_automovil_bd1.vehiculo
        WHERE 
            linea_montaje_id = v_linea_montaje_id
            AND fecha_egreso IS NOT NULL;

        IF v_numero_vehiculos = 0 THEN
            SET p_nResultado = -1;
            SET p_cMensaje = 'No hay vehículos terminados en la línea de montaje especificada.';
        ELSE
            -- Calcular el tiempo total de construcción en días
            SELECT 
                SUM(DATEDIFF(fecha_egreso, fecha_ingreso)) INTO v_total_tiempo
            FROM 
                tp_fabrica_automovil_bd1.vehiculo
            WHERE 
                linea_montaje_id = v_linea_montaje_id
                AND fecha_egreso IS NOT NULL;

            -- Calcular el tiempo promedio en días
            SET p_tiempo_promedio = (v_total_tiempo / v_numero_vehiculos) / 30;

            -- Actualizar la capacidad productiva promedio de la línea de montaje
            UPDATE tp_fabrica_automovil_bd1.linea_montaje
            SET capacidad_productiva_promedio = p_tiempo_promedio
            WHERE linea_montaje_id = v_linea_montaje_id;
            
        END IF;
    END IF;
END

&& DELIMITER

DELIMITER &&

CREATE TRIGGER incrementar_vehiculos_linea_montaje
AFTER INSERT ON tp_fabrica_automovil_bd1.vehiculo
FOR EACH ROW
BEGIN
    -- Verificar si la línea de montaje cambió de NULL a algún valor
	UPDATE tp_fabrica_automovil_bd1.linea_montaje
	SET cantidad_vehiculos_actual = cantidad_vehiculos_actual + 1
	WHERE linea_montaje_id = NEW.linea_montaje_id;
END;

&& DELIMITER

DELIMITER &&

CREATE TRIGGER actualizar_estado_linea_montaje_ocupado
AFTER INSERT ON tp_fabrica_automovil_bd1.estacion_trabajo_vehiculo
FOR EACH ROW
BEGIN
    DECLARE v_linea_montaje_id INT;
    DECLARE v_estacion_trabajo_id INT;

    -- Obtener el ID de la línea de montaje y de la estación de trabajo involucrada
    SELECT et.linea_montaje_id, et.estacion_trabajo_id
    INTO v_linea_montaje_id, v_estacion_trabajo_id
    FROM tp_fabrica_automovil_bd1.estacion_trabajo et
    WHERE et.estacion_trabajo_id = NEW.estacion_trabajo_id
    LIMIT 1;

    -- Verificar si es la primera estación de la línea de montaje
    IF v_estacion_trabajo_id = (
        SELECT MIN(estacion_trabajo_id)
        FROM tp_fabrica_automovil_bd1.estacion_trabajo
        WHERE linea_montaje_id = v_linea_montaje_id
    ) THEN
        -- Actualizar el estado de la línea de montaje a "Ocupado"
        UPDATE tp_fabrica_automovil_bd1.linea_montaje
        SET estado = 'Ocupado'
        WHERE linea_montaje_id = v_linea_montaje_id;
    END IF;
END

&& DELIMITER 

DELIMITER &&

CREATE TRIGGER actualizar_estado_primer_estacion_libre
AFTER UPDATE ON tp_fabrica_automovil_bd1.estacion_trabajo
FOR EACH ROW
BEGIN
    DECLARE v_primer_estacion_id INT;

    -- Obtener el ID de la primera estación de la línea de montaje
    SELECT MIN(estacion_trabajo_id) INTO v_primer_estacion_id
    FROM tp_fabrica_automovil_bd1.estacion_trabajo
    WHERE linea_montaje_id = OLD.linea_montaje_id;

    -- Verificar si el vehiculo_id pasó de NOT NULL a NULL y si es la primera estación de trabajo
    IF OLD.vehiculo_id IS NOT NULL AND NEW.vehiculo_id IS NULL 
        AND NEW.estacion_trabajo_id = v_primer_estacion_id THEN
        UPDATE tp_fabrica_automovil_bd1.linea_montaje
        SET estado = 'Libre'
        WHERE linea_montaje_id = NEW.linea_montaje_id;
    END IF;
END 

&& DELIMITER

DELIMITER &&

CREATE TRIGGER actualizar_fecha_entrega_estimada
AFTER UPDATE ON tp_fabrica_automovil_bd1.vehiculo
FOR EACH ROW
BEGIN
    DECLARE v_pedido_id INT;
    DECLARE v_fecha_entrega_estimada DATETIME;
    DECLARE v_total_vehiculos INT;
    DECLARE v_vehiculos_finalizados INT;

    -- Verificar si el vehículo ha sido finalizado (fecha_egreso pasa de NULL a NO NULL)
    IF OLD.fecha_egreso IS NULL AND NEW.fecha_egreso IS NOT NULL THEN
        -- Obtener el ID del pedido al que pertenece el vehículo
        SELECT pd.pedido_id
        INTO v_pedido_id
        FROM tp_fabrica_automovil_bd1.pedido_detalle pd
        WHERE pd.pedido_detalle_id = NEW.pedido_detalle_id
        LIMIT 1;

        -- Contar el número total de vehículos del pedido
        SELECT COUNT(*)
        INTO v_total_vehiculos
        FROM tp_fabrica_automovil_bd1.vehiculo v
        JOIN tp_fabrica_automovil_bd1.pedido_detalle pd ON v.pedido_detalle_id = pd.pedido_detalle_id
        WHERE pd.pedido_id = v_pedido_id;

        -- Contar el número de vehículos finalizados del pedido
        SELECT COUNT(*)
        INTO v_vehiculos_finalizados
        FROM tp_fabrica_automovil_bd1.vehiculo v
        JOIN tp_fabrica_automovil_bd1.pedido_detalle pd ON v.pedido_detalle_id = pd.pedido_detalle_id
        WHERE pd.pedido_id = v_pedido_id AND v.fecha_egreso IS NOT NULL;

        -- Si todos los vehículos del pedido han sido finalizados
        IF v_total_vehiculos = v_vehiculos_finalizados THEN
            -- Obtener la fecha de egreso del último vehículo
            SELECT MAX(NEW.fecha_egreso)
            INTO v_fecha_entrega_estimada
            FROM tp_fabrica_automovil_bd1.vehiculo v
            JOIN tp_fabrica_automovil_bd1.pedido_detalle pd ON v.pedido_detalle_id = pd.pedido_detalle_id
            WHERE pd.pedido_id = v_pedido_id;

            -- Actualizar la fecha de entrega estimada del pedido
            UPDATE tp_fabrica_automovil_bd1.pedido
            SET fecha_entrega_estimada = v_fecha_entrega_estimada
            WHERE pedido_id = v_pedido_id;
        END IF;
    END IF;
END 

&& DELIMITER 

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Views

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER &&

CREATE VIEW vw_vehiculos_pedido AS
SELECT 
	pd.pedido_id,
	pd.pedido_detalle_id,
    v.vehiculo_id,
    m.modelo,
    v.precio,
    pd.cantidad
FROM 
    tp_fabrica_automovil_bd1.vehiculo v
JOIN 
    tp_fabrica_automovil_bd1.pedido_detalle pd ON pd.pedido_detalle_id = v.pedido_detalle_id
JOIN tp_fabrica_automovil_bd1.modelo m ON m.modelo_id = v.modelo_id;

&& DELIMITER 

DELIMITER &&

CREATE VIEW vw_vehiculos_en_montaje AS
SELECT 
    pd.pedido_id AS NumeroPedido,
    pd.pedido_detalle_id AS NumeroPedidoDetalle,
    v.numero_chasis AS chasis,
    CASE 
        WHEN v.fecha_egreso IS NOT NULL THEN 'Finalizado'
        ELSE 
            COALESCE(
                CONCAT('En estación: ', 
                GROUP_CONCAT(et.estacion_trabajo_id SEPARATOR ', ')), 
                'No asignado a ninguna estación'
            )
    END AS estado
FROM 
    tp_fabrica_automovil_bd1.pedido_detalle pd
JOIN 
    tp_fabrica_automovil_bd1.vehiculo v ON pd.pedido_detalle_id = v.pedido_detalle_id
LEFT JOIN 
    tp_fabrica_automovil_bd1.estacion_trabajo et ON v.vehiculo_id = et.vehiculo_id
GROUP BY 
    pd.pedido_id, pd.pedido_detalle_id, v.numero_chasis, v.fecha_egreso;

&& DELIMITER 

DELIMITER &&

CREATE VIEW vw_vehiculos_en_montaje AS
SELECT 
    pd.pedido_id AS NumeroPedido,
    pd.pedido_detalle_id AS NumeroPedidoDetalle,
    v.numero_chasis AS chasis,
    CASE 
        WHEN v.fecha_egreso IS NOT NULL THEN 'Finalizado'
        ELSE 
            COALESCE(
                CONCAT('En estación: ', 
                GROUP_CONCAT(et.estacion_trabajo_id SEPARATOR ', ')), 
                'No asignado a ninguna estación'
            )
    END AS estado
FROM 
    tp_fabrica_automovil_bd1.pedido_detalle pd
JOIN 
    tp_fabrica_automovil_bd1.vehiculo v ON pd.pedido_detalle_id = v.pedido_detalle_id
LEFT JOIN 
    tp_fabrica_automovil_bd1.estacion_trabajo et ON v.vehiculo_id = et.vehiculo_id
GROUP BY 
    pd.pedido_id, pd.pedido_detalle_id, v.numero_chasis, v.fecha_egreso;

&& DELIMITER 

DELIMITER &&

CREATE VIEW vw_tiempo_promedio_construccion_linea AS
SELECT 
    lm.linea_montaje_id,
    COUNT(v.vehiculo_id) AS numero_vehiculos,
    CASE
        WHEN COUNT(v.vehiculo_id) = 0 THEN 'No hay vehículos terminados en la línea de montaje especificada.'
        ELSE CONCAT(
            'Tiempo promedio de construcción: ',
            ROUND(
                AVG(DATEDIFF(v.fecha_egreso, v.fecha_ingreso)), 
                2
            ) / 30, 
            ' vehiculos por mes'
        )
    END AS tiempo_promedio
FROM 
    tp_fabrica_automovil_bd1.linea_montaje lm
LEFT JOIN 
    tp_fabrica_automovil_bd1.vehiculo v ON lm.linea_montaje_id = v.linea_montaje_id
    AND v.fecha_egreso IS NOT NULL
GROUP BY 
    lm.linea_montaje_id;

&& DELIMITER 

DELIMITER &&

CREATE VIEW vw_cantidades_producto_pedido AS
SELECT 
    pd.pedido_id AS PedidoID,
    SUM(CASE WHEN p.nombre = 'Chasis' THEN pv.cantidad ELSE 0 END) AS Chasis,
    SUM(CASE WHEN p.nombre = 'Motor' THEN pv.cantidad ELSE 0 END) AS Motor,
    SUM(CASE WHEN p.nombre = 'Sistema de transmision' THEN pv.cantidad ELSE 0 END) AS SistemaTransmision,
    SUM(CASE WHEN p.nombre = 'Sistema de suspension' THEN pv.cantidad ELSE 0 END) AS SistemaSuspension,
    SUM(CASE WHEN p.nombre = 'Sistema de frenos' THEN pv.cantidad ELSE 0 END) AS SistemaFrenos,
    SUM(CASE WHEN p.nombre = 'Sistema de direccion' THEN pv.cantidad ELSE 0 END) AS SistemaDireccion,
    SUM(CASE WHEN p.nombre = 'Sistema de escape' THEN pv.cantidad ELSE 0 END) AS SistemaEscape,
    SUM(CASE WHEN p.nombre = 'Sistema electrico' THEN pv.cantidad ELSE 0 END) AS SistemaElectrico,
    SUM(CASE WHEN p.nombre = 'Interior' THEN pv.cantidad ELSE 0 END) AS Interior,
    SUM(CASE WHEN p.nombre = 'Carroceria' THEN pv.cantidad ELSE 0 END) AS Carroceria,
    SUM(CASE WHEN p.nombre = 'Cristales' THEN pv.cantidad ELSE 0 END) AS Cristales,
    SUM(CASE WHEN p.nombre = 'Pintura' THEN pv.cantidad ELSE 0 END) AS Pintura
FROM 
    tp_fabrica_automovil_bd1.pedido_detalle pd
JOIN 
    tp_fabrica_automovil_bd1.vehiculo v ON pd.pedido_detalle_id = v.pedido_detalle_id
JOIN 
    tp_fabrica_automovil_bd1.producto_vehiculo pv ON pv.modelo_id = v.modelo_id
JOIN 
    tp_fabrica_automovil_bd1.producto p ON p.producto_id = pv.producto_id
GROUP BY 
    pd.pedido_id;

&& DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INDEX

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE INDEX idx_producto_nombre ON tp_fabrica_automovil_bd1.producto (nombre);

CREATE INDEX idx_vehiculo_modelo ON tp_fabrica_automovil_bd1.modelo (modelo);

CREATE INDEX idx_vehiculo_numero_chasis ON tp_fabrica_automovil_bd1.vehiculo (numero_chasis);

CREATE INDEX idx_vehiculo_fecha_finalizacion ON tp_fabrica_automovil_bd1.vehiculo (fecha_egreso);

CREATE INDEX idx_estacion_trabajo_tarea ON tp_fabrica_automovil_bd1.estacion_trabajo (tarea);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Prueba ABM

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Fabrica automovil ABM

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
CALL sp_alta_fabrica_automovil('Fabrica Automovil 1', @nResultado, @cMensaje);
SET @ultimo_fabrica_automovil_id = LAST_INSERT_ID();
SELECT *, @ultimo_fabrica_automovil_id AS SelectUltimoFabricaAutomovilId FROM fabrica_automovil;

CALL sp_modificacion_fabrica_automovil(@ultimo_fabrica_automovil_id, 'Fabrica Automovil 1 Modificacion', @nResultado, @cMensaje);
SELECT *, @ultimo_fabrica_automovil_id AS SelectUltimoFabricaAutomovilId FROM fabrica_automovil;

CALL sp_baja_fabrica_automovil(@ultimo_fabrica_automovil_id, @nResultado, @cMensaje);
SELECT *, @ultimo_fabrica_automovil_id AS SelectUltimoFabricaAutomovilId FROM fabrica_automovil;

CALL sp_alta_fabrica_automovil('Fabrica Automovil 1', @nResultado, @cMensaje);
SET @ultimo_fabrica_automovil_id = LAST_INSERT_ID();
SELECT *, @ultimo_fabrica_automovil_id AS SelectUltimoFabricaAutomovilId FROM fabrica_automovil;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Modelo ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_modelo('Modelo 1', @nResultado, @cMensaje);
SET @ultimo_modelo_id = LAST_INSERT_ID();
SELECT *, @ultimo_modelo_id AS SelectUltimoModeloId FROM modelo;

CALL sp_modificacion_modelo(@ultimo_modelo_id, 'Modelo 1 Modificacion', @nResultado, @cMensaje);
SELECT *, @ultimo_modelo_id AS SelectUltimoModeloId FROM modelo;

CALL sp_baja_modelo(@ultimo_modelo_id, @nResultado, @cMensaje);
SELECT *, @ultimo_modelo_id AS SelectUltimoModeloId FROM modelo;

CALL sp_alta_modelo('Modelo 1', @nResultado, @cMensaje);
SET @ultimo_modelo_id = LAST_INSERT_ID();
SELECT *, @ultimo_modelo_id AS SelectUltimoModeloId FROM modelo;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Concesionaria ABM

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_concesionaria('Concesionaria 1', @ultimo_fabrica_automovil_id, @nResultado, @cMensaje);
SET @ultimo_concesionaria_id = LAST_INSERT_ID();
SELECT *, @ultimo_concesionaria_id AS SelectUltimoConcesionariaId FROM concesionaria;

CALL sp_modificacion_concesionaria(@ultimo_concesionaria_id, 'Concesionaria 1 Modificacion', @ultimo_fabrica_automovil_id, @nResultado, @cMensaje);
SELECT *, @ultimo_concesionaria_id AS SelectUltimoConcesionariaId FROM concesionaria;

CALL sp_baja_concesionaria(@ultimo_concesionaria_id, @nResultado, @cMensaje);
SELECT *, @ultimo_concesionaria_id AS SelectUltimoConcesionariaId FROM concesionaria;

CALL sp_alta_concesionaria('Concesionaria 1', @ultimo_fabrica_automovil_id, @nResultado, @cMensaje);
SET @ultimo_concesionaria_id = LAST_INSERT_ID();
SELECT *, @ultimo_concesionaria_id AS SelectUltimoConcesionariaId FROM concesionaria;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Proveedor ABM

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_proveedor('Proveedor 1', @nResultado, @cMensaje);
SET @ultimo_proveedor_id = LAST_INSERT_ID();
SELECT *, @ultimo_proveedor_id AS SelectUltimoProveedorId FROM proveedor;

CALL sp_modificacion_proveedor(@ultimo_proveedor_id, 'Proveedor 1 Modificacion', @nResultado, @cMensaje);
SELECT *, @ultimo_proveedor_id AS SelectUltimoProveedorId FROM proveedor;

CALL sp_baja_proveedor(@ultimo_proveedor_id, @nResultado, @cMensaje);
SELECT *, @ultimo_proveedor_id AS SelectUltimoProveedorId FROM proveedor;

CALL sp_alta_proveedor('Proveedor 1', @nResultado, @cMensaje);
SET @ultimo_proveedor_id = LAST_INSERT_ID();
SELECT *, @ultimo_proveedor_id AS SelectUltimoProveedorId FROM proveedor;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Producto ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_producto('Producto 1', 'Producto 1 Descripcion', @ultimo_fabrica_automovil_id, @nRespuesta, @cMensaje);
SET @ultimo_producto_id = LAST_INSERT_ID();
SELECT *, @ultimo_producto_id AS SelectUltimoProductoId FROM producto;

CALL sp_modificacion_producto(@ultimo_producto_id, 'Producto 1 Modificacion', 'Producto 1 Descripcion', @ultimo_fabrica_automovil_id, @nResultado, @cMensaje);
SELECT *, @ultimo_producto_id AS SelectUltimoproductoId FROM producto;

CALL sp_baja_producto(@ultimo_producto_id, @nResultado, @cMensaje);
SELECT *, @ultimo_producto_id AS SelectUltimoProductoId FROM producto;

CALL sp_alta_producto('Producto 1', 'Producto 1 Descripcion', @ultimo_fabrica_automovil_id, @nResultado, @cMensaje);
SET @ultimo_producto_id = LAST_INSERT_ID();
SELECT *, @ultimo_producto_id AS SelectUltimoProductoId FROM producto;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pedido ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_pedido(CURDATE(), 0, @ultimo_concesionaria_id, @nRespuesta, @cMensaje);
SET @ultimo_pedido_id = LAST_INSERT_ID();
SELECT *, @ultimo_pedido_id AS SelectUltimoPedidoId FROM pedido;

CALL sp_modificacion_pedido(@ultimo_pedido_id, CURDATE(), CURDATE(), 1000000, @ultimo_concesionaria_id, @nRespuesta, @cMensaje);
SELECT *, @ultimo_pedido_id AS SelectUltimoPedidoId FROM pedido;

CALL sp_baja_pedido(@ultimo_pedido_id, @nResultado, @cMensaje);
SELECT *, @ultimo_pedido_id AS SelectUltimoPedidoId FROM pedido;

CALL sp_alta_pedido(CURDATE(), 0, @ultimo_concesionaria_id, @nRespuesta, @cMensaje);
SET @ultimo_pedido_id = LAST_INSERT_ID();
SELECT *, @ultimo_pedido_id AS SelectUltimoPedidoId FROM pedido;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Pedido detalle ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_pedido_detalle(@ultimo_pedido_id, 'Modelo 1', 1, @nRespuesta, @cMensaje);
SET @ultimo_pedido_detalle_id = LAST_INSERT_ID();
SELECT *, @ultimo_pedido_detalle_id AS SelectUltimoPedidoDetalleId FROM pedido_detalle;

CALL sp_modificacion_pedido_detalle(@ultimo_pedido_detalle_id, 'X', 0, 1000, @ultimo_modelo_id, @ultimo_pedido_id, @nRespuesta, @cMensaje);
SELECT *, @ultimo_pedido_detalle_id AS SelectUltimoPedidoDetalleId FROM pedido_detalle;

CALL sp_baja_pedido_detalle(@ultimo_pedido_detalle_id, @nResultado, @cMensaje);
SELECT *, @ultimo_pedido_detalle_id AS SelectUltimoPedidoDetalleId FROM pedido_detalle;

CALL sp_alta_pedido_detalle(@ultimo_pedido_id, 'Modelo 1', 1, @nRespuesta, @cMensaje);
SET @ultimo_pedido_detalle_id = LAST_INSERT_ID();
SELECT *, @ultimo_pedido_detalle_id AS SelectUltimoPedidoDetalleId FROM pedido_detalle;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Producto proveedor ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_producto_proveedor(@ultimo_producto_id, @ultimo_proveedor_id, 100, 1, @nRespuesta, @cMensaje);
SELECT producto_id, proveedor_id INTO @ultimo_producto_id, @ultimo_proveedor_id FROM producto_proveedor pp WHERE pp.producto_id = @ultimo_producto_id AND pp.proveedor_id = @ultimo_proveedor_id LIMIT 1;
SELECT * FROM producto_proveedor;

CALL sp_modificacion_producto_proveedor(@ultimo_producto_id, @ultimo_proveedor_id, 999, 1, @nRespuesta, @cMensaje);
SELECT * FROM producto_proveedor;

CALL sp_baja_producto_proveedor(@ultimo_producto_id, @ultimo_proveedor_id, @nResultado, @cMensaje);
SELECT * FROM producto_proveedor;

CALL sp_alta_producto_proveedor(@ultimo_producto_id, @ultimo_proveedor_id, 100, 1, @nRespuesta, @cMensaje);
SELECT producto_id, proveedor_id INTO @ultimo_producto_id, @ultimo_proveedor_id FROM producto_proveedor pp WHERE pp.producto_id = @ultimo_producto_id AND pp.proveedor_id = @ultimo_proveedor_id LIMIT 1;
SELECT * FROM producto_proveedor;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Producto vehiculo ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_producto_vehiculo(@ultimo_producto_id, @ultimo_modelo_id, 100, @nRespuesta, @cMensaje);
SELECT producto_id, modelo_id INTO @ultimo_producto_id, @ultimo_modelo_id FROM producto_vehiculo pv WHERE pv.producto_id = @ultimo_producto_id AND pv.modelo_id = @ultimo_modelo_id LIMIT 1;
SELECT *, @ultimo_producto_id, @ultimo_modelo_id FROM producto_vehiculo;

CALL sp_modificacion_producto_vehiculo(@ultimo_producto_id, @ultimo_modelo_id, 999, @nRespuesta, @cMensaje);
SELECT * FROM producto_vehiculo;

CALL sp_baja_producto_vehiculo(@ultimo_producto_id, @ultimo_modelo_id, @nResultado, @cMensaje);
SELECT *, @ultimo_producto_id, @ultimo_modelo_id FROM producto_vehiculo;

CALL sp_alta_producto_vehiculo(@ultimo_producto_id, @ultimo_modelo_id, 100, @nRespuesta, @cMensaje);
SELECT producto_id, modelo_id INTO @ultimo_producto_id, @ultimo_modelo_id FROM producto_vehiculo pv WHERE pv.producto_id = @ultimo_producto_id AND pv.modelo_id = @ultimo_modelo_id LIMIT 1;
SELECT *, @ultimo_producto_id, @ultimo_modelo_id FROM producto_vehiculo;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Linea montaje ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CALL sp_alta_linea_montaje(0, 'Libre', 0, "Modelo 2", @ultimo_fabrica_automovil_id, @nRespuesta, @cMensaje);
SELECT modelo_id INTO @ultimo_modelo_id FROM modelo m WHERE m.modelo = "Modelo 2";
SELECT linea_montaje_id INTO @ultimo_linea_montaje_id FROM linea_montaje lm WHERE lm.modelo_id = @ultimo_modelo_id;
SELECT *, @ultimo_linea_montaje_id AS SelectUltimoLineaMontajeId FROM linea_montaje;

CALL sp_modificacion_linea_montaje(@ultimo_linea_montaje_id, 1000, 'Libre', 0, @ultimo_modelo_id, @ultimo_fabrica_automovil_id, @nRespuesta, @cMensaje);
SELECT * FROM linea_montaje;

CALL sp_baja_linea_montaje(@ultimo_linea_montaje_id, @nResultado, @cMensaje);
SELECT * FROM linea_montaje;

CALL sp_alta_linea_montaje(0, 'Libre', 0, "Modelo 2", @ultimo_fabrica_automovil_id, @nRespuesta, @cMensaje);
SELECT modelo_id INTO @ultimo_modelo_id FROM modelo m WHERE m.modelo = "Modelo 2";
SELECT linea_montaje_id INTO @ultimo_linea_montaje_id FROM linea_montaje lm WHERE lm.modelo_id = @ultimo_modelo_id;
SELECT *, @ultimo_linea_montaje_id AS SelectUltimoLineaMontajeId FROM linea_montaje;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Estacion trabajo ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
CALL sp_alta_estacion_trabajo('A', 1, 'Libre', @ultimo_linea_montaje_id, null, @nResultado, @cMensaje);
SET @ultimo_estacion_trabajo_id = LAST_INSERT_ID();
SELECT *, @ultimo_estacion_trabajo_id AS SelectUltimoEstacionTrabajoId FROM estacion_trabajo;

CALL sp_modificacion_estacion_trabajo(@ultimo_estacion_trabajo_id, 'AAAAAAAAA', 1, 'Libre', @ultimo_linea_montaje_id, null, @nResultado, @cMensaje);
SELECT *, @ultimo_estacion_trabajo_id AS SelectUltimoEstacionTrabajoId FROM estacion_trabajo;

CALL sp_baja_estacion_trabajo(@ultimo_estacion_trabajo_id, @nResultado, @cMensaje);
SELECT *, @ultimo_estacion_trabajo_id AS SelectUltimoEstacionTrabajoId FROM estacion_trabajo;

CALL sp_alta_estacion_trabajo('A', 1, 'Libre', @ultimo_linea_montaje_id, null, @nResultado, @cMensaje);
SET @ultimo_estacion_trabajo_id = LAST_INSERT_ID();
SELECT *, @ultimo_estacion_trabajo_id AS SelectUltimoEstacionTrabajoId FROM estacion_trabajo;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Vehiculo ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
CALL sp_alta_vehiculo('AAAAAA', @ultimo_modelo_id, CURDATE(), NULL, 0, @ultimo_fabrica_automovil_id, @ultimo_linea_montaje_id, @ultimo_pedido_detalle_id, @nResultado, @cMensaje);
SET @ultimo_vehiculo_id = LAST_INSERT_ID();
SELECT *, @ultimo_vehiculo_id AS SelectUltimoVehiculoId FROM vehiculo;

CALL sp_modificacion_vehiculo(@ultimo_vehiculo_id, 'AAAAAA', @ultimo_modelo_id, CURDATE(), NULL, 100000, @ultimo_fabrica_automovil_id, @ultimo_linea_montaje_id, @ultimo_pedido_detalle_id, @nResultado, @cMensaje);
SELECT *, @ultimo_vehiculo_id AS SelectUltimoVehiculoId FROM vehiculo;

CALL sp_baja_vehiculo(@ultimo_vehiculo_id, @nResultado, @cMensaje);
SELECT *, @ultimo_vehiculo_id AS SelectUltimoVehiculoId FROM vehiculo;

CALL sp_alta_vehiculo('AAAAAA', @ultimo_modelo_id, CURDATE(), NULL, 0, @ultimo_fabrica_automovil_id, @ultimo_linea_montaje_id, @ultimo_pedido_detalle_id, @nResultado, @cMensaje);
SET @ultimo_vehiculo_id = LAST_INSERT_ID();
SELECT *, @ultimo_vehiculo_id AS SelectUltimoVehiculoId FROM vehiculo;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Estacion trabajo vehiculo ABM

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
CALL sp_alta_estacion_trabajo_vehiculo(@ultimo_estacion_trabajo_id, @ultimo_vehiculo_id, CURDATE(), NULL, 0, @nRespuesta, @cMensaje);
SELECT estacion_trabajo_id, vehiculo_id INTO @ultimo_estacion_trabajo_id, @ultimo_vehiculo_id FROM estacion_trabajo_vehiculo etv WHERE etv.estacion_trabajo_id = @ultimo_estacion_trabajo_id AND etv.vehiculo_id = @ultimo_vehiculo_id LIMIT 1;
SELECT *, @ultimo_estacion_trabajo_id, @ultimo_vehiculo_id FROM estacion_trabajo_vehiculo;

CALL sp_modificacion_estacion_trabajo_vehiculo(@ultimo_estacion_trabajo_id, @ultimo_vehiculo_id, CURDATE(), NULL, 1, @nRespuesta, @cMensaje);
SELECT *, @ultimo_estacion_trabajo_id, @ultimo_vehiculo_id FROM estacion_trabajo_vehiculo;

CALL sp_baja_estacion_trabajo_vehiculo(@ultimo_estacion_trabajo_id, @ultimo_vehiculo_id, @nResultado, @cMensaje);
SELECT *, @ultimo_estacion_trabajo_id, @ultimo_vehiculo_id FROM estacion_trabajo_vehiculo;

CALL sp_alta_estacion_trabajo_vehiculo(@ultimo_estacion_trabajo_id, @ultimo_vehiculo_id, CURDATE(), NULL, 0, @nRespuesta, @cMensaje);
SELECT estacion_trabajo_id, vehiculo_id INTO @ultimo_estacion_trabajo_id, @ultimo_vehiculo_id FROM estacion_trabajo_vehiculo etv WHERE etv.estacion_trabajo_id = @ultimo_estacion_trabajo_id AND etv.vehiculo_id = @ultimo_vehiculo_id LIMIT 1;
SELECT *, @ultimo_estacion_trabajo_id, @ultimo_vehiculo_id FROM estacion_trabajo_vehiculo;