#Crear la base de datos
CREATE DATABASE IF NOT EXISTS agenda_db;

#Abrir la base de datos para modificarla
USE agenda_db;

#Por cuestiones de control y estabilidad 
#vamos a utilizar tipos enteros para llaves artificiales
#vamos a utilizar (generalmente el auntoincremento) 
#El autoincremento define un contador a un valor base 0 y lo incrementa de forma automatica
CREATE TABLE IF NOT EXISTS contacto(
	con_id INT NOT NULL AUTO_INCREMENT,
	con_nombre VARCHAR(50) NOT NULL,
    con_direccion VARCHAR(100) NOT NULL,
    con_telefono VARCHAR(10),
    con_correo VARCHAR(30),
    PRIMARY KEY (con_id), #llave primaria
    INDEX (con_correo), #llave alterna se usa como indice
						#indice ayuda a agilizar la busqueda
	INDEX (con_nombre), #indice de nombre se indexa los que se ´puedan usar de forma fecuente
    UNIQUE (con_telefono) #UNIQUE define que un atributo sea unico es decir que no haya valores repetidos
);
#un atributo UNIQUE por definicion tambien es un indice (que ademas es unico)
##unique (con_telefono) tambien incluye INDEX(con_telefono)
#UNIQUE es muy similar a una llave primaria pero solo hay una llave primaria por tabla
#UNIQUE acepta valores nulos

#super llaves tabla cita
# [fecha, hora], [fecha, hora, lugar]

#llaves candidatas
#[fecha, hora]

#llave primaria
#[fecha, hora]

#Llaves alternas


CREATE TABLE IF NOT EXISTS cita(
	cit_id INT NOT NULL AUTO_INCREMENT,
    cit_fecha DATE NOT NULL,
    cit_hora TIME NOT NULL,
    cit_lugar VARCHAR(100),
    cit_con_id INT,
    PRIMARY KEY (cit_id),
    INDEX (cit_lugar),
    INDEX (cit_fecha),
    UNIQUE(cit_fecha, cit_hora),#UNIQUE combinado
    CONSTRAINT fk_contacto
		FOREIGN KEY (cit_con_id)
        REFERENCES contacto (con_id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
);

#DOL (data definition language)
# Instrucciones para modificar estructura (esquema) de las bases de datos
USE agenda_db; #Abre base de datos para hacer cambios en ella
ALTER TABLE contacto RENAME amigo; #Cambia en nombre de la tabla contacto por amigo
ALTER TABLE amigo RENAME contacto; #Cambia en nombre de la tabla amigo por contacto
ALTER TABLE contacto DROP COLUMN con_direccion; #Elimina una columna (con_direccion) 
ALTER TABLE contacto DROP COLUMN con_telefono, DROP COLUMN con_correo; #Elimina varias columna
#antes de hacer lo siguiente asegurese que las llaves primarias no sean AUTO_INCREMENT
#y que nos sirva de referencia a una llave foranea
#En este caso se altera la propiedad AUTO_INCREMENT de la tabla cita,
#se borra el esquema y se crea de nuevo antes de ejecutar la eliminacion de la llave primaria
ALTER TABLE cita DROP PRIMARY KEY; #Elimina la llave primaria
ALTER TABLE cita ADD PRIMARY KEY (cit_id); #agrega (crea) la llave primaria
#se regresa la propiedad AUTO_INCREMENT a la tabla cita
#se borra el esquema y se crea uno nuevo

ALTER TABLE contacto ADD con_direccion VARCHAR(100); #agrega una columna al final de la tabla
ALTER TABLE contacto ADD con_correo VARCHAR(100) AFTER con_nombre;  #agrega una columna despues de otra
ALTER TABLE contacto ADD con_ciudad VARCHAR(30) FIRST;#agrega una columna al inicio de la tabla
ALTER TABLE contacto ADD INDEX (con_correo);#agrega un indice con la columna (y nombre) con_correo
ALTER TABLE contacto ADD UNIQUE (con_correo); #agrega condicion de unicidad
ALTER TABLE contacto DROP INDEX con_correo;#agrega un indice con la columna (y nombre) con_correo

ALTER TABLE contacto CHANGE con_correo con_cor_electronico VARCHAR(40); #Renombrar la colunmana y cambiar su tipo
ALTER TABLE contacto MODIFY con_cor_electronico VARCHAR(35); #cambia el tipo de dato de la columna 

DROP TABLE contacto; 
# No se puede borrar la tabla contacto porque hay una refererencia entre tablas
# a traves de la llave foranea primero hay que eliminar la llave foranea 
ALTER TABLE cita DROP FOREIGN KEY fk_contacto;
# SEGUNDO PODEMOS BBORRAR LA TABLA CONTACTO
DROP TABLE contacto;
DROP TABLE IF EXISTS contacto; #Elimina la tabla si existe
DROP TABLE IF EXISTS contacto, cita; #elimina varias tablas si existen 

#hasta aqui hemos trabajado con el DDL (Data Definition Languaje): lo usamaos para
# manipular (gestionar) los datos dentro de la estructura.
# En el DML hay cuatro operaciones: Create, Read, Update, Delete --> CRUD
#Create --> INSERT
#Read --> SELECT
#Update--> UPDATE
#Delete --> DELETE

# +++++++++++++++++++++++++++ INSERT
#inserta (agrega) datos en una tabla 
#debemos primero insertar datos en las tablas independientes (que no tengas llaves foraneas)
#empezamos con la tabla contacto 

INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES('Raul uriel', 'Yeso 224', '4771234534', 'ru.s@ugto.mx');
INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES('Maria Del Rosario', 'Yeso 224', '4771234554', 'mr.s@ugto.mx');
    
#insertar varios contactos al mismo tiempo 
INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES('Uriel Zair', 'Nose 22', '4771534534', 'uz.zair@ugto.mx'),   
		('Emilio martinez', 'Por la ug', '4771234538', 'e.martinez@ugto.mx'),  
		('Helio rafael', 'Manzanares', '4771234578', 'h.rafa3l@ugto.mx'),
        ('Paola aguerrin Melendez', 'Brisas del carmen', '4771234678', 'p.aguerrin@ugto.mx'),
        ('Aldo Isac Fernandez', 'irapuato centro', '4791234578', 'ai.hernandez@ugto.mx'),
        ('HeClaudia Paola Valenzuela', 'Centro', '4792234578', 'cp.valenzuela@ugto.mx');

INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES('Jorge Gonzales Gutierrez', 'Juarez 34', '4647854236', 'jgg@ugto.mx');

#Los valores que se insertan deben de estar en orden (correspondencia) con respecto a las columnas indicadas
#(En principio) no se puede insertar valores de un tipo en una columna de otro tipo
#No se puede insertar un valor en un atributo AUTO_INCREMENT
#Si no se indica el nombre de una columna se inserta un valor NULL (o el valor por default)
INSERT INTO contacto (con_nombre, con_direccion, con_telefono)
	VALUES('Juan Escutia', 'Morelos 27 centro', '4647894236');
#Si no se indica el nombre de la columna, pero no acepta valores null se arroja un error

INSERT INTO contacto (con_nombre)
	VALUES('Juan Escutia'); #-->Error
    
    
#insertar en la tabla cita
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2022-03-21', '10:00:00', 'Altacia', NULL);
    
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2022-04-21', '10:00:00', 'Altacia', 1),
			('2022-04-17', '11:00:00', 'Altacia', 2),
            ('2022-04-24', '10:00:00', 'Centro', 2),
            ('2022-05-01', '12:00:00', 'Via Alta', 2),
            ('2022-05-03', '10:00:00', 'Centro', 3),
            ('2022-05-03', '19:00:00', 'Centro', 5),
            ('2022-03-10', '19:00:00', 'Via Alta', 8),
			('2022-05-23', '12:00:00', 'Centro', 7),
            ('2022-05-23', '17:00:00', 'Centro', 3),
            ('2022-04-25', '16:30:00', 'Via Alta', 4),
            ('2022-04-30', '14:45:00', 'Via Alta', 5),
            ('2022-03-02', '10:00:00', 'Centro', 1);

#intentar insertar una cita para un contacto que no existe
#Probar la restriccion de la llave foranea
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2022-03-21', '11:00:00', 'Altacia', 15); #---> Error de referencia elñ contacto no existe 
    
#Intentar insertar una cita en la misma fecha y hora
#Probar la restriccion de unicidad
INSERT INTO cita (cit_fecha, cit_hora, cit_lugar, cit_con_id)
	VALUES ('2022-04-17', '11:00:00', 'Via Alta', 1); #---> Error fecha y hora repetidas

#intentar insertar un contacto con el mismo telefono
INSERT INTO contacto (con_nombre, con_direccion, con_telefono, con_correo)
	VALUES('Khatia Martinez Lopez', 'Antares 16', '4647894236', 'kml@ugto.mx');
    #--> Error el telefono esta repetido.

#+++++++++++++++++++++++++++ DELETE 
#Eliminar (borrar) datos (registros) de una tabla
#Deberiamos primero eliminar datos de las tablas dependientes (que tenga llaves foraneas)
#Considerar el efecto de la propiedad DELETE
# ------ Eliminar datos en la tabla contacto
#intentar eliminar un contacto que tenga registros en la tabla cita.
#Probar la restriccion de la propiedad ON DELETE RESTRICT
DELETE FROM contacto
	WHERE con_id = 1; #elimina la tabla contacto con el id = 1
						#-->error el contacto tiene registros en la tabla cita

#Primero hay que eliminar los registros de la tabla cita referentes al contacto deseado
 DELETE FROM cita
	WHERE cit_con_id = 1; #Elimina los registros del contacto 1 de la tabla cita
#Segundo ahora si podemos eliminar el contacto deseado
DELETE FROM contacto
	WHERE con_id = 1;  #elimina la tabla contacto con el id = 1

#Si hubieramos utilizadom la opcion ON DELETE CASCADE  al borrar al usuario con id = 1 todos
#los registros de la tabla cita asociados con ese id hubieran sido eliminados 

DELETE FROM cita
	WHERE cit_fecha = '2022-05-03'; #Elimina todas las citas de una fecha especifica

DELETE FROM cita
	WHERE cit_fecha = '2022-05-23' AND cit_hora = '17:00:00'; #Elimina las citas en una fecha y hora especifica
    
DELETE FROM cita
	WHERE cit_fecha BETWEEN '2022-04-01' AND '2022-04-30'; #Elimina las citas en un intervalo de fechas
							#Valor inicial      valor final -->incluidos esos dias

# ---------- Eliminar datos en la tabla contacto
DELETE FROM contacto
	WHERE con_nombre LIKE '%ez'; #Elimina los contactos que terminen en ez su nombre

#Sin la restriccion del where,  todos los datos se van a borrar
DELETE FROM cita;
DELETE FROM contacto;


#+++++++++++++++++++++++++++ UPDATE
#Actualizar los datos de una tabla 
#Tabla contacto
UPDATE contacto 
	SET con_telefono='4771234762'
    WHERE con_id = 2; #usamos el id para restringir la modificacion

UPDATE contacto 
	SET con_telefono='4771234007'
    WHERE con_nombre = 'Uriel Zair'; #Cambiamos el telefono para el contacto con el nombre

UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 2); #Agregar 2 dias a las cit_fecha en todos los registros
    
UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 2)
    WHERE cit_fecha = '2022-04-19';#Agregar 2 dias a la cit_fecha en la fecha indicada

UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 2)
    WHERE cit_id = 2 OR cit_id = 3;#Agregar 2 dias a la cit_fecha cuando el id es 2 y 3
    
# Sin clausura WHERE
UPDATE contacto
	SET con_telefono = '1234567890'; #Modificaria los telefonos y los pondria todos en ese valor
    #-->Error como tenemos definido que el telefono es UNIQUE no lo permite ya que no puede haber telefonos iguales

#operadores logucos
#AND	 y
#OR		o
#NOT	no
UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 2)
	WHERE cit_fecha = '2022-04-23'
		AND cit_hora = '11:00:00';

UPDATE cita
	SET cit_hora = ADDTIME(cit_hora, '1:00:00')#Cantidad de tiempo que se le agrega a la hora
    WHERE cit_fecha = '2022-04-27'
		OR cit_fecha = '2022-04-26';

UPDATE cita
	SET cit_hora = ADDTIME(cit_hora, '1:00:00')
    WHERE (cit_fecha = '2022-05-03' AND cit_hora='12:00:00')
		OR (cit_fecha = '2022-05-25' AND cit_hora='12:00:00');

#Intentar actualizar una cita a una fecha y una hora repetidas
UPDATE cita
	SET cit_fecha = '2022-03-23'
    WHERE cit_fecha = '2022-03-04'; #-->Error la fecha y hora estan duplicadas

UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 1)
	WHERE cit_fecha BETWEEN '2022-05-01' AND '2022-05-31'; #OPERADOR BETWEEN
		#Actualizar los datos si se encuentran en un ranfo de fecha
							#Valor inicial      valor final -->incluidos esos dias
                            
UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 1)
	WHERE cit_fecha IN ('2022-04-26', '2022-04-27', '2022-03-23');

#Operadores relacionales
# =				Igual
# <> o !=		Diferente
# <				Menor que (numeros y fechas)		
# >				Mayor que (numeros y fechas)
# <=			Menor o igual que (numeros y fechas)		
# >=			Mayor o igual que (numeros y fechas)	

UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 1)
	WHERE cit_fecha > '2022-05-13';

UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 1)
	WHERE cit_fecha <= '2022-03-24';

UPDATE cita
	SET cit_fecha = ADDDATE(cit_fecha, 1)
	WHERE cit_fecha != '2022-05-06';

#Operador string
#Evalua cit_lugar (debe de ser string) por un patron para actualizar cit lugar
#En este caso el comodin '%' considera cualqquier string y el patron busca 
#si el string a evaluar termina en 'Alta' (p. ej 'Via alta').
#El comodin '_' considera cualquier caracter (solo 1 caracter). 
UPDATE cita
	SET cit_lugar = 'Plazoleta'
    WHERE cit_lugar LIKE '%Alta';
    
#Lista de patrones 
# '%Alta' --> El string debe terminar en la palabra 'Alta', cu7alquier cantidad de caracteres puede venir antes
# '_Alta' --> El string debe terminar en la palabra 'Alta', solo puede tener un caracter antes de la palabra.
# '%Alta%' --> Cualquier cosa, palabra  'Alta', cualquier cosa
# '_Alta_' --> Un caracter, palabra  'Alta', un caracter
# '__Alta__' --> Dos caracteres, palabra  'Alta', dos caracteres

#												Patrones
#						------------------------------------------------------------------------------
# cit_lugar					'%Alta'		'_Alta'		'%Alta%'		'_Alta_'		'__Alta__'
#----------				-------------	--------	--------		---------		--------------
# 'Via Alta'					T 			F 			T 				F 				F
# 'aAlta'						T 			T 			T 				F 				F 				
# 'Via Alta Zaragoza'			F 			F 			T 				F 				F
# 'bbAltabb'					F 			F 			T 				F 				T

#UPDATE y DELETE pueden utilizar los mismos operadores en la clausula WHERE

# Los operadores UPDATE y DELETE afectan de manera permanente los datos
# Una vez borrados o9 actualizados los datos, no se puede recuperar o volver
# a un estado previo

#+++++++++++++++ SELECT
#leer (recuperar, consultar) registros de una tabla (query)
#Leer datos de la tabla contacto
SELECT *
	FROM contacto; #Recupera los registros de todas las columnas de la tabla contacto
    
SELECT *
	FROM cita; #Recupera los registros de todas las columnas de la tabla cita

SELECT con_nombre
	FROM contacto; #Recupera los registros de la columna nombre de la tabla contacto

SELECT con_nombre, con_correo
	FROM contacto; #Recupera los registros de la columna nombre y correo de la tabla contacto

SELECT con_correo, con_nombre
	FROM contacto; #Recupera los datos de la columna nombre y correo de la tabla contacto
    #El orden de las columnas indicadas es el orden en el que se devuelve el resultado

SELECT cit_fecha, cit_lugar
	FROM cita;#Recupera los registros de la tabla cita

SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita;#Recupera los registros de fecha, hora y lugar de la tabla cita

#WHERE condicion 
#Ayuda a restringir el resultado de la consulta
#Condicion es una expresion que se evalua como verdadera para cada registro que queremos recuperar}
#Con el WHERE restringimos los renglones (registros) 
#La instruccion SELECT utilizamos los mismos operadores en la clausula WHERE
# que con las intrucciones UPDATE y DELETE 
SELECT *
	 FROM contacto
     WHERE con_nombre LIKE '%ez'; #Recupera los registros de todas la columnas pero solo los que el nombre termine con ez

SELECT con_nombre, con_correo
	 FROM contacto
     WHERE con_nombre LIKE '%ez';#Recupera los registros de las columnas nombre y correo
									#pero solo los que el nombre termine con ez

SELECT cit_fecha, cit_lugar, cit_con_id
	FROM cita
    WHERE cit_lugar = 'Altacia';#Recupera los registros de las columnas fecha, lugar y id de contacto
									#en los que el lugar sea Altacia

# ===== Referencias a tablas y colñumnas (aplica para todas las intrucciones: INSERT, SELECT, UPDATE, DELETE)
# Puedes referirte a una tabla de la base de datois actual (abierta) con nombre_tabla
# la base de datos de forma explicita con nombre_base.nombre_tabla}
SELECT con_nombre, con_correo
	FROM agenda_db.contacto
    WHERE con_nombre LIKE '%ez';
    
#Pudes referirte a una columna con nombre_columna, nombre_tabla.nombre_columna o nombre_base.nombre_tabla.nombre_columna
SELECT contacto.con_nombre, contacto.con_correo
	FROM agenda_db.contacto
	WHERE con_nombre LIKE '%ez';

SELECT agenda_db.contacto.con_nombre, agenda_db.contacto.con_correo
	FROM agenda_db.contacto
	WHERE con_nombre LIKE '%ez'; # Es explicito en la tabla y la base de dsatos de origen de las columnas

# Se debe de ser explicito cuando dos columnas tienen el mismo nombre en dos tablas
# diferentes y estoy usando ambas tablas en la consulta
SELECT estudiante.nombre, empleado.nombre
	FROM estudiante, empleado; #Ejemplo ficticio

#No es necesario ser explicito, pero es recomendado cuando la referencia pueda ser ambigua.

# ===== Union basica de tablas
SELECT *
	FROM cita;

#Union cruzada directa (cross join)
SELECT cita.*, contacto.*
	 FROM cita, contacto; #Recupera los registros de todas las columnas de la tabla cita en combinacion (union)
							# con todos los registros de todas las columnas de la tabla contacto.

#Agregando un WHERE para restringir el resultado de la cruza directa
SELECT cita.*, contacto.*
	 FROM cita, contacto
     WHERE cita.cit_con_id = contacto.con_id; #Hacemos que el id del contacto de la cita, sea igual al del contacto.
     
#Restringimos las columnas que se devuelven
SELECT cita.cit_fecha, cita.cit_hora, cita.cit_lugar, contacto.con_nombre, contacto.con_telefono
	 FROM cita, contacto
     WHERE cita.cit_con_id = contacto.con_id; #Hacemos que el id del contacto de la cita, sea igual al del contacto.
     
#Uso de alias --> cambio el nombre de la tabla de forma temporal (dentro de una consulta)
#A la referencia deuna tabla se le puede poner un alias usando la palabra AS (o directamente)
#El alias puede usarse dentro de la estructura actual (consulta)
SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
	FROM cita AS t1, contacto AS t2
	WHERE t1.cit_con_id = t2.con_id;

#Igual que arriba pero sin la palabra AS 
#El uso de la palabra AS es indistinto, pero se recomienda (explicito)
SELECT t1.cit_fecha, t1.cit_hora, t1.cit_lugar, t2.con_nombre, t2.con_telefono
	FROM cita t1, contacto t2
	WHERE t1.cit_con_id = t2.con_id;

# ------- Uso de una funcion basica 
#Concatenacion de columnas
SELECT CONCAT(con_nombre, ' ', con_correo), CONCAT(con_correo, ' ', con_telefono)
	FROM contacto; #Genera temporalmente una columna con la concatenacion del nombre y correo mas un 
					# espacio, para todos los contactos
                    #El resultado de ñla funvion genera una columna temporal con el resultado de la consulta
		
#Usar alias para el resultado de la funcion
SELECT CONCAT(con_nombre, ' ', con_correo) AS nombre_correo #Se cambia el nombre a la columna temporal
	FROM contacto;
    
# ------------ Cambiar el orden en que se recuperan los registros
# ORDER BY [nombre_columna1] [ASC | DESC],
#			[nombre_columna2] [ASC | DESC],
#			[nombre_columna3] [ASC | DESC] ....
#Por default el orden es ASC (ascendente)
# DESC = descendente
SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita
    ORDER BY cit_fecha; #DElvuelve las columnas indicadas , ordenadas por fecha (ASC, DESC)

SELECT cit_fecha, cit_hora, cit_lugar
	FROM cita
    ORDER BY cit_fecha DESC,  cit_hora DESC; #DElvuelve las columnas indicadas , ordenadas por fecha 
											# luego por hora (ASC | DESC)
						
# Usando un alias para llamar al ORDER BY

SELECT cit_fecha AS Fecha, cit_hora AS Hora, cit_lugar AS Lugar
	FROM cita
    ORDER BY cit_fecha DESC,  cit_hora DESC; #Igual que arriba, pero usando aluias para el ordenn de las columnas
   
SELECT CONCAT(con_nombre, ' ', con_correo) AS nombre_correo, con_telefono  #Se cambia el nombre a la columna temporal
	FROM contacto  
	ORDER BY nombre_correo DESC; #DEvuelve las colujmnas indicadas ordenadas por nombre_correo
    
#Incluyendo el WHERE para filtrar los registros
#El ORDER BY va despues del WHERE
SELECT cit_fecha AS Fecha, cit_hora AS Hora, cit_lugar AS Lugar
	FROM cita
    WHERE cit_lugar = 'Centro'
    ORDER BY cit_fecha DESC,  cit_hora DESC;

# iIncluyendo mas condiciones 
#SELECT utiliza los mismos operadores que UPDATE y DELETE en la clausula WHERE
#No se puede utilizar el alias en el WHERE
SELECT cit_fecha AS Fecha, cit_hora AS Hora, cit_lugar AS Lugar
	FROM cita
    WHERE cit_lugar = 'Centro' AND (cit_hora BETWEEN '10:00:00' AND '16:00:00')
    ORDER BY Fecha DESC,  Hora DESC;
    
SELECT cit_fecha AS Fecha, cit_hora AS Hora, cit_lugar AS Lugar
	FROM cita
    WHERE cit_lugar = 'Centro' 
		AND (cit_hora BETWEEN '10:00:00' AND '16:00:00')
        AND cit_fecha > '2022-05-06'
    ORDER BY Fecha DESC,  Hora DESC;    

# ------- Limita el numeromde registros que se recuperan
# LIMIT [numero1, numero2]
#Limita el numero de registros que se recuperan la sentencia SELECT, con dos numeros  como argumentos
#El primer argumento especifica la 'pocicion del primer registro a recuperar iniciando en 0. El segundo
# argumento especifica el maximo numero de registros a recuperar.
SELECT *
	FROM cita
    LIMIT 3; #Recupera los 3 primeros registros de la tabla cita
			#No hay una garantia de que siempre vaya a recuperar los mismos 

SELECT *
	FROM cita
    LIMIT 2, 3; #Recupera 3 registros de la tabla cita a partir de la posicion 2
    
#En principio los registros no tienen orden 
#Si se quiere tener un orden garantizado, utilizar ORDER BY
#LIMIT va despues de ORDER BY
SELECT *
	FROM contacto
    ORDER BY con_nombre DESC
    LIMIT 2, 3; 

#Secuencia:
# WHERE --> Filtra
# ORDER BY --> Ordena
# LIMIT --> Limita