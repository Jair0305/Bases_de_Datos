-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema control_escolar_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema control_escolar_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `control_escolar_db` DEFAULT CHARACTER SET utf8 ;
USE `control_escolar_db` ;

-- -----------------------------------------------------
-- Table `control_escolar_db`.`estudiante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `control_escolar_db`.`estudiante` (
  `est_nombre` VARCHAR(30) NOT NULL,
  `est_appat` VARCHAR(30) NOT NULL,
  `est_apmat` VARCHAR(30) NULL,
  `est_correo` VARCHAR(30) NOT NULL,
  `est_car_id` INT NULL,
  PRIMARY KEY (`est_correo`),
  INDEX `est_nombre_completo` (`est_nombre` ASC, `est_appat` ASC, `est_apmat` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `control_escolar_db`.`carrera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `control_escolar_db`.`carrera` (
  `car_nombre` VARCHAR(80) NOT NULL,
  `car_division` VARCHAR(45) NOT NULL,
  `car_sede` VARCHAR(30) NOT NULL,
  `car_iniciales` VARCHAR(7) NOT NULL COMMENT 'Iniciales de la carrera, ejemplo: LISC',
  PRIMARY KEY (`car_iniciales`, `car_division`),
  INDEX `car_nombre` (`car_nombre` ASC) VISIBLE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

ALTER TABLE estudiante ADD COLUMN est_nua VARCHAR(7) NOT NULL FIRST;

ALTER TABLE estudiante RENAME alumno;

ALTER TABLE alumno MODIFY est_id INT;

ALTER TABLE alumno ADD COLUMN est_id INT AFTER est_nua;

ALTER TABLE alumno DROP PRIMARY KEY;

ALTER TABLE alumno ADD PRIMARY KEY(est_nua);

ALTER TABLE alumno DROP COLUMN est_id;

ALTER TABLE carrera ADD COLUMN car_campus VARCHAR(40) NOT NULL;

ALTER TABLE alumno ADD COLUMN est_semestre TINYINT NOT NULL AFTER est_apmat;

ALTER TABLE alumno ADD INDEX (est_semestre);

ALTER TABLE alumno RENAME estudiante;