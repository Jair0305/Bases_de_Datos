# Crear la base de datos
CREATE DATABASE IF NOT EXISTS agenda_db;

#Abrir la base de datos para modificarla (poner cosas dentro de ella)
USE agenda_db;

#analisis
#super llaves para la tabla contacto
#telefono,correo, [nombre,telefono], [nombre,correo],[telefono,direccion],[telefono,correo]
#[direccion,telefono,correo],[nombre,telefono,correo]

#llaves candidatas
#

# Crear la tabla de contacto
CREATE TABLE IF NOT EXISTS contacto
(
	con_id INT NOT NULL AUTO_INCREMENT,
	con_nombre VARCHAR(50) NOT NULL,
	con_direccion VARCHAR(100) NOT NULL,
	con_telefono VARCHAR(10),
	con_correo VARCHAR(30),
    PRIMARY KEY (con_id), # indica la llave primaria
    INDEX (con_correo), # esto genera un indici para un atributo (o atributos)
    INDEX (con_nombre), #genera un indice para el nombre
					#Se indexa el aatributo que se puedan utilizar de manera frecuente de busqueda
	UNIQUE (con_telefono)
	
);
#por definicion unique tambien es un indice y es unico
#unique es muy parecido a una llave priamria, pero soloo puede ahber una llave primaria por tabla
#unique acepta valores nulos

#hay que tenre cuidado con los indicies, porque ocupan espacio adicional

#Una llave priamria por definicion, tambien es un indice que es unico

#De manera general vamos a preferir las llaves artificiales sobre las naturales, a menos que haya una buena razon para usar una llave natural

#vamos a utilizar tipos enteros para las llaves artificiales

#vamos a utilizar(generalmente) la propiedad de autoincremento

#las llaves artificales son mmenos propenasas al cambio(son mas estabels a lo largo del tiempo)

#es importante hacer un analisis previo para determinar si la llave primaria debe ser artificial o natural

#un caso de uso aprticular para las llaves naturales es cuando la cantidad de informacion es poca

#la tabla cita es la tabla dependiente ya que tiene una llave foranea que viene de la tabla contacto, asi como la tabala contacto, no es una tabla dependiente, ya que no tiene
#llaves foraneas
CREATE TABLE IF NOT EXISTS cita
(
	cit_id INT NOT NULL AUTO_INCREMENT,
	cit_fecha DATE NOT NULL,
	cit_hora TIME NOT NULL,
	cit_lugar VARCHAR(100),
	cit_con_id INT,
    PRIMARY KEY (cit_id), #la llave priamrai consta de 2 atributos
    INDEX (cit_lugar), #genera un indice para el lugar
    INDEX (cit_fecha),
    UNIQUE (cit_fecha, cit_hora),#unique combinado
    CONSTRAINT fk_contacto
		FOREIGN KEY (cit_con_id)
        REFERENCES contacto (con_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);

#DDL(data definition language)
# INstrucciones para modificar la estructura (esquema) de la base de datos

#ALTER TABLE contacto RENAME amigo; #Cambia el nombre de la tabla contacto por amigo
#ALTER TABLE contacto DROP COLUMN con_direccion # Elimina una columna
#AlTER TABLE contacto DROP COLUMN con_telefono, DROP COLUMN con_correo......; ##Elimina varias columnas
#Para poder eliminar una llave primaria, deberemos asegurarnos que la llave primaria no sea autoincrement y que no sirva de referencia a una llave foranea
#ALTER TABLE contacto DROP PRIMARY KEY; #Elimina la llave primaria
#ALTER TABLE cita ADD PRIMARY KEY(cit_id); #agrega una llave primaria

#ALTER TABLE contacto_ ADD con_direccion VARCHAR(100); #agrega una columna al final de la tabla
#ALTER TABLE contacto ADD con_correo VARCHAR(30) AFTER con_nombre; #agrega una columna despues de otra especifica
#ALTER TABLE contacto ADD con_correo VARCHAR(30) FIRST; #agrega una columna al principio de la tabla
#ALTER TABLE ADD INDEX (con_correo); #Agregar un indice con la columna con_correo
#ALTER TABLE ADD UNIQUE (con_correo) #agrega la condicion de unicidad
#ALTER TABLE contacto DROP INDEX con_correo; #elimina el indice con el nombre con_correo

#ALTER TABLE contacto CHANGE con_correo con_cor_electronico VARCHAR(40); #Renombra la columna y cambia su tipo
#ALTER TABLE contacto MODIFY con_cor_electronico VARCHAR(35); #Cambia el tipo de dato de la columna


#para poder eliminar una tabla hayq ue eliminar las referencias entre tablas a traves de las llaves foraneas
#DROP TABLE contacto;
#DROP TABLE IF EXISTS contacto, cita; #asi se peude eliminar mas de una tabla

##hasta aqui hemos trabajado con el ddl
#=======================================================================================================================================================================
#=======================================================================================================================================================================
# Ahora comenzaremos a trabajar con el dml, esto se usa para manipular (gestionar) los datos dentro d ela esctructura
# en e dml hay cuatro operaciones: Create, Read, update, delete = CRUD
#Create = INSERT
#Read = SELECT
#Update = UPDATE
#Delete = DELETE

# =========================== INSERT
#inserta datos en una tabla, primero debemos insertar datos en las tablas independientes (que no tengan llaves foraneas)
#en este caso deberiamos empezar a insertar datos en a tabla contacto

INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES ('Raul Uriel', 'Yeso 224', '4771234567', 'ru.s@ugto.mx');
INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES ('Maria del rosario', 'Yeso 224', '4771235667', 'mr.s@ugto.mx');

#insertar varios valores
INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES ('Maria del rosario', 'Yeso 224', '4771235607', 'mr.s@ugto.mx'),
			('Maria del rosario', 'Yeso 224', '4771539667', 'mr.s@ugto.mx'),
            ('Maria del rosario', 'Yeso 224', '4771635667', 'mr.s@ugto.mx'),
            ('Maria del rosario', 'Yeso 224', '4771735667', 'mr.s@ugto.mx'),
            ('Maria del rosario', 'Yeso 224', '4771835667', 'mr.s@ugto.mx'),
            ('Maria del si', 'si', '4771106667', 'si.s@ugto.mx'),
            ('Maria del rosario', 'Yeso 224', '4771935667', 'mr.s@ugto.mx');
            
#los valores que se insertan deben estar en orden (correspondencia) con respecto a la columnas indicadas.
# (En principio) no se pueden insertar valores de un tipo en una columna de otro tipo
#No s epuede insertar un valor en una columna AUTO_INCREMENT
#Si no se inidica el nombre de una columna, se inserta un valor NULL (o el valor por DEFAULT)
#si no se indica el nomb re de una columna, pero no acepta valores NULL, se arroja un error

#insertar datos en la tabla cital

INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES('2022-03-21', '10:00:00', 'pq', NULL);
    
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
		VALUES('2022-05-21', '10:00:00', 'pq', 1),
        ('2023-03-21', '10:00:00', 'pq', 2),
        ('2024-03-21', '10:00:00', 'pq', 2),
        ('2025-03-21', '10:00:00', 'pq', 21),
         ('2026-03-21', '10:00:00', 'pq', 21),
         ('2027-03-21', '10:00:00', 'pq', 21),
         ('2028-03-21', '10:00:00', 'pq', 1),
         ('2029-03-21', '10:00:00', 'pq', 2);


    # =============================================DELETE
    
#eliminar fatois de una tabla
#deberiamos eliminar primero los tatos de tablas dependientes
#considerar el efecto de la propiedad ya usada en la tabla ""ON DELETE"
#Intentar eliminar un contacto qeu tenga registros en la tabla cita
#probar la restriccion de la propiedad on delete restrict

#DELETE FROM contacto
#	WHERE con_id = 1;
    
#primero se elimina el registro de la tabla cita

DELETE FROM cita
	WHERE cit_con_id = 1;
    #ahora si podemos eliminar al contacto
    
DELETE FROM contacto
	WHERE con_id = 1;
    
DELETE FROM cita
	WHERE cit_fecha = '2022-12-23'
		AND cit_hora = '17:23:23';
#dos condicionales para borrar un registro

DELETE FROM cita
	WHERE cit_fecha BETWEEN '2002-04-01' AND '2022-04-30';
    #Borra todas las citas agendadas entre esas 2 fechas


#eliminar datos en la tabla contacto
DELETE FROM contacto
	WHERE con_nombre LIKE '%ez' #Elimina todos los contactos que terminen un ez en su nombre


