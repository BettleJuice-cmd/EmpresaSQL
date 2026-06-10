--PARTE I
IF DB_ID('EmpresaSQL') IS NOT NULL
BEGIN
ALTER DATABASE EmpresaSQL
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE EmpresaSQL;
END
GO

CREATE DATABASE EmpresaSQL;
Go

USE EmpresaSQL;
Go

CREATE TABLE TDepartamentos (
nDepartamentoID INT IDENTITY(1,1),
cNombreDepartamento NVARCHAR(100) UNIQUE NOT NULL,
CONSTRAINT PK_DepartamentoID PRIMARY KEY (nDepartamentoID),
CONSTRAINT Uq_NombreDepartamento UNIQUE (cNombreDepartamento)
);

CREATE TABLE TCargo (
nCargoID INT IDENTITY(1,1),
cNombreCargo NVARCHAR(100) UNIQUE NOT NULL,
CONSTRAINT PK_nCargoID PRIMARY KEY (nCargoID),
CONSTRAINT Uq_NombreCargo UNIQUE (cNombreCargo)
);

CREATE TABLE TEmpleado(
nEmpleadoID INT IDENTITY(1,1),
cNIF VARCHAR(12) UNIQUE NOT NULL,
cNombre NVARCHAR(80) NOT NULL,
cApellido NVARCHAR(80) NOT NULL,
nDepartamentoID INT,
nCargoID INT,
dFechaContratacion DATETIME DEFAULT GETDATE(),
nSalario DECIMAL (10,2),
CONSTRAINT PK_nEmpleadoID PRIMARY KEY (nEmpleadoID),
CONSTRAINT Uq_cNIF UNIQUE (cNIF),
CONSTRAINT FK_nDepartamentoID FOREIGN KEY (nDepartamentoID) REFERENCES TDepartamentos(nDepartamentoID),
CONSTRAINT FK_nCargoID FOREIGN KEY (nCargoID) REFERENCES Tcargo(nCargoID),
CONSTRAINT CK_nSalario CHECK (nSalario >= 300)
);

CREATE TABLE TProyecto (
nProyectoID INT IDENTITY(1,1),
cNombreProyecto NVARCHAR(120) UNIQUE NOT NULL,
dFechaInicio DATETIME NOT NULL,
dFechaFinalizacion DATETIME NOT NULL,
CONSTRAINT PK_nProyectoID PRIMARY KEY (nProyectoID)
)

CREATE TABLE TEmpleadoProyecto (
nEmpleadoProyecto INT IDENTITY(1,1),
nEmpleadoID INT,
nProyectoID INT,
CONSTRAINT PK_EmpleadoProyecto PRIMARY KEY (nEmpleadoProyecto),
CONSTRAINT FK_nEmpleadoID FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
CONSTRAINT FK_nProyectoID FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);

--PARTE II
ALTER TABLE TEmpleado ADD cEmail NVARCHAR(26);
ALTER TABLE TEmpleado ADD cTelefono VARCHAR(9);
ALTER TABLE TEmpleado ALTER COLUMN cNombre NVARCHAR(100);
ALTER TABLE TEmpleado  ALTER COLUMN cApellido NVARCHAR(100);
ALTER TABLE TEmpleado ADD cDireccion NVARCHAR(MAX);
ALTER TABLE TEmpleado ADD nEdad INT;
ALTER TABLE TEmpleado ADD CONSTRAINT CK_Edad CHECK (nEdad BETWEEN 18 AND 65);
ALTER TABLE TEmpleado ADD CONSTRAINT UQ_cEmail UNIQUE (cEmail);
ALTER TABLE TEmpleado ADD bActivo BIT NOT NULL DEFAULT 1;
ALTER TABLE TEmpleado DROP COLUMN cDireccion;
ALTER TABLE TEmpleado ALTER COLUMN cTelefono VARCHAR(20);
ALTER TABLE TEmpleado ADD cGenero VARCHAR(1);
ALTER TABLE TEmpleado ADD CONSTRAINT CK_cGenero CHECK (cGenero IN('M', 'F'));
ALTER TABLE TEmpleado ADD dFechaNacimiento DATE NOT NULL DEFAULT GETDATE();
ALTER TABLE TEmpleado ADD TSucursal NVARCHAR(100) NOT NULL;

--PARTE III
INSERT INTO TDepartamentos (cNombreDepartamento) VALUES ('Recursos Humanos'), ('Desarrollo de Software'), ('Ventas Corporativas'), 
('Marketing y Publicidad'),('Contabilidad y Finanzas');

INSERT INTO TCargo (cNombreCargo) VALUES ('Director General'), ('Desarrollador Backend Senior'), ('Ejecutivo de Cuentas'), 
('Analista de Marketing'), ('Auditor Financiero');

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, dFechaContratacion, nSalario, cEmail, cTelefono, nEdad, bActivo, cGenero, dFechaNacimiento, TSucursal) VALUES
('001-010190-1', 'Juan', 'Pérez', 1, 1, '2023-01-15', 2500.00, 'jperez@empresa.com', '8888-1111', 35, 1, 'M', '1990-01-01', 'Managua'),
('002-020292-2', 'María', 'López', 2, 2, '2023-02-10', 2000.00, 'mlopez@empresa.com', '8888-2222', 30, 1, 'F', '1992-02-02', 'Masaya'),
('003-030388-3', 'Carlos', 'Gómez', 3, 3, '2022-11-05', 800.00, 'cgomez@empresa.com', '8888-3333', 28, 1, 'M', '1988-03-03', 'Managua'),
('004-040495-4', 'Ana', 'Martínez', 4, 4, '2021-08-20', 1200.00, 'amartinez@empresa.com', '8888-4444', 29, 1, 'F', '1995-04-04', 'León'),
('005-050580-5', 'Luis', 'Fernández', 5, 5, '2020-05-12', 1800.00, 'lfernandez@empresa.com', '8888-5555', 42, 1, 'M', '1980-05-05', 'Granada'),
('006-060698-6', 'Laura', 'Díaz', 2, 2, '2023-03-01', 1900.00, 'ldiaz@empresa.com', '8888-6666', 25, 1, 'F', '1998-06-06', 'Managua'),
('007-070785-7', 'José', 'García', 3, 3, '2021-02-28', 850.00, 'jgarcia@empresa.com', '8888-7777', 38, 1, 'M', '1985-07-07', 'Estelí'),
('008-080893-8', 'Sofía', 'Ruiz', 1, 4, '2022-07-15', 1300.00, 'sruiz@empresa.com', '8888-8888', 31, 1, 'F', '1993-08-08', 'Managua'),
('009-090991-9', 'Pedro', 'Sánchez', 5, 5, '2019-10-10', 1750.00, 'psanchez@empresa.com', '8888-9999', 34, 1, 'M', '1991-09-09', 'Masaya'),
('010-101089-0', 'Elena', 'Romero', 2, 2, '2023-06-05', 2100.00, 'eromero@empresa.com', '8888-0000', 36, 1, 'F', '1989-10-10', 'León');

INSERT INTO TProyecto (cNombreProyecto, dFechaInicio, dFechaFinalizacion) VALUES ('Migración a la Nube AWS', '2024-01-01', '2024-06-30'),('Campaña Publicitaria Q3', '2024-07-01', '2024-09-30'),
    ('Auditoría Anual 2024', '2024-10-01', '2024-12-15');

INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES 
    (2, 1), -- María López asignada a Migración AWS
    (6, 1), -- Laura Díaz asignada a Migración AWS
    (4, 2), -- Ana Martínez asignada a Campaña Publicitaria Q3
    (5, 3), -- Luis Fernández asignado a Auditoría Anual
    (9, 3); -- Pedro Sánchez asignado a Auditoría Anual

    INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, cEmail, cTelefono, nEdad, bActivo, cGenero, TSucursal)
VALUES ('011-111195-1', 'Roberto', 'Cruz', 2, 2, 1400.00, 'rcruz@empresa.com', '8888-1122', 28, 1, 'M', 'Managua');

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, dFechaContratacion, nSalario, cEmail, cTelefono, nEdad, bActivo, cGenero, dFechaNacimiento, TSucursal)
VALUES ('012-121290-2', 'Carmen', 'Vargas', 3, 3, '2023-08-01', 900.00, 'cvargas@empresa.com', '8888-3344', 33, 1, 'F', '1990-12-12', 'Estelí');

INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, dFechaContratacion, nSalario, cEmail, cTelefono, nEdad, cGenero, dFechaNacimiento, TSucursal)
VALUES ('013-131392-3', 'Miguel', 'Torres', 4, 1, '2022-01-10', 2500.00, 'mtorres@empresa.com', '8888-5566', 40, 'M', '1982-01-15', 'Granada');

INSERT INTO TDepartamentos (cNombreDepartamento)
VALUES 
    ('Soporte Técnico Informático'),
    ('Logística y Transporte'),
    ('Recursos Materiales');

    INSERT INTO TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, dFechaContratacion, nSalario, cEmail, cTelefono, nEdad, bActivo, cGenero, dFechaNacimiento, TSucursal)
VALUES ('014-141499-4', 'Lucía', 'Méndez', 1, 3, '2023-09-01', -150.00, 'lmendez@empresa.com', '8888-7788', 25, 1, 'F', '1999-02-20', 'Managua');

--PARTE IV
UPDATE TEmpleado SET nSalario = nSalario * 1.10;
UPDATE TEmpleado SET nSalario = nSalario * 1.20 WHERE nDepartamentoID = 3;
UPDATE TEmpleado SET cEmail = 'juan.perez_oficial@empresa.com' WHERE nEmpleadoID = 1;
UPDATE TEmpleado SET nCargoID = 2 WHERE nEmpleadoID = 7;
UPDATE TEmpleado SET nDepartamentoID = 5 WHERE nEmpleadoID IN (3, 8);
UPDATE TEmpleado SET bActivo = 0 WHERE nSalario < 500;
UPDATE TProyecto SET dFechaFinalizacion = '2024-08-31' WHERE nProyectoID = 1;
INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES (1, 3);

--PARTE V
DELETE FROM TEmpleado WHERE cNIF = '012-121290-2';
DELETE FROM TEmpleado WHERE bActivo = 0;
DELETE FROM TProyecto WHERE nProyectoID = 2;
DELETE FROM TEmpleadoProyecto WHERE nEmpleadoID = 2;
DELETE FROM TDepartamentos WHERE nDepartamentoID = 8;





