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
