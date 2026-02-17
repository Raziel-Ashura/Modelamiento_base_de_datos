DROP TABLE MEDICAMENTO CASCADE CONSTRAINTS;

DROP TABLE TIPO_MEDICAMENTO CASCADE CONSTRAINTS;

DROP TABLE VIA_ADMINISTRA CASCADE CONSTRAINTS;

DROP TABLE DOSIS CASCADE CONSTRAINTS;

DROP TABLE PACIENTE CASCADE CONSTRAINTS;

DROP TABLE COMUNA CASCADE CONSTRAINTS;

DROP TABLE CIUDAD CASCADE CONSTRAINTS;

DROP TABLE REGION CASCADE CONSTRAINTS;

DROP TABLE DIAGNOSTICO CASCADE CONSTRAINTS;

DROP TABLE RECETA CASCADE CONSTRAINTS;

DROP TABLE TIPO_RECETA CASCADE CONSTRAINTS;

DROP TABLE MEDICO CASCADE CONSTRAINTS;

DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS;

DROP TABLE DIGITADOR CASCADE CONSTRAINTS;

DROP TABLE PAGO CASCADE CONSTRAINTS;

DROP TABLE BANCO CASCADE CONSTRAINTS;

CREATE TABLE region (
    id_region NUMBER(5) PRIMARY KEY,
    nombre_region VARCHAR2(25) NOT NULL
);

CREATE TABLE ciudad (
    id_ciudad NUMBER(5) PRIMARY KEY,
    id_region NUMBER(5),
    nombre_ciudad VARCHAR2(25) NOT NULL,
    CONSTRAINT ciudad_region_fk FOREIGN KEY (id_region) REFERENCES region(id_region)
);

CREATE TABLE comuna (
    id_comuna NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1101 INCREMENT BY 1) PRIMARY KEY,
    id_ciudad NUMBER(5),
    nombre_comuna VARCHAR2(25) NOT NULL,
    CONSTRAINT comuna_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

CREATE TABLE tipo_medicamento (
    id_tipo_medicamento NUMBER(3) PRIMARY KEY,
    tipo_medicamento VARCHAR2(25) NOT NULL
);

CREATE TABLE via_administra (
    id_via_administra NUMBER(3) PRIMARY KEY,
    via_administra VARCHAR2(25) NOT NULL
);

CREATE TABLE medicamento (
    id_medicamento NUMBER(7) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL,
    id_tipo_medicamento NUMBER(3) NOT NULL,
    id_via_administra NUMBER(3) NOT NULL,
    via_administra VARCHAR2(25) NOT NULL,
    dosis_recomendada VARCHAR2(25) CHECK (dosis_recomendada > 0) NOT NULL,
    stock NUMBER(6) DEFAULT 0 CHECK (stock >= 0),
    CONSTRAINT medicamento_tipo_medicamento_fk FOREIGN KEY (id_tipo_medicamento) REFERENCES tipo_medicamento (id_tipo_medicamento),
    CONSTRAINT medicamento_via_administra_fk FOREIGN KEY (id_via_administra) REFERENCES via_administra(id_via_administra)
);

ALTER TABLE medicamento
    ADD precio_unitario NUMBER(10,2) CONSTRAINT chk_precio_medicamento CHECK (precio_unitario BETWEEN 1000 AND 2000000);

CREATE TABLE paciente (
    rut_pac VARCHAR2(25) PRIMARY KEY,
    dv_pac CHAR(1) CHECK (REGEXP_LIKE(dv_pac, '^[0-9Kk]$')) NOT NULL,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    papellido VARCHAR2(25) NOT NULL,
    sapellido VARCHAR2(25) NOT NULL,
    edad NUMBER(3) NOT NULL,
    telefono NUMBER(11) NOT NULL,
    calle VARCHAR2(25) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    id_comuna NUMBER(5) NOT NULL,
    id_ciudad NUMBER(5) NOT NULL,
    id_region NUMBER(5) NOT NULL,
    CONSTRAINT paciente_comuna FOREIGN KEY (id_comuna) REFERENCES comuna(id_comuna),
    CONSTRAINT paciente_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad),
    CONSTRAINT paciente_region_fk FOREIGN KEY (id_region) REFERENCES region(id_region)
);

ALTER TABLE paciente
    DROP COLUMN edad;
    
ALTER TABLE paciente
    ADD fecha_nacimiento DATE NOT NULL;

CREATE TABLE diagnostico (
    id_diagnostico NUMBER(3) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL
);

CREATE TABLE tipo_receta (
    id_tipo_receta NUMBER(3) PRIMARY KEY,
    tipo_receta VARCHAR2(25) NOT NULL
);

CREATE TABLE medico (
    rut_med NUMBER(8) PRIMARY KEY,
    id_medico NUMBER(5) NOT NULL,
    dv_med CHAR(1) NOT NULL,
    pnombre VARCHAR2(25) NOT NULL,
    snombre VARCHAR2(25),
    papellido VARCHAR2(25) NOT NULL,
    sapellido VARCHAR2(25),
    telefono NUMBER(15) NOT NULL
);

CREATE TABLE digitador (
    id_digitador NUMBER(20) PRIMARY KEY,
    pnombre VARCHAR2(25) NOT NULL,
    papellido VARCHAR2(25) NOT NULL
);

CREATE TABLE especialidad (
    id_especialidad NUMBER(3) PRIMARY KEY,
    especialidad VARCHAR2(25) NOT NULL
);

CREATE TABLE banco (
    id_banco NUMBER(2) PRIMARY KEY,
    nombre VARCHAR2(25) NOT NULL
);

CREATE TABLE pago (
    id_boleta NUMBER(6) PRIMARY KEY,
    id_receta NUMBER(7) NOT NULL,
    fecha_pago DATE NOT NULL,
    monto_total VARCHAR2(25) NOT NULL,
    metodo_pago VARCHAR2(25) NOT NULL,
    id_banco NUMBER(2),
    CONSTRAINT pago_banco_fk FOREIGN KEY (id_banco) REFERENCES banco(id_banco)
);

ALTER TABLE pago
    ADD CONSTRAINT chk_metodo_pago CHECK (metodo_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA'));
    
CREATE TABLE receta (
    id_receta NUMBER(7) PRIMARY KEY,
    observaciones VARCHAR2(500) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    pac_rut VARCHAR2(25) NOT NULL,
    id_diagnostico NUMBER(3) NOT NULL,
    id_dosis NUMBER(3) NOT NULL,
    diagnostico VARCHAR2(50) NOT NULL,
    id_digitador NUMBER(4) NOT NULL,
    med_rut NUMBER(8) NOT NULL,
    CONSTRAINT receta_diagnostico_fk FOREIGN KEY (id_diagnostico) REFERENCES diagnostico(id_diagnostico),
    CONSTRAINT receta_medico_fk FOREIGN KEY (med_rut) REFERENCES medico(rut_med),
    CONSTRAINT receta_paciente_fk FOREIGN KEY (pac_rut) REFERENCES paciente(rut_pac),
    CONSTRAINT receta_digitador_fk FOREIGN KEY (id_digitador) REFERENCES digitador(id_digitador)
);

CREATE TABLE dosis (
    id_medicamento NUMBER(7) PRIMARY KEY,
    id_receta NUMBER(7) NOT NULL,
    unidad_medicamento NUMBER(2) NOT NULL,
    dosis VARCHAR2(30) NOT NULL,
    dias_tratamiento NUMBER(2) NOT NULL,
    descripcion_dosis VARCHAR2(25) NOT NULL,
    CONSTRAINT dosis_medicamento_fk FOREIGN KEY (id_medicamento) REFERENCES medicamento(id_medicamento),
    CONSTRAINT dosis_receta_fk FOREIGN KEY (id_receta) REFERENCES receta(id_receta)
);