CREATE DATABASE IF NOT EXISTS catalogo_musical_db;

USE catalogo_musical_db;

CREATE TABLE IF NOT EXISTS interprete
(
	int_id INT NOT NULL AUTO_INCREMENT,
    int_nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (ind_id),
    UNIQUE (in_nombre)
);

CREATE TABLE IF NOT EXISTS disco
(
	dis_id INT NOT NULL AUTO_INCREMENT,
    dis_titulo VARCHAR(50) NOT NULL,
    dis_sello VARCHAR(50),
    dis_genero VARCHAR(30),
    dis_anio YEAR NOT NULL,
    dis_int_id INT,
    PRIMARY KEY (dis_id),
    INDEX (dis_titulo),
    INDEX (dis_genero),
    UNIQUE (dis_titulo, dis_int_id),
    CONSTRAINT fk_interprete_disco
		FOREIGN KEY (dis_int_id)
        REFERENCES interprete (int_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS cancion
(
	can_id INT NOT NULL AUTO_INCREMENT,
	can_titulo VARCHAR(50) NOT NULL,
    can_num_pista INT,
    can_duracion INT NOT NULL COMMENT 'Duracion en minutos',
    can_dis_id INT,
    PRIMARY KEY (can_id),
    INDEX (can_titulo),
    UNIQUE (can_titulo, can_dis_id),
    CONSTRAINT fk_disco_cancion
		FOREIGN KEY (can_dis_id)
        REFERENCES disco (dis_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);