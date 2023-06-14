CREATE DATABASE IF NOT EXISTS registro_cursos_db;

USE registro_cursos_db;

CREATE TABLE IF NOT EXISTS carrera 
(
	car_id INT NOT NULL AUTO_INCREMENT,
    car_ini VARCHAR(100) NOT NULL, 
    car_nombre_com VARCHAR(100) NOT NULL,
    car_campus ENUM('Guanajuato', 'Celaya-Salvatierra', 'Irapuato-Salamanca', 'León'),
    car_division VARCHAR(15),
    car_sede VARCHAR(50),
    INDEX(car_division),
    INDEX(car_division,car_sede),
    PRIMARY KEY(car_id) COMMENT 'Para esta tabla, usé una llave primaria artificial, ya que, a mi parecer es más fácil de relacionarla con las demás tablas, usando IDs, porque es más difícil usar otra variable o conjunto de variables naturales'
    COMMENT 'Esta esuna tabla independiente' 
);

CREATE TABLE IF NOT EXISTS maestro
(
	ma_nua INT NOT NULL AUTO_INCREMENT,
    ma_nombre VARCHAR(50) NOT NULL,
    ma_ap_pat VARCHAR(50) NOT NULL,
    ma_ap_mat VARCHAR(50),
    ma_tit_aca VARCHAR(100),
    ma_nombramiento ENUM('Tiempo Completo','Tiempo Parcial','Asignatura') NOT NULL,
    PRIMARY KEY(ma_nua) COMMENT 'Practicamente en todas las llaves primarias, las escogi artificiales por la misma razon, es mas facil para mi, usar IDs que usar los atributos naturales, me es mas facil relacionar un numero con otro al momento de hacer registros, siendo que tambien, hablamos de la base de datos de una escuela, donde estos registros, o estas llaves artificiales no son validas en ningun otro sistema, pero en el maestro, aproveche que se nos pedia de por si un atributo nua del maestro, que es un numero, para que fuese mi llave primaria',
    INDEX(ma_nombramiento),
    INDEX(ma_tit_aca)
    COMMENT 'Esta esuna tabla independiente' 
);

CREATE TABLE IF NOT EXISTS materia
(
	mat_id INT NOT NULL AUTO_INCREMENT COMMENT 'Esta esuna tabla dependiente',
	mat_car_id INT NOT NULL,
	mat_clave INT NOT NULL,
    mat_nombre VARCHAR(50) NOT NULL,
    mat_creditos INT NOT NULL,
    INDEX(mat_nombre),
    UNIQUE(mat_nombre,mat_car_id),
    PRIMARY KEY (mat_id) COMMENT 'Decidi usar una llave primaria artificial porque no crei apropiado usarla de alguna otra manera, una de mis opciones era tomar la clave foranea de carrera y unirla con la clave de la materia para formar la llave primaria entre los 2 atributos, pero de por si, es mas facil para mi el uso de un solo atributo como llave primaria, por lo que use una llave artificial',
	CONSTRAINT fk_carrera_materia
		FOREIGN KEY(mat_car_id)
        REFERENCES carrera(car_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS curso
(
	cur_id INT NOT NULL AUTO_INCREMENT COMMENT 'Esta esuna tabla independiente',
	cur_mat_id INT NOT NULL,
    cur_ma_nua INT NOT NULL,
    cur_dias_clase ENUM ('Lun-Jue','Mar-Vie','Lun-Mie-Vie','Mie-Sab')NOT NULL,
    cur_horas_clase ENUM('08-10h','10-12h','12-14h','14-16h','16-18h')NOT NULL,
    cur_grupo ENUM('A','B','C','D','E') NOT NULL,
    cur_semestre VARCHAR(6) NOT NULL,
    INDEX(cur_semestre),
    UNIQUE(cur_ma_nua, cur_dias_clase, cur_horas_clase),
    PRIMARY KEY(cur_id) COMMENT 'Se usa una llave artificial, por mera comodidad de manejo',
    CONSTRAINT fk_materia_curso
		FOREIGN KEY(cur_mat_id)
        REFERENCES materia(mat_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_maestro_curso
		FOREIGN KEY(cur_ma_nua)
        REFERENCES maestro(ma_nua)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS estudiante
(
	est_nua INT NOT NULL AUTO_INCREMENT COMMENT 'Esta esuna tabla dependiente',
    est_nombre VARCHAR(50) NOT NULL,
    est_ap_pat VARCHAR(50) NOT NULL,
    est_ap_mat VARCHAR(50),
    est_correo VARCHAR(50) NOT NULL,
    est_pro_gen DEC(2,1) NOT NULL COMMENT 'No tiene que ser digitado automaticamente, es solo un numero',
    est_sem INT NOT NULL COMMENT 'El semestre debe ser digitado con numero como por ejemplo: 1,2,3,4,5,6,7,8,9',
    est_car_id INT,
    PRIMARY KEY(est_nua) COMMENT 'Al igual que con la tabla maestro, aproveche el nua del alumno para la llave primaria',
    UNIQUE(est_correo),
    INDEX(est_nombre,est_ap_pat,est_ap_mat),
    CONSTRAINT fk_carrera_estudiante
		FOREIGN KEY(est_car_id)
        REFERENCES carrera(car_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS registro
(
	reg_cur_id INT NOT NULL COMMENT 'Esta esuna tabla dependiente',
	reg_est_nua INT NOT NULL,
    reg_prom_est DEC(2,1) NOT NULL,
    PRIMARY KEY(reg_cur_id,reg_est_nua) COMMENT 'En este caso no use una llave artificial, decidi aprovechar que se conectaba con 2 tablas por medio de sus respectivas llaves foraneas, por lo que aproveche la combinacion(unica) de estas 2',
    CONSTRAINT fk_estudiante_registro
		FOREIGN KEY(reg_est_nua)
        REFERENCES estudiante(est_nua)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT
		FOREIGN KEY(reg_cur_id)
        REFERENCES curso(cur_id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS avance
(
	ava_est_nua INT NOT NULL COMMENT 'Esta esuna tabla dependiente',
    ava_avance INT NOT NULL COMMENT 'Es el avance en porcentaje que lleva el alumno en la carrera',
    PRIMARY KEY(ava_est_nua, ava_avance) COMMENT 'ESta es la tabla adicional que agregue, donde se registra el avance del alumno en la carrera, asi que solo tiene como llave foranea el nua del alumno, y esa misma la ultilice con el porcentaje de avance, siendo que al combinacion de estas 2 es unica, y asi fromo mi llave primaria de esta tabla',
    CONSTRAINT fk_estudiante_avance
		FOREIGN KEY(ava_est_nua)
        REFERENCES estudiante(est_nua)
);

USE registro_cursos_db;

#2.1 Insert at least 10 records of data in each table.Try to take in consideration the  details  in  the  operations  
#below  to  insert  the  data,  so  that  each  of  the following operations could produce a result(not mandatory).

INSERT INTO carrera(car_ini, car_nombre_com, car_campus, car_division, car_sede)
	  VALUES('LISC','Licenciatura en Ingenieria en Sistemas Computacionales','Irapuato-Salamanca','DICIS','Salamanca'),
			('LICE','Licenciatura en Ingenieria en comunicaciones y electronica','Irapuato-Salamanca','DICIS','Salamanca'),
            ('LIE','Licenciatura en Ingenieria Electrica','Irapuato-Salamanca','DICIS','Salamanca'),
            ('CA','Ciencias Agrarias','Irapuato-Salamanca','DICIVA','Irapuato'),
            ('CB','Ciencias Biologicas','Irapuato-Salamanca','DICIVA','Irapuato'),
            ('IA','Ingenieria Agricola','Irapuato-Salamanca','DICIVA','Irapuato'),
            ('LACP','Licenciatura en Administración de la Calidad y Productividad','Guanajuato','DCEA','Guanajuato'),
            ('LART','Licenciatura en Administración de Recursos Turísticos','Guanajuato','DCEA','Guanajuato'),
            ('LCI','Licenciatura en Comercio Internacional','Guanajuato','DCEA','Guanajuato'),
            ('QFB','Químico Farmacéutico Biólogo','Guanajuato','DCNE','Guanajuato');

INSERT INTO maestro(ma_nombre, ma_ap_pat, ma_ap_mat, ma_tit_aca, ma_nombramiento)
	VALUES('Juan','Hernandez','Mendez','Ingeniero en Sistemas Computacionales','Tiempo completo'),
			('Jair','Melendez','Fernandez','Ingeniero Electrico','Tiempo completo'),
            ('Daniel','Juarez','Mendez','Ingeniero Minero(?)','Tiempo completo'),
            ('Hugo','Gonzalez','Huerta','Ingeniero Mecanico','Tiempo completo'),
            ('Diego','Perez','Primo','Ingeniero Mecatronico','Tiempo completo'),
            ('Saul','Islas','Sierra','Licenciado en Derecho','Tiempo Parcial'),
            ('Ximena','Juarez','Chavez','Matematica','Asignatura'),
            ('Laura','Vazquez','Perez','Ingeniera Bioquimica','Tiempo completo'),
            ('Pamela','Sanchez','Cabrera','Quimica','Tiempo completo'),
            ('Raul','Prado','Jimenez','Fisico Matematico','Tiempo completo');

INSERT INTO materia(mat_car_id, mat_clave, mat_nombre, mat_creditos)
	VALUES('1','12345','Calculo Integral','4'),
			('2','12346','Matematicas Discretas','3'),
            ('3','12347','Espiritu Emprendedor','3'),
            ('4','12348','Introduccion a la vida universitaria','1'),
            ('5','12349','Calculo Diferencial','3'),
            ('6','12350','Algebra Lineal','4'),
            ('7','12351','Electronica Analogica','5'),
            ('8','12352','Desarrollo Humano','4'),
            ('9','12353','Ecuaciones Diferenciales','4'),
            ('10','12354','Calculo Vectorial','4');

INSERT INTO curso(cur_mat_id, cur_ma_nua, cur_dias_clase, cur_horas_clase, cur_grupo, cur_semestre)
	VALUES('1','3','Mie-Sab','08-10h','A','2021AD'),
			('2','2','Lun-Jue','10-12h','B','2022EJ'),
            ('3','1','Mar-Vie','12-14h','C','2022AD'),
            ('4','6','Lun-Mie-Vie','14-16h','D','2023EJ'),
            ('5','5','Lun-Jue','16-18h','E','2023AD'),
            ('6','4','Lun-Jue','08-10h','A','2024EJ'),
            ('7','9','Mar-Vie','10-12h','B','2024AD'),
            ('8','8','Lun-Mie-Vie','12-14h','C','2025EJ'),
            ('9','7','Mie-Sab','14-16h','D','2025AD'),
            ('10','10','Lun-Jue','16-18h','E','2026EJ');

INSERT INTO estudiante(est_nombre, est_ap_pat, est_ap_mat, est_correo, est_pro_gen, est_sem, est_car_id)
	VALUES('Jair','Chavez','Islas','j.chavezislas@ugto.mx','8.5','4','1'),
			('Jair','Chavez','Islas','j.chavsezislas@ugto.mx','6.5','4','1'),
			('Diego','Perez','Perez','diegoperezwdsds@hotmail.com','7.5','6','1'),
			('Diego','Perez','Perez','diegoperez@hotmail.com','8.5','6','2'),
            ('Juan','Aguilera','Huerta','JAG@ugto.mx','9.6','2','3'),
            ('Betsabe','Valdez','Cabrera','bvc@ugto.mx','7','5','4'),
            ('Dan','Chavez','Islas','DCI@ugto.mx','9.4','6','5'),
            ('Arturo','Garcia','Conejo','AGC@ugto.mx','5.6','7','6'),
            ('Antonio','Martinez','Delgado','AMD@ugto.mx','8.5','2','7'),
            ('Julieta','Ramirez','Jimenez','JRJ@ugto.mx','9.9','5','8'),
            ('Paola','Castillo','Chavez','PCC@ugto.mx','7.7','2','9'),
            ('Jose','Perez','Perez','JPP@ugto.mx','6.5','5','10');

INSERT INTO registro(reg_cur_id, reg_est_nua, reg_prom_est)
	VALUES('1','10','9.5'),
			('2','9','8.3'),
            ('3','8','7.5'),
            ('4','7','4.3'),
            ('5','6','7.7'),
            ('6','5','8.5'),
            ('7','4','5.8'),
            ('8','3','9.9'),
            ('9','2','8.4'),
            ('10','1','7.9');
            
INSERT INTO avance(ava_est_nua, ava_avance)
	VALUES('1','45'),
			('2','54'),
            ('3','66'),
            ('4','23'),
            ('5','56'),
            ('6','86'),
            ('7','99'),
            ('8','23'),
            ('9','12'),
            ('10','57');
            
USE registro_cursos_db;

#2.2 Delete students from ingeniería electronica(LICE),that are insemesters 3, 2 
#or between6 and 8, whose promediogeneralisbetween 3 and 5 or between 6 and 7, 
#whose nombrecontainsthe string ‘li’ or the string‘an’, and whose apellido 
#paterno and apellido materno eds with ‘ez’(in case of a real effect in the 
#data, after the operationinsert again the deletedrecords).
DELETE FROM estudiante
	WHERE est_car_id = '2'
    AND((est_sem BETWEEN '6' AND '8') OR est_sem = '2' OR est_sem = '3' )
    AND((est_pro_gen BETWEEN '3' AND '5' ) OR (est_pro_gen BETWEEN '6' AND '7'))
    AND est_nombre LIKE '%li%' OR est_nombre LIKE '%an%'
    AND (est_ap_pat LIKE 'ez%' AND est_ap_mat LIKE 'ez%');

#2.3 Change  the  semester  adding  +1  for  students  of ingeniería en  sistemas 
#computacionales(LISC)  that  are  in semesters  1  or  3,  or  between  5  
#and  7, whose promediogeneralis greater than 9 or between 10 and 12, and whose 
#apellido  paternocontains the string ‘na’ or apellido  maternocontains  
#the string ‘tr’(in case of a real effect in the data, after the operation change 
#back to the original values).
UPDATE estudiante
	SET est_sem = est_sem + 1
    WHERE est_car_id = 1
	AND((est_sem BETWEEN '1' AND '3') OR (est_sem BETWEEN '5' AND '7'))
    AND ((est_pro_gen > 9) OR est_pro_gen BETWEEN '10' AND '12')
    AND est_ap_pat LIKE '%na%' OR est_ap_mat LIKE '%tr%';
    
#2.4 Return  all  the  attributes  from estudiantesof  a  given carrerausing  
#the complete name of the carrera(define the name by yourself), 
#but only those whose correoends with ‘ugto.mx’.
SELECT estudiante.*
	FROM estudiante, carrera
    WHERE estudiante.est_car_id = car_id
		AND car_nombre_com = 'Licenciatura en Ingenieria en Sistemas Computacionales'
		AND est_correo LIKE '%ugto.mx';

#2.5 Return the semester, the number of estudiantesin each semester, and the minimum, the maximum,and the 
#average of promedio generalper semester. Return only the semestreswith more than 3estudiantes. Sort the 
#result in descending order according to the number of estudiantesin each semestre.    
SELECT est_nua, est_sem, est_pro_gen, 
	COUNT(est_sem) AS 'numerodeestudiantesporsemestre',
	AVG(est_pro_gen) AS promedioporsemestre,
	MAX(est_pro_gen) AS maximoporsemestre,
	MIN(est_pro_gen) AS minimoporsemestre
	FROM estudiante
    GROUP BY(est_sem)
    ORDER BY numerodeestudiantesporsemestre DESC;

#2.6 Return the inicialesand the nombre completoof each 
#carrera, the number of estudiantesin  each carrera,  
#and  the  minimum,  the  maximum,  and  the average of 
#promedio generalper carrera.Sort the results in ascending 
#order per average of promedio general.
SELECT COUNT(est_car_id) AS numerodeestudiantesporcarrera, 
	car_ini, car_nombre_com, est_pro_gen,
    AVG(est_pro_gen) AS promedioporcarrera,
	MAX(est_pro_gen) AS maximoporcarrera,
	MIN(est_pro_gen) AS minimoporcarrera
	FROM carrera, estudiante
    WHERE est_car_id = car_id
    GROUP BY est_car_id
    ORDER BY promedioporcarrera DESC;

#2.7 Return the divisiónand sedeand the number of carrerasin 
#each combination of these attributes. Return only the división, 
#sedewith more than 5 carreras.Sort the results in descending 
#order by number of carreras.
SELECT CONCAT(car_division, ' - ', car_sede) AS sededivision,
	COUNT(car_ini) AS numerodecarreraspordivision
	FROM carrera
    GROUP BY(sededivision)
    HAVING numerodecarreraspordivision > 5
    ORDER BY numerodecarreraspordivision DESC;
    
#2.8 Return the nombreand créditosof each materiaand all 
#the attributesfor the cursoseach materiahas.
SELECT mat_nombre, mat_creditos, curso.*
	FROM materia, curso
    WHERE cur_mat_id = mat_id;

#2.9 Return  the inicialesand nombre  completoof  
#each carreraand  all  the attributesfor the cursoseach carrerahas.
SELECT car_nombre_com, car_ini, curso.*
	FROM carrera, curso, materia
	WHERE cur_mat_id = mat_id AND car_id = mat_car_id; 

#2.10 Return the nombreof the materia, the  concatenation  of  (nombre, apellido paterno, apellido materno)
#of the maestro, the días de la semanaand horas de la semanafor each curso, and the nuaand the concatenation 
#of(nombre, apellido paterno, apellido materno)for all the estudiantesin each curso.
SELECT mat_nombre, cur_dias_clase, cur_horas_clase, est_nua,
	CONCAT(est_nombre, ' - ', est_ap_pat, ' - ', est_ap_mat) AS nombrecompletodelalumno,
	CONCAT(ma_nombre, ' - ', ma_ap_pat, ' - ', ma_ap_mat) AS nombrecompletodelmaestro
	FROM materia, maestro, estudiante, curso, registro
    WHERE cur_ma_nua = ma_nua AND cur_mat_id = mat_id AND reg_est_nua = est_nua AND reg_cur_id = cur_id
    GROUP BY mat_nombre
    ORDER BY est_nua;

#2.11 Return the nueand the concatenation of (nombre, apellido paterno, apellido materno) for each maestro, 
#the nombre of the materia,and the nua, and the concatenation  of  (nombre, apellido  paterno, apellido  materno)  
#for  the estudiantestaking a cursowith each maestro.
SELECT ma_nua,
	CONCAT(ma_nombre, ' - ', ma_ap_pat, ' - ', ma_ap_mat) AS nombrecompletodelmaestro,
    mat_nombre, est_nua,
    CONCAT(est_nombre, ' - ', est_ap_pat, ' - ', est_ap_mat) AS nombrecompletodelalumno
	FROM estudiante, maestro, materia, registro, curso
	WHERE reg_est_nua = est_nua AND cur_ma_nua = ma_nua AND cur_mat_id = mat_id AND reg_cur_id = cur_id
    GROUP BY cur_id
    ORDER BY mat_id;
    
#2.12 Return the división, and the number of estudiantesregistered in cursosfor each división.
SELECT car_division,
	COUNT(est_nua) AS numero_de_estudiantes_inscritos
	FROM carrera, estudiante, curso, registro
	WHERE reg_cur_id = cur_id AND reg_est_nua = est_nua AND est_car_id = car_id
    GROUP BY car_division
    ORDER BY numero_de_estudiantes_inscritos DESC;
    
#2.13 Return the inicialesand nombre completoof each carrera, and the nue and the 
#concatenation of (nombre, apellido paterno, apellido materno) for each 
#maestroteaching in the carrera, and the nombreof the materiaseach one is teaching.
SELECT car_ini, car_nombre_com, ma_nua, mat_nombre,
	CONCAT(ma_nombre, ' - ', ma_ap_pat, ' - ', ma_ap_mat) AS nombrecompletodelmaestro
	FROM maestro, curso, materia, carrera
    WHERE cur_ma_nua = ma_nua AND cur_mat_id = mat_id AND mat_car_id = car_id 
    GROUP BY car_id;

#2.14 Return  all  the  attributes for  each carreraand  all  the attributesfor  
#the estudianteswith  the  highest promediogeneraland  the  lowest promediogeneralfor each carrera.
SELECT carrera.*, estudiante.*
    FROM carrera
    INNER JOIN estudiante
		ON est_car_id = car_id
	INNER JOIN
		(
			SELECT est_car_id, 
				MAX(est_pro_gen) AS maximopromedio, 
				MIN(est_pro_gen) AS minimopromedio
					FROM estudiante
					GROUP BY est_car_id
        ) AS promedio
		ON car_id = promedio.est_car_id 
        AND ((est_pro_gen = promedio.maximopromedio) OR est_pro_gen = promedio.minimopromedio)
        ORDER BY car_id;

#2.15 Return all the data for each cursoand the nua, the concatenation of 
#(nombre, apellido paterno, apellido materno) and the nombre completoof 
#thecarrerafor  the estudianteswith  the  highest promediogeneraland  the  lowest promediogeneralfor each curso.

SELECT curso.*, estudiante.est_nua, 
	CONCAT(est_nombre,' ', est_ap_pat,' ',est_ap_mat) AS nombrecompletodelestudiante,
	reg_prom_est AS promedio, carrera.car_nombre_com
	FROM curso
    INNER JOIN registro 
		ON reg_cur_id = cur_id
	INNER JOIN estudiante
		ON reg_est_nua = est_nua
	INNER JOIN carrera 
		ON est_car_id = car_id
	INNER JOIN
		(
			SELECT est_car_id, 
				MAX(est_pro_gen) AS maximopromedio, 
				MIN(est_pro_gen) AS minimopromedio
					FROM estudiante
					GROUP BY est_car_id
        ) AS promedio
		ON car_id = promedio.est_car_id 
        AND ((est_pro_gen = promedio.maximopromedio) OR est_pro_gen = promedio.minimopromedio)
		ORDER BY cur_id;
