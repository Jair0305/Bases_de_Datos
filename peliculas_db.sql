CREATE DATABASE IF NOT EXISTS peliculas_db;

USE peliculas_db;

CREATE TABLE IF NOT EXISTS actor
(
	act_id INT NOT NULL AUTO_INCREMENT,
	act_nombre VARCHAR(30) NOT NULL,
	act_nombre_real VARCHAR(50),
	act_fecha_nac DATE,
	act_pais_nac VARCHAR(50),
    PRIMARY KEY (act_id),
    INDEX (act_pais_nac),
    UNIQUE(act_nombre)
);

#cantidades fisicas o medidas, son de tipo numerico (int, float)
#cuando vayamos a trabajar con medidas o cantidades o propiedades fisicas
#es importante definir las unidades de medida que se utilizaran en los atributos
#para evitar confusiones con el usuario y con otro desarrolladores
#kg, metros (anchura, altura)
#valores monetarios, pesos, dolares etc.

#si no se definen las unidades, pueden suceder errores al capturar informacion
#por ejemplo, pedir al usuario la altura, queriendo obtenerla en metros y la recibimos en cm

CREATE TABLE IF NOT EXISTS pelicula
(
	pel_id INT NOT NULL AUTO_INCREMENT,
	pel_titulo VARCHAR(50) NOT NULL,
	pel_genero VARCHAR(50) NOT NULL,
	pel_duracion INT NOT NULL COMMENT 'duracion en minutos',
	pel_clas ENUM('AA','A','B','B15','C','D'),
	pel_act_id INT,
    PRIMARY KEY (pel_id),
    INDEX(pel_genero),
    INDEX(pel_clas),
    INDEX(pel_titulo)
);

CREATE TABLE IF NOT EXISTS elenco
(
	ele_pel_id INT NOT NULL,
	ele_act_id INT NOT NULL,
    ele_personaje VARCHAR(50),
    ele_salario DECIMAL(15,2),
    ele_papel ENUM('Protagonico','Soporte','Extra'),
    PRIMARY KEY (ele_pel_id, ele_act_id),
	CONSTRAINT fk_pelicula_elenco
		FOREIGN KEY(ele_pel_id)
        REFERENCES pelicula (pel_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_actor_elenco
		FOREIGN KEY(ele_act_id)
        REFERENCES actor(act_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE elenco ADD INDEX (ele_personaje);

ALTER TABLE pelicula ADD pel_formato ENUM('3D','Imax','Digital');

ALTER TABLE actor DROP INDEX act_pais_nac;

ALTER TABLE actor DROP COLUMN act_pais_nac;

ALTER TABLE actor ADD act_nacionalidad VARCHAR(40) NOT NULL AFTER act_nombre_real;

ALTER TABLE actor ADD INDEX (act_nacionalidad);

ALTER TABLE elenco RENAME COLUMN ele_papel TO ele_rol;

ALTER TABLE pelicula DROP INDEX pel_clas;