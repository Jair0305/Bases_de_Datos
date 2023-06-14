CREATE DATABASE IF NOT EXISTS dietas_db;

USE dietas_db;

CREATE TABLE IF NOT EXISTS paciente
(
	pac_nombre VARCHAR(50) NOT NULL,
    pac_edad INT NOT NULL,
    pac_estatura INT NOT NULL COMMENT 'En centimetros',
    pac_peso INT NOT NULL COMMENT 'En kg',
    pac_correo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS alimento
(
	ali_nombre VARCHAR(50) NOT NULL,
    ali_medida_porcion INT NOT NULL,
    ali_tipo ENUM('desayuno','comida','cena'),
    ali_calorias_porcion INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dieta
(
	die_fecha_inicio DATE NOT NULL,
    die_fecha_fin DATE
);