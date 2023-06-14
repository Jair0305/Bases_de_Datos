CREATE DATABASE IF NOT EXISTS biblioteca_db;

USE biblioteca_db;

CREATE TABLE IF NOT EXISTS libro
(
	lib_id INT NOT NULL AUTO_INCREMENT,
    lib_titulo VARCHAR(50) NOT NULL,
    lib_autor VARCHAR (80) NOT NULL,
    lib_editorial VARCHAR(50) NOT NULL,
    lib_edicion VARCHAR(20),
    PRIMARY KEY(lib_id),
    INDEX(lib_titulo),
    INDEX(lib_autor)
);

CREATE TABLE IF NOT EXISTS usuario
(
	usu_id INT NOT NULL AUTO_INCREMENT,
    usu_nombre VARCHAR(20) NOT NULL,
    usu_ap_pat VARCHAR(20) NOT NULL,
    usu_ap_mat VARCHAR(20),
    usu_correo VARCHAR(50) NOT NULL,
    usu_activo ENUM('s','n'),
    PRIMARY KEY(usu_id),
    UNIQUE(usu_correo),
    INDEX(usu_nombre)
);

CREATE TABLE IF NOT EXISTS prestamo
(
	pres_id INT NOT NULL AUTO_INCREMENT,
    pres_usu_id INT NOT NULL,
    pres_fecha_p DATETIME,
    pres_fecha_r DATETIME,
    PRIMARY KEY (pres_id),
    CONSTRAINT fk_prestamo_usuario
		FOREIGN KEY (pres_usu_id)
        REFERENCES usuario (usu_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS detalle
(
	det_pres_id INT NOT NULL,
    det_lib_id INT NOT NULL,
    det_fecha_r_real DATE,
    det_dias_retraso INT NOT NULL,
    PRIMARY KEY(det_pres_id, det_lib_id),
    CONSTRAINT fk_detalle_prestamo
		FOREIGN KEY(det_pres_id)
        REFERENCES prestamo(pres_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_detalle_libro
		FOREIGN KEY(det_lib_id)
        REFERENCES libro(lib_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE usuario ADD COLUMN usu_tel VARCHAR(10) NOT NULL;

ALTER TABLE usuario ADD UNIQUE(usu_tel);

ALTER TABLE usuario CHANGE usu_correo usu_correo_e VARCHAR(50) NOT NULL;

ALTER TABLE libro MODIFY lib_edicion TINYINT;

ALTER TABLE detalle DROP CONSTRAINT fk_detalle_prestamo;

ALTER TABLE detalle DROP CONSTRAINT fk_detalle_libro;

ALTER TABLE detalle DROP PRIMARY KEY;

ALTER TABLE detalle ADD COLUMN det_id INT NOT NULL;

ALTER TABLE detalle ADD PRIMARY KEY(det_id);

ALTER TABLE detalle MODIFY det_id INT NOT NULL AUTO_INCREMENT;

ALTER TABLE detalle MODIFY det_pres_id INT NULL;

ALTER TABLE detalle MODIFY det_lib_id INT NULL;