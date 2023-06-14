CREATE DATABASE IF NOT EXISTS conferencias_db;

USE conferencias_db;

CREATE TABLE IF NOT EXISTS evento
(
	eve_id INT NOT NULL AUTO_INCREMENT,
    eve_nombre VARCHAR(50) NOT NULL,
    eve_fecha DATE NOT NULL,
    eve_hora TIME NOT NULL,
    eve_duracion INT NOT NULL COMMENT 'En minutos',
    eve_ponente VARCHAR(50),
    PRIMARY KEY(eve_id),
    INDEX(eve_nombre),
    INDEX(eve_fecha),
    INDEX(eve_ponente)
);

CREATE TABLE IF NOT EXISTS estudiante
(
	est_id INT NOT NULL AUTO_INCREMENT,
    est_nombre VARCHAR(50) NOT NULL,
    est_ap_pat VARCHAR(50) NOT NULL,
    est_ap_mat VARCHAR(50),
    est_carrera VARCHAR(50) NOT NULL,
    est_correo VARCHAR(50) NOT NULL,
    PRIMARY KEY (est_id),
    INDEX(est_nombre, est_ap_pat, est_ap_mat),
    UNIQUE(est_correo)
);

CREATE TABLE IF NOT EXISTS asistencia
(
	asi_eve_id INT NOT NULL,
	asi_est_id INT NOT NULL,
	asi_hora_llegada TIME NOT NULL,
	PRIMARY KEY(asi_eve_id, asi_est_id),
    CONSTRAINT fk_evento_asistencia
		FOREIGN KEY (asi_eve_id)
		REFERENCES evento (eve_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT fk_estudiante_asistencia
		FOREIGN KEY (asi_est_id)
        REFERENCES estudiante (est_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE estudiante ADD COLUMN est_semestre TINYINT AFTER est_carrera;

ALTER TABLE estudiante ADD INDEX (est_carrera);

ALTER TABLE evento DROP INDEX eve_ponente;

ALTER TABLE evento CHANGE eve_ponente eve_orador VARCHAR(50);

ALTER TABLE evento ADD COLUMN eve_nota TEXT;

ALTER TABLE asistencia DROP CONSTRAINT fk_evento_asistencia;

ALTER TABLE asistencia DROP CONSTRAINT fk_estudiante_asistencia; 

ALTER TABLE asistencia DROP PRIMARY KEY;

ALTER TABLE asistencia ADD COLUMN asi_id INT NOT NULL;

ALTER TABLE asistencia ADD PRIMARY KEY (asi_id);

ALTER TABLE asistencia MODIFY asi_id INT NOT NULL AUTO_INCREMENT;