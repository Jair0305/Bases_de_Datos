CREATE DATABASE IF NOT EXISTS dieta_db;

USE dieta_db;

CREATE TABLE IF NOT EXISTS paciente
(
	pac_id INT NOT NULL AUTO_INCREMENT,
	pac_nombre VARCHAR(50) NOT NULL,
    pac_edad INT NOT NULL,
    pac_estatura INT NOT NULL COMMENT 'En metros',
    pac_peso INT NOT NULL COMMENT 'En kg',
    pac_correo VARCHAR(50) NOT NULL,
    UNIQUE(pac_correo),
    INDEX(pac_nombre),
    PRIMARY KEY(pac_id)
);

CREATE TABLE IF NOT EXISTS alimento
(
	ali_id INT NOT NULL AUTO_INCREMENT,
	ali_nombre VARCHAR(50) NOT NULL,
    ali_medida_porcion TINYTEXT NOT NULL,
    ali_tipo ENUM('frutas','verduras','carnes y proteínas','lácteos','granos y cereales','aceites y grasas') NOT NULL,
    ali_calorias_porcion INT NOT NULL COMMENT 'kilocalorias',
    INDEX(ali_nombre),
    UNIQUE(ali_nombre, ali_tipo),
    PRIMARY KEY(ali_id)
);

CREATE TABLE IF NOT EXISTS dieta
(
	die_id INT NOT NULL AUTO_INCREMENT,
    die_pac_id INT NOT NULL,
	die_fecha_inicio DATE NOT NULL,
    die_fecha_fin DATE NOT NULL,
    INDEX(die_fecha_inicio),
    CONSTRAINT pk_paciente_dieta
		FOREIGN KEY (die_pac_id)
        REFERENCES paciente(pac_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	PRIMARY KEY(die_id)
);

CREATE TABLE IF NOT EXISTS detalle
(
#	det_pac_id INT NOT NULL,
    det_ali_id INT NOT NULL,
    det_die_id INT NOT NULL,
	det_tipo_comida ENUM('desayuno','comida','cena','colación'),
    INDEX(det_tipo_comida),
    PRIMARY KEY(det_ali_id, det_die_id),
#    CONSTRAINT fk_paciente_detalle
#		FOREIGN KEY(det_pac_id)
#		REFERENCES paciente(pac_id)
#		ON DELETE CASCADE
#       ON UPDATE CASCADE,
	CONSTRAINT fk_alimento_detalle
		FOREIGN KEY(det_ali_id)
        REFERENCES alimento(ali_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
	CONSTRAINT fk_dieta_detalle
		FOREIGN KEY(det_die_id)
        REFERENCES dieta(die_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

USE dieta_db;

INSERT INTO paciente(pac_nombre, pac_edad, pac_peso, pac_estatura, pac_correo)
	VALUES('Jair Chavez Islas','19', '70', '1.70','jci@ugto.mx'),
			('Juan Aguilera Huerta','20','80','1.82','jah@ugto.mx'),
            ('Diego Perez Perez','19','85','1.85','dpp@ugto.mx');
            
INSERT INTO alimento(ali_nombre,ali_medida_porcion,ali_tipo,ali_calorias_porcion)
	VALUES('Bistek','200 gramos','carnes y proteínas','200'),
			('Manzana','2 piezas','frutas','200'),
            ('Zanahoria','3 piezas','verduras','100'),
            ('Milanesa de pollo','400 grmaos','carnes y proteínas','400');
            
INSERT INTO dieta (die_fecha_inicio,die_fecha_fin,die_pac_id)
	VALUES('2022-04-03','2022-05-03',1),
			('2022-05-03','2022-06-03',2),
            ('2022-05-05','2022-06-05',3);
            
INSERT INTO detalle(det_ali_id, det_die_id,det_tipo_comida)
	VALUES(1,2,'comida'),
			('2','3','colación');
            
UPDATE dieta
	SET die_fecha_inicio = ADDDATE(die_fecha_inicio, 14);
UPDATE dieta
    SET die_fecha_fin = ADDDATE(die_fecha_fin, 14);
    
UPDATE alimento
	SET ali_calorias_porcion =ali_calorias_porcion + 100
    WHERE (ali_tipo IN ('lácteos','carnes y proteínas'))
    AND (ali_calorias_porcion BETWEEN '200' AND '300')
    AND ali_nombre LIKE '@asada';

UPDATE paciente
	SET pac_peso = pac_peso-1
    WHERE (pac_estatura IN (1.75,1.80,1.78))
    AND (pac_edad IN(22,24) OR pac_edad BETWEEN '26' AND '30')
    AND (pac_nombre LIKE '@ez' OR pac_nombre LIKE '@is');
    
DELETE FROM alimento
	WHERE (ali_tipo IN ('verduras','granos y cereales'))
    AND (ali_calorias_porcion BETWEEN '100' AND '200')
    AND (ali_medida_porcion LIKE '@taza@' OR ali_medida_porcion LIKE '@cucharada@');
    
DELETE FROM paciente
	WHERE (pac_nombre LIKE '@Juan@')
    AND (pac_peso BETWEEN '80' AND '90')
    AND (pac_altura BETWEEN '1.70' AND '1.80')
    AND (pac_correo LIKE '@gmail.com');
    
SELECT *
	FROM dieta
    WHERE die_fecha_inicio = '2022-04-__'
    AND die_fecha_fin = '2022-06-__';
    
SELECT *
	FROM paciente
    WHERE (pac_peso IN('70','80','90'))
    AND (pac_estatura BETWEEN '1.70' AND '1.80')
    AND (pac_nombre LIKE '@Luis@' AND pac_nombre LIKE '@io');
    
SELECT *
	FROM alimento
    WHERE (ali_medida_porcion LIKE '@pieza@')
    AND (ali_tipo IN ('granos y cereales','frutas'))
    AND (ali_calorias_porcion BETWEEN '200' AND '300');
    
SELECT CONCAT pac_nombre, pac_correo
	FROM paciente
    