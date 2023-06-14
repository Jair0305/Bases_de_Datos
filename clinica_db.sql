-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema clinica_medica_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema clinica_medica_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `clinica_medica_db` DEFAULT CHARACTER SET utf8 ;
USE `clinica_medica_db` ;

-- -----------------------------------------------------
-- Table `clinica_medica_db`.`paciente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinica_medica_db`.`paciente` (
  `pac_id` INT NOT NULL AUTO_INCREMENT,
  `pac_nombre_completo` VARCHAR(80) NOT NULL,
  `pac_correo` VARCHAR(30) NOT NULL,
  `pac_telefono` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`pac_id`),
  UNIQUE INDEX `pac_telefono` (`pac_telefono` ASC) VISIBLE,
  UNIQUE INDEX `pac_correo` (`pac_correo` ASC) VISIBLE,
  INDEX `pac_nombre_completo` (`pac_nombre_completo` ASC) INVISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clinica_medica_db`.`medico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinica_medica_db`.`medico` (
  `med_id` INT NOT NULL AUTO_INCREMENT,
  `med_nombre_completo` VARCHAR(80) NOT NULL,
  `med_especialidad` VARCHAR(45) NOT NULL,
  `med_cosultorio` VARCHAR(30) NULL,
  `med_honorarios` DECIMAL(7,2) NULL COMMENT 'pesos mexicanos',
  `medicocol` VARCHAR(45) NULL,
  PRIMARY KEY (`med_id`),
  INDEX `med_nombre_completo` (`med_nombre_completo` ASC) VISIBLE,
  UNIQUE INDEX `med_nombre_completo_consultorio` (`med_cosultorio` ASC, `med_nombre_completo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clinica_medica_db`.`cita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clinica_medica_db`.`cita` (
  `cit_id` INT NOT NULL AUTO_INCREMENT,
  `cit_pac_id` INT NULL,
  `cit_med_id` INT NULL,
  `cit_fecha_hora` DATETIME NOT NULL,
  `cit_diagnostico` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`cit_id`),
  INDEX `cita` (`cit_fecha_hora` ASC, `cit_diagnostico` ASC, `cit_id` ASC) VISIBLE,
  UNIQUE INDEX `cit_fecha_hora_id_medico` (`cit_fecha_hora` ASC, `cit_med_id` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE `clinica_medica_db`;
# ------------------------ EJERCICIOS PARA PRACTICAR ------------------------
# 1. Crea un índice para la especialidad en la tabla medico.
CREATE INDEX med_especialidad ON medico(med_especialidad);

# 2. Crea un atributo de clinica al final de la tabla medico con tipo VARCHAR(30) NOT NULL.
ALTER TABLE medico ADD med_clinica VARCHAR (30) NOT NULL;

# 3. Haz que la combinación de los atributos de nombre y clinica en la tabla medico sea única.
ALTER TABLE medico ADD UNIQUE(med_nombre_completo, med_clinica);

# 4. Crea un atributo de dirección antes del atributo de teléfono 
# en la tabla paciente con tipo VARCHAR(60).