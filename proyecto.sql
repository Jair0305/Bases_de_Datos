DROP DATABASE IF EXISTS restaurante_db;
CREATE DATABASE IF NOT EXISTS restaurante_db;

USE restaurante_db;

CREATE TABLE IF NOT EXISTS mesa
(
	mesa_id INT NOT NULL AUTO_INCREMENT,
    mesa_capacidad INT NOT NULL,
    mesa_estado ENUM('Disponible', 'Ocupado'),
    mesa_fechareservacion DATE DEFAULT NULL,
    mesa_horareservacion TIME DEFAULT NULL,
    UNIQUE(mesa_id, mesa_fechareservacion, mesa_horareservacion),
    UNIQUE(mesa_id, mesa_capacidad),
    PRIMARY KEY(mesa_id)
);

# Creación de tabla independiente "mesero"
CREATE TABLE IF NOT EXISTS mesero
(
	meser_id INT NOT NULL AUTO_INCREMENT,
    meser_nombre VARCHAR(50) NOT NULL,
    meser_ap_pat VARCHAR(50) NOT NULL,
    meser_ap_mat VARCHAR(50) DEFAULT NULL,
    INDEX(meser_nombre),
    PRIMARY KEY(meser_id)
);

# Creación de la tabla independiente "comida"
CREATE TABLE IF NOT EXISTS comida
(
	com_id INT NOT NULL AUTO_INCREMENT,
    com_nombre VARCHAR(50) NOT NULL,
    com_categoria ENUM('Sopas', 'Ensaladas', 'Carnes rojas', 'Otras carnes', 'Postres') NOT NULL,
    com_precio DECIMAL(7, 2) NOT NULL,
    INDEX(com_nombre),
    PRIMARY KEY(com_id)
);

 #Creación de la tabla independiente "bebida"
 CREATE TABLE IF NOT EXISTS bebida
 (
	beb_id INT NOT NULL AUTO_INCREMENT,
    beb_nombre VARCHAR(50) NOT NULL,
    beb_categoria ENUM('Aguas', 'Jugos', 'Refrescos', 'Cervezas', 'Coctelería') NOT NULL,
    beb_precio DECIMAL(7, 2) NOT NULL,
    INDEX(beb_nombre),
    PRIMARY KEY(beb_id)
 );

#Creación de la tabla ADICIONAL dependiente "clientes"
CREATE TABLE IF NOT EXISTS clientes
(
	cli_id INT NOT NULL AUTO_INCREMENT,
    cli_nombre VARCHAR(50) NOT NULL COMMENT 'A que nombre se encuentra la mesa',
    cli_cantidad INT NOT NULL,
    cli_mesa_id INT NOT NULL,
    PRIMARY KEY(cli_id),
    CONSTRAINT fk_mesa_clientes
		FOREIGN KEY(cli_mesa_id)
        REFERENCES mesa(mesa_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

# Creación de la tabla "orden"
CREATE TABLE IF NOT EXISTS orden
(
	ord_id INT NOT NULL AUTO_INCREMENT,
    ord_mesa_id INT NOT NULL,
    ord_meser_id INT NOT NULL,
    ord_cli_id INT NOT NULL,
    ord_estado ENUM('Abierta', 'Cerrada', 'Pagada', 'Cancelada') NOT NULL,
    PRIMARY KEY(ord_id),
    UNIQUE(ord_id, ord_mesa_id, ord_meser_id, ord_cli_id),
    CONSTRAINT fk_mesa_orden
		FOREIGN KEY(ord_mesa_id)
        REFERENCES mesa(mesa_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_mesero_orden
		FOREIGN KEY(ord_meser_id)
        REFERENCES mesero(meser_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_clientes_orden
		FOREIGN KEY(ord_cli_id)
        REFERENCES clientes(cli_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    
);

#Creación de la tabla ADICIONAL de características "detalles" de la orden
CREATE TABLE IF NOT EXISTS detalles
(
	det_ord_id INT NOT NULL,
    det_com_id INT NOT NULL,
    det_beb_id INT NOT NULL,
	det_fecha DATE NOT NULL,
    PRIMARY KEY(det_ord_id, det_com_id, det_beb_id),
    CONSTRAINT fk_orden_detalles
		FOREIGN KEY(det_ord_id)
        REFERENCES orden(ord_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT fk_comida_detalles
		FOREIGN KEY(det_com_id)
        REFERENCES comida(com_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,
	CONSTRAINT fk_bebida_detalles
		FOREIGN KEY(det_beb_id)
        REFERENCES bebida(beb_id)
		ON UPDATE RESTRICT
        ON DELETE RESTRICT
		
);
 
#Creación de la tabla ADICIONAL dependiente "cuenta"
CREATE TABLE IF NOT EXISTS cuenta
(
    cuen_ord_id INT NOT NULL,
    cuen_fecha DATE NOT NULL,
    cuen_hora TIME NOT NULL,
    cuen_total DECIMAL(7, 2) NOT NULL,
    PRIMARY KEY(cuen_ord_id),
    CONSTRAINT fk_orden_cuenta
		FOREIGN KEY(cuen_ord_id)
        REFERENCES orden(ord_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


#PRUEBAS

INSERT INTO mesa(mesa_capacidad, mesa_estado, mesa_fechareservacion, mesa_horareservacion)
	VALUE('8', 'Ocupado', '2022-03-15', '22:00:00'),
		 ('6', 'Ocupado', '2022-03-15', '18:30:00'),
		 ('10', 'Ocupado', '2022-03-15', '20:00:00'),
		 ('12', 'Ocupado', '2022-02-15', '11:30:00'),
		 ('4', 'Ocupado', '2022-02-15', '16:00:00');

INSERT INTO mesero(meser_nombre, meser_ap_pat, meser_ap_mat)
	VALUES ('Juan Carlos', 'Bodoque', 'Galindo'),
		   ('Miguel Ángel', 'Cabrera', 'López'),
		   ('Jorge Issac', 'Pérez', 'Martínez'),
		   ('Jair', 'Chávez', 'Islas'),
		   ('José Alfredo', 'Jiménez', 'Escamilla');

INSERT INTO comida(com_nombre, com_categoria, com_precio)
	VALUES ('Bistek asado', 'Carnes rojas', '45'),
		   ('Pastel', 'Postres', '60'),
		   ('Espaguetti', 'Sopas', '35'),
		   ('Pollo agridulce', 'Otras carnes', '23'),
		   ('Tiramisu', 'Postres', '80');

INSERT INTO bebida(beb_nombre, beb_categoria, beb_precio)
	VALUES ('Coca-Cola', 'Refrescos', '45'),
		   ('Jugo de mango', 'Jugos', '60'),
		   ('Modelo', 'Cervezas', '35'),
		   ('Martini', 'Coctelería', '23'),
		   ('Agua de café', 'Aguas', '80');
           
INSERT INTO clientes(cli_nombre, cli_cantidad, cli_mesa_id)
	VALUE('Héctor', '4', '5'),
		 ('Sofía', '12', '4'),
		 ('Carlos', '6', '2'),
		 ('Aldo', '8', '1'),
		 ('Emiliano', '10', '3');
         
INSERT INTO orden(ord_mesa_id, ord_meser_id, ord_cli_id, ord_estado)
	VALUES ('1', '1', '4', 'Cerrada'),
		   ('2', '2' ,'3', 'Cerrada'),
		   ('3', '3', '5', 'Cerrada'),
		   ('4', '4', '2', 'Cerrada'),
		   ('5', '5', '1', 'Cerrada'),
           ('5', '5', '2', 'Cerrada'),
           ('5', '5', '3', 'Cerrada'),
           ('5', '5', '4', 'Cerrada'),
           ('5', '5', '5', 'Cerrada');
INSERT INTO detalles(det_ord_id, det_com_id, det_beb_id, det_fecha)
	VALUES ('1', '1', '5', '2022-03-15'),
		   ('1', '2', '4', '2022-03-15'),
		   ('2', '2' ,'4', '2022-03-15'),
		   ('3', '3', '3', '2022-03-15'),
		   ('4', '4', '2', '2022-02-15'),
		   ('5', '5', '1', '2022-02-15');

INSERT INTO cuenta (cuen_ord_id, cuen_fecha, cuen_hora, cuen_total)
VALUES('1', '2022-03-15', '23:34:33', '120'),
	  ('2', '2022-03-15', '19:22:56', '160'),
      ('3', '2022-03-15', '21:25:02', '190'),
      ('4', '2022-02-15', '12:25:09', '18'),
      ('5', '2022-02-15', '16:42:47', '120');

#a. Órdenes por mesero con el total de venta para una fecha determinada
SELECT mesero.meser_id, mesero.meser_nombre, orden.ord_id, cuenta.cuen_fecha,
        SUM(cuenta.cuen_total) AS TotalDeVenta
    FROM orden
    LEFT JOIN mesero
        ON orden.ord_meser_id = mesero.meser_id
    LEFT JOIN cuenta
        ON orden.ord_id = cuenta.cuen_ord_id
    INNER JOIN mesa
        ON ord_mesa_id = mesa.mesa_id AND cuenta.cuen_fecha = mesa.mesa_fechareservacion
    GROUP BY mesero.meser_id;

#b. Órdenes por mesa con el total de venta para una fecha determinada
SELECT mesa.mesa_id,
		COUNT(or_mesa_id) AS numero_de_ordenes_por_mesa,
		SUM(cuenta.cuen_total) AS total_cuentas
	FROM mesa
	INNER JOIN orden
	ON mesa.mesa_id = orden.or_mesa_id
	INNER JOIN cuenta
	ON orden.or_id = cuenta.cuen_or_id
	WHERE mesa.mesa_id = 1
	GROUP BY DATE_FORMAT(orden.or_fecha, '2022-02-15');
    
 #c. El total de órdenes y de venta para una fecha determinada   
SELECT 
   COUNT(or_id) AS numero_de_ordenes_de_una_fecha,
		SUM(cuenta.cuen_total) AS total_venta
	FROM orden
	INNER JOIN cuenta
	ON orden.or_id = cuenta.cuen_or_id
	WHERE  orden.or_fecha = '2022-02-15';
    
#d. El total de venta por mes o año.    
SELECT 
       SUM(cuenta.cuen_total) AS "marzo"  
            FROM cuenta
               WHERE cuenta.cuen_fecha BETWEEN '2022-03-01' AND '2022-03-30';