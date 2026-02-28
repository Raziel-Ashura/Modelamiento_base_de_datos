--Inicio caso 1

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE servicio CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE detalle_servicio CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE sucursal CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE mantencion CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ciudad CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE pais CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE mecanico CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE marca CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE modelo CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE automovil CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE cliente CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE tipo_automovil CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE estandar CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE premium CASCADE CONSTRAINTS PURGE';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

DROP SEQUENCE seq_servicio;

DROP SEQUENCE seq_ciudad;

CREATE TABLE servicio (
  id_servicio NUMBER(3)    NOT NULL,
  descripcion VARCHAR2(100) NOT NULL,
  costo       NUMBER(7)    NOT NULL
);

CREATE TABLE pais (
  id_pais NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 9 INCREMENT BY 3),
  nom_pais VARCHAR2(30) NOT NULL
);

CREATE TABLE marca (
  id_marca NUMBER(2)    NOT NULL,
  descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE cliente (
  rut NUMBER(8)    NOT NULL,
  dv CHAR(1)    NOT NULL,
  pnombre VARCHAR2(20)    NOT NULL,
  snombre VARCHAR2(20),
  apaterno VARCHAR2(20)    NOT NULL,
  amaterno VARCHAR2(20)    NOT NULL,
  telefono VARCHAR2(12),
  email VARCHAR2(40),
  tipo_cli CHAR(1)    NOT NULL
);

CREATE TABLE tipo_automovil (
  id_tipo CHAR(3) NOT NULL,
  descripcion VARCHAR2(20) NOT NULL
);

CREATE TABLE ciudad (
  id_ciudad NUMBER (3) NOT NULL,
  nom_ciudad VARCHAR2(30) NOT NULL,
  cod_pais NUMBER(3) NOT NULL
);

CREATE TABLE sucursal (
  id_sucursal CHAR(3) NOT NULL,
  nom_sucursal VARCHAR2(20) NOT NULL,
  calle VARCHAR2(20) NOT NULL,
  num_calle NUMBER(4) NOT NULL,
  cod_ciudad NUMBER(3)
);

CREATE TABLE mecanico (
    cod_mecanico NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 460 INCREMENT BY 7),
    pnombre VARCHAR2 (20) NOT NULL,
    snombre VARCHAR2 (20) NOT NULL,
    apaterno VARCHAR2 (20) NOT NULL,
    amaterno VARCHAR2 (20) NOT NULL,
    bono_jefatura NUMBER(10),
    sueldo NUMBER(10) NOT NULL,
    monto_impuestos NUMBER(10) NOT NULL,
    cod_supervisor NUMBER(5)
); 

CREATE TABLE modelo (
    id_modelo NUMBER(5) NOT NULL,
    marca_id NUMBER(5) NOT NULL,
    descripcion VARCHAR2(20) NOT NULL
); 

CREATE TABLE estandar(
    cl_rut  NUMBER(8) NOT NULL,
    puntaje_fidelidad NUMBER(10) NOT NULL

);

CREATE TABLE premium (
     cl_rut  NUMBER(8) NOT NULL,
     pesos_clientes NUMBER(10) NOT NULL,
     monto_credito NUMBER(10)
); 

CREATE TABLE automovil (
     patente CHAR(8) NOT NULL,
     annio NUMBER(4) NOT NULL,
     cant_puertas NUMBER(1) NOT NULL,
     km NUMBER(6) NOT NULL,
     color VARCHAR2(30) NOT NULL,
     cod_tipo_auto CHAR(3) NOT NULL,
     cod_modelo NUMBER(5) NOT NULL,
     cod_marca NUMBER(2) NOT NULL,
     cl_rut NUMBER(8)
);

 CREATE TABLE mantencion (
     num_mantencion NUMBER(4) NOT NULL,
     cod_sucursal CHAR(3) NOT NULL,
     fecha_ingreso DATE NOT NULL,
     fecha_salida DATE,
     patente_auto CHAR(8),
     cod_mecanico NUMBER(5) NOT NULL,
     costo_total NUMBER(7) NOT NULL,
     estado VARCHAR2(15)
); 

CREATE TABLE detalle_servicio (
     mantencion_num  NUMBER(4) NOT NULL,
     cod_servicio NUMBER(3) NOT NULL,
     descuento_serv NUMBER(4,3) NOT NULL,
     cantidad NUMBER(3) NOT NULL
);

ALTER TABLE servicio ADD CONSTRAINT servicio_pk PRIMARY KEY (id_servicio);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY (id_pais);

ALTER TABLE marca ADD CONSTRAINT marca_pk PRIMARY KEY (id_marca);

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY (rut);

ALTER TABLE tipo_automovil ADD CONSTRAINT tipo_automovil_pk PRIMARY KEY (id_tipo);

ALTER TABLE ciudad ADD CONSTRAINT ciudad_pk PRIMARY KEY (id_ciudad);
ALTER TABLE ciudad ADD CONSTRAINT ciudad_fk_pais FOREIGN KEY (cod_pais) REFERENCES pais(id_pais);

ALTER TABLE sucursal ADD CONSTRAINT sucursal_pk PRIMARY KEY (id_sucursal);
ALTER TABLE sucursal ADD CONSTRAINT sucursal_fk_ciudad FOREIGN KEY (cod_ciudad) REFERENCES ciudad(id_ciudad);

ALTER TABLE mecanico ADD CONSTRAINT mecanico_pk PRIMARY KEY (cod_mecanico);
ALTER TABLE mecanico ADD CONSTRAINT mecanico_fk_mecanico FOREIGN KEY (cod_supervisor) REFERENCES mecanico(cod_mecanico);

ALTER TABLE modelo ADD CONSTRAINT modelo_pk PRIMARY KEY (id_modelo, marca_id);
ALTER TABLE modelo ADD CONSTRAINT modelo_fk_marca FOREIGN KEY (marca_id) REFERENCES marca(id_marca);

ALTER TABLE estandar ADD CONSTRAINT normal_pk PRIMARY KEY (cl_rut);
ALTER TABLE estandar ADD CONSTRAINT normal_fk_cliente FOREIGN KEY (cl_rut) REFERENCES cliente(rut);

ALTER TABLE premium ADD CONSTRAINT premium_pk PRIMARY KEY (cl_rut);
ALTER TABLE premium ADD CONSTRAINT premium_fk_cliente FOREIGN KEY (cl_rut) REFERENCES cliente(rut);

ALTER TABLE automovil ADD CONSTRAINT automovil_pk PRIMARY KEY (patente);
ALTER TABLE automovil ADD CONSTRAINT automovil_fk_cliente FOREIGN KEY (cl_rut) REFERENCES cliente(rut);
ALTER TABLE automovil ADD CONSTRAINT automovil_fk_modelo FOREIGN KEY (cod_modelo, cod_marca) REFERENCES modelo(id_modelo, marca_id);
ALTER TABLE automovil ADD CONSTRAINT automovil_fk_tipo FOREIGN KEY (cod_tipo_auto) REFERENCES tipo_automovil(id_tipo);

ALTER TABLE mantencion ADD CONSTRAINT mantencion_pk PRIMARY KEY (num_mantencion);
ALTER TABLE mantencion ADD CONSTRAINT mant_fk_automovil FOREIGN KEY (patente_auto) REFERENCES automovil(patente);
ALTER TABLE mantencion ADD CONSTRAINT mant_fk_mecanico FOREIGN KEY (cod_mecanico) REFERENCES mecanico(cod_mecanico);
ALTER TABLE mantencion ADD CONSTRAINT mant_fk_sucursal FOREIGN KEY (cod_sucursal) REFERENCES sucursal(id_sucursal);

ALTER TABLE detalle_servicio ADD CONSTRAINT detalle_servicio_pk PRIMARY KEY (mantencion_num, cod_servicio);
ALTER TABLE detalle_servicio ADD CONSTRAINT det_serv_fk_mantencion FOREIGN KEY (mantencion_num) REFERENCES mantencion(num_mantencion);
ALTER TABLE detalle_servicio ADD CONSTRAINT det_serv_fk_servicio FOREIGN KEY (cod_servicio) REFERENCES servicio(id_servicio);

-- Inicio caso 2

ALTER TABLE mantencion DROP COLUMN costo_total;

ALTER TABLE detalle_servicio DROP CONSTRAINT det_serv_fk_mantencion;
ALTER TABLE mantencion DROP CONSTRAINT mantencion_pk;
ALTER TABLE detalle_servicio ADD sucursal_cod CHAR(3) NOT NULL;
ALTER TABLE mantencion ADD CONSTRAINT mantencion_pk PRIMARY KEY (num_mantencion, cod_sucursal);
ALTER TABLE detalle_servicio ADD CONSTRAINT det_serv_fk_mantencion FOREIGN KEY (mantencion_num, sucursal_cod) REFERENCES mantencion(num_mantencion, cod_sucursal);

ALTER TABLE cliente ADD CONSTRAINT un_cliente_mail UNIQUE (email);

ALTER TABLE cliente ADD CONSTRAINT ck_valida_dv CHECK (dv IN ('0','1','2','3','4','5','6','7','8','9','K'));

ALTER TABLE mecanico ADD CONSTRAINT ck_sueldo_mecanico CHECK (sueldo >= 510000);

ALTER TABLE mantencion ADD CONSTRAINT ck_mant_estado CHECK (estado IN ('Reserva','Ingresado','Entregado','Anulado'));

-- Inicia caso 3

CREATE SEQUENCE seq_servicio
  START WITH 400
  MINVALUE 400
  NOMAXVALUE
  INCREMENT BY 2
  NOCYCLE;
  
CREATE SEQUENCE seq_ciudad
  START WITH 165
  MINVALUE 165
  NOMAXVALUE
  INCREMENT BY 5
  NOCYCLE;
  
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';
  
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, NULL);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Pedro', 'Jose', 'Manriquez', 'Corral', NULL, 759000, 23980, NULL);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Felipe', 'M.', 'Vidal', 'A.', NULL, 759000, 23580, 460);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Jose', 'Miguel', 'Troncoso', 'B.', NULL, 659000, 44580, 474);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Juan', 'Pablo', 'Sánchez', 'R.', NULL, 859000, 23380, 474);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Alberto', 'P.', 'Cerda', 'Ramírez', NULL, 559000, 22380, 460);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Alejandra', 'Gabriela', 'Infanti', 'R.', NULL, 659000, 22380, 460);
INSERT INTO mecanico (PNOMBRE, SNOMBRE, APATERNO, AMATERNO, BONO_JEFATURA, SUELDO, MONTO_IMPUESTOS, COD_SUPERVISOR) VALUES ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', NULL, 859000, 22380, 460);
  
INSERT INTO PAIS (NOM_PAIS) VALUES ('Chile');
INSERT INTO PAIS (NOM_PAIS) VALUES ('Peru');
INSERT INTO PAIS (NOM_PAIS) VALUES ('Colombia');
  
INSERT INTO ciudad VALUES (seq_ciudad.NEXTVAL, 'Santiago', 9);
INSERT INTO ciudad VALUES (seq_ciudad.NEXTVAL, 'Lima', 12);
INSERT INTO ciudad VALUES (seq_ciudad.NEXTVAL, 'Bogotá', 15);
  
INSERT INTO sucursal (ID_SUCURSAL, NOM_SUCURSAL, CALLE, NUM_CALLE, COD_CIUDAD) VALUES ('S01', 'Providencia', 'Av. A. Varas', 234, 165);
INSERT INTO sucursal (ID_SUCURSAL, NOM_SUCURSAL, CALLE, NUM_CALLE, COD_CIUDAD) VALUES ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);
INSERT INTO sucursal (ID_SUCURSAL, NOM_SUCURSAL, CALLE, NUM_CALLE, COD_CIUDAD) VALUES ('S03', 'El Cafetero', 'Av. El Faro', 900, 175);

INSERT INTO mantencion VALUES (101, 'S01', '12-04-2023', NULL, NULL, 481, 'Reserva');
INSERT INTO mantencion VALUES (102, 'S02', '21-02-2023', '21-02-2023', NULL, 502, 'Entregado');
INSERT INTO mantencion VALUES (103, 'S02', '09-10-2023', NULL, NULL, 502, 'Anulado');
INSERT INTO mantencion VALUES (104, 'S03', '11-08-2023', '18-08-2023', NULL, 509, 'Entregado');
INSERT INTO mantencion VALUES (105, 'S03', '03-12-2023', NULL, NULL, 509, 'Ingresado');

INSERT INTO servicio VALUES (seq_servicio.NEXTVAL, 'Cambio Luces', 45000);
INSERT INTO servicio VALUES (seq_servicio.NEXTVAL, 'Desabolladura', 67000);
INSERT INTO servicio VALUES (seq_servicio.NEXTVAL, 'Revisión Frenos', 30000);
INSERT INTO servicio VALUES (seq_servicio.NEXTVAL, 'Cambio Puerta Trasera', 50000);  

COMMIT;

-- Inicio caso 4

SELECT
  cod_mecanico AS "ID MECANICO",
  pnombre || ' ' || apaterno AS "NOMBRE MECANICO",
  sueldo AS "SALARIO",
  monto_impuestos AS "IMPUESTO ACTUAL",
  (monto_impuestos * 0.8) AS "IMPUESTO REBAJADO",
  (sueldo - (monto_impuestos * 0.8)) AS "SUELDO CON REBAJA IMPUESTOS"
FROM mecanico
WHERE bono_jefatura IS NULL
  AND monto_impuestos < 40000
ORDER BY monto_impuestos DESC, apaterno ASC;

SELECT
cod_mecanico AS "IDENTIFICADOR",
  pnombre || ' ' || snombre || ' ' || apaterno AS "MECANICO",
  sueldo AS "SALARIO ACTUAL",
  (sueldo * 0.05) AS "AJUSTE",
  (sueldo + (sueldo * 0.05)) AS "SUELDO REAJUSTADO"
FROM mecanico
WHERE (sueldo BETWEEN 600000 AND 900000)
   OR cod_supervisor IS NULL
ORDER BY sueldo ASC, (pnombre || ' ' || snombre || ' ' || apaterno) DESC;