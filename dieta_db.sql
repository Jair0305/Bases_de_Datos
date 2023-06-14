CREATE DATABASE IF NOT EXISTS dieta_db;

USE dieta_db;

CREATE TABLE IF NOT EXISTS paciente
(
	pac_nombre VARCHAR(50) NOT NULL,
    pac_edad INT NOT NULL,
    pac_estatura INT NOT NULL COMMENT 'En metros',
    pac_peso INT NOT NULL COMMENT 'En kg',
    pac_correo VARCHAR(50) NOT NULL,
    UNIQUE(pac_correo),
    INDEX(pac_nombre)
);

CREATE TABLE IF NOT EXISTS alimento
(
	ali_nombre VARCHAR(50) NOT NULL,
    ali_medida_porcion INT NOT NULL,
    ali_tipo ENUM('frutas','verduras','carnes y proteínas','lácteos','granos y cereales','aceites y grasas'),
    ali_calorias_porcion INT NOT NULL COMMENT 'kilocalorias',
    INDEX(ali_nombre),
    UNIQUE(ali_nombbre, ali_tipo)
);

CREATE TABLE IF NOT EXISTS dieta
(
	die_fecha_inicio DATE NOT NULL,
    die_fecha_fin DATE,
    INDEX(die_fecha_inicio)
);