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

CREATE TABLE TProducto (
    nProductoID     INT IDENTITY(1,1),
    cCodigoProducto VARCHAR(20)      UNIQUE NOT NULL,
    cNombreProducto NVARCHAR(150)    NOT NULL,
    cDescripcion    NVARCHAR(MAX),
    cCategoria      NVARCHAR(80)     NOT NULL,
    nPrecioUnitario DECIMAL(10,2)    NOT NULL,
    nStock          INT              NOT NULL DEFAULT 0,
    bActivo         BIT              NOT NULL DEFAULT 1,
    dFechaRegistro  DATETIME                  DEFAULT GETDATE(),
    CONSTRAINT PK_nProductoID      PRIMARY KEY (nProductoID),
    CONSTRAINT UQ_cCodigoProducto  UNIQUE      (cCodigoProducto),
    CONSTRAINT CK_nPrecioUnitario  CHECK       (nPrecioUnitario > 0),
    CONSTRAINT CK_nStock           CHECK       (nStock >= 0)
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

INSERT INTO TProducto (cCodigoProducto, cNombreProducto, cDescripcion, cCategoria, nPrecioUnitario, nStock)
VALUES
-- Electrónica
('ELEC-001', 'Laptop HP 15"',            'Laptop Intel Core i5, 8GB RAM, 512GB SSD',      'Electrónica', 850.00,  25),
('ELEC-002', 'Monitor Samsung 24"',       'Monitor Full HD IPS, 75Hz, panel plano',         'Electrónica', 220.00,  40),
('ELEC-003', 'Teclado Mecánico Logitech', 'Teclado RGB, switches táctiles, USB',            'Electrónica',  75.00,  60),
('ELEC-004', 'Mouse Inalámbrico',         'Mouse ergonómico, 2.4GHz, batería AAA',          'Electrónica',  30.00,  80),
('ELEC-005', 'Auriculares Sony WH-1000',  'Auriculares over-ear, cancelación de ruido',     'Electrónica', 120.00,  35),
-- Oficina
('OFIC-001', 'Silla Ejecutiva Ergonómica','Silla reclinable, soporte lumbar ajustable',     'Oficina',     180.00,  15),
('OFIC-002', 'Escritorio de Madera',      'Escritorio 1.5m x 0.6m, color café oscuro',     'Oficina',     250.00,   8),
('OFIC-003', 'Archivero Metálico 4 Gav.', 'Archivero de acero, llave de seguridad',         'Oficina',     160.00,  12),
('OFIC-004', 'Pizarrón Blanco 1.2m',     'Pizarrón magnético con marco de aluminio',       'Oficina',      55.00,  20),
('OFIC-005', 'Proyector Epson S41+',      'Proyector 3300 lúmenes, resolución SVGA',        'Oficina',     400.00,   6),
-- Papelería
('PAPE-001', 'Resma de Papel A4 500 hj.', 'Papel bond 75g/m², blancura 92%, 500 hojas',    'Papelería',     8.50, 200),
('PAPE-002', 'Bolígrafos Azules x12',     'Caja de 12 bolígrafos punta fina',               'Papelería',     3.20, 500),
('PAPE-003', 'Folder Manila x25',         'Paquete de 25 folders tamaño carta',             'Papelería',     4.75, 350),
('PAPE-004', 'Cuaderno Universitario',    'Cuaderno 100 páginas, rayado, tapa dura',        'Papelería',     2.80, 400),
('PAPE-005', 'Cinta Adhesiva x6',         'Pack de 6 rollos cinta transparente 18mm',       'Papelería',     5.50, 300),
-- Software / Licencias
('SOFT-001', 'Licencia Microsoft Office', 'Office 365 Personal, suscripción anual',         'Software',     99.00,  50),
('SOFT-002', 'Antivirus ESET NOD32',      'Licencia 1 PC, 1 año de protección',             'Software',     45.00,  75),
('SOFT-003', 'Adobe Acrobat Pro',         'Licencia anual, edición y firma de PDFs',        'Software',    180.00,  30),
('SOFT-004', 'Licencia Windows 11 Pro',   'Licencia permanente, clave digital',             'Software',    140.00,  40),
('SOFT-005', 'AutoCAD LT 2024',           'Licencia anual CAD 2D para diseño técnico',      'Software',    420.00,  10);

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

--PARTE VI 
SELECT * FROM TEmpleado ORDER BY cApellido ASC;

SELECT * FROM TEmpleado WHERE nSalario > 1000;

SELECT * FROM TEmpleado WHERE bActivo = 1;

SELECT * FROM TEmpleado WHERE YEAR(dFechaContratacion) = YEAR(GETDATE());

SELECT E.cNombre, E.cApellido, D.cNombreDepartamento FROM TEmpleado E
INNER JOIN TDepartamentos D ON E.nDepartamentoID = D.nDepartamentoID;

SELECT E.cNombre, E.cApellido, C.cNombreCargo FROM TEmpleado E
INNER JOIN TCargo C ON E.nCargoID = C.nCargoID;

SELECT E.cNombre, E.cApellido, P.cNombreProyecto FROM TEmpleado E
INNER JOIN TEmpleadoProyecto EP ON E.nEmpleadoID = EP.nEmpleadoID
INNER JOIN TProyecto P ON EP.nProyectoID = P.nProyectoID;

SELECT D.cNombreDepartamento, COUNT(E.nEmpleadoID) AS CantidadEmpleados FROM TDepartamentos D
LEFT JOIN TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID GROUP BY D.cNombreDepartamento;

SELECT D.cNombreDepartamento, AVG(E.nSalario) AS SalarioPromedio FROM TDepartamentos D
INNER JOIN TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID GROUP BY D.cNombreDepartamento;

SELECT D.cNombreDepartamento, MAX(E.nSalario) AS SalarioMaximo, MIN(E.nSalario) AS SalarioMinimo
FROM TDepartamentos D INNER JOIN TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

SELECT P.cNombreProyecto, COUNT(EP.nEmpleadoID) AS TotalEmpleados FROM TProyecto P
INNER JOIN TEmpleadoProyecto EP ON P.nProyectoID = EP.nProyectoID GROUP BY P.cNombreProyecto
HAVING COUNT(EP.nEmpleadoID) > 2;

SELECT * FROM TEmpleado WHERE cApellido LIKE 'G%';

SELECT * FROM TEmpleado ORDER BY nSalario DESC;

SELECT TOP 3 cNombre, cApellido, nSalario FROM TEmpleado ORDER BY nSalario DESC;

SELECT * FROM TEmpleado WHERE nEdad BETWEEN 25 AND 40;

SELECT COUNT(*) AS TotalEmpleadosActivos FROM TEmpleado WHERE bActivo = 1;

SELECT COUNT(*) AS TotalProyectos FROM TProyecto;

-- PARTE VII

ALTER TABLE TEmpleado DROP CONSTRAINT CK_Edad;

ALTER TABLE TEmpleado DROP CONSTRAINT UQ_cEmail;

ALTER TABLE TEmpleado ADD CONSTRAINT CK_Edad CHECK (nEdad BETWEEN 18 AND 65);

ALTER TABLE TEmpleado ADD CONSTRAINT UQ_cEmail UNIQUE (cEmail);

DROP TABLE TEmpleadoProyecto;

DROP TABLE TProyecto;

DROP TABLE TEmpleado;

DROP TABLE TCargo;

DROP TABLE TDepartamentos;

USE master;
GO

ALTER DATABASE EmpresaSQL SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE EmpresaSQL;
GO

-- Parte VIII. Desafíos Adicionales

CREATE TABLE TCliente (
    nClienteID INT IDENTITY(1,1),
    cNIF VARCHAR(14) UNIQUE NOT NULL,
    cNombre NVARCHAR(100) NOT NULL,
    cApellido NVARCHAR(100) NOT NULL,
    cEmail NVARCHAR(150) UNIQUE,
    cTelefono VARCHAR(20),
    cDireccion NVARCHAR(255),
    dFechaRegistro DATETIME DEFAULT GETDATE(),
    bActivo BIT DEFAULT 1,
    CONSTRAINT PK_nClienteID PRIMARY KEY (nClienteID)
);

CREATE TABLE TMetodoPago (
    nMetodoPagoID INT IDENTITY(1,1),
    cNombreMetodo NVARCHAR(50) UNIQUE NOT NULL,
    CONSTRAINT PK_nMetodoPagoID PRIMARY KEY (nMetodoPagoID)
);

INSERT INTO TMetodoPago (cNombreMetodo) 
VALUES ('Efectivo'), ('Tarjeta de Crédito'), ('Transferencia Bancaria');

CREATE TABLE TVenta (
    nVentaID INT IDENTITY(1,1),
    nClienteID INT NOT NULL,
    nMetodoPagoID INT NOT NULL,
    dFechaVenta DATETIME DEFAULT GETDATE(),
    nMontoTotal DECIMAL(10,2) NOT NULL,
    cEstado VARCHAR(20) DEFAULT 'Pagada',
    CONSTRAINT PK_nVentaID PRIMARY KEY (nVentaID),
    CONSTRAINT FK_TVenta_Cliente FOREIGN KEY (nClienteID) REFERENCES TCliente(nClienteID),
    CONSTRAINT FK_TVenta_MetodoPago FOREIGN KEY (nMetodoPagoID) REFERENCES TMetodoPago(nMetodoPagoID),
    CONSTRAINT CK_MontoVenta CHECK (nMontoTotal > 0),
    CONSTRAINT CK_EstadoVenta CHECK (cEstado IN ('Pagada', 'Pendiente', 'Anulada'))
);

INSERT INTO TCliente (cNIF, cNombre, cApellido, cEmail, cTelefono, cDireccion)
VALUES 
('C001', 'Alejandro', 'Rivas', 'arivas@mail.com', '8888-0001', 'Managua'),
('C002', 'Beatriz', 'Salgado', 'bsalgado@mail.com', '8888-0002', 'Masaya'),
('C003', 'Carlos', 'Mendoza', 'cmendoza@mail.com', '8888-0003', 'Granada'),
('C004', 'Diana', 'Castillo', 'dcastillo@mail.com', '8888-0004', 'León'),
('C005', 'Eduardo', 'Blanco', 'eblanco@mail.com', '8888-0005', 'Estelí'),
('C006', 'Fernanda', 'Rojas', 'frojas@mail.com', '8888-0006', 'Managua'),
('C007', 'Gustavo', 'Pineda', 'gpineda@mail.com', '8888-0007', 'Rivas'),
('C008', 'Hilda', 'Suárez', 'hsuarez@mail.com', '8888-0008', 'Jinotepe'),
('C009', 'Ignacio', 'López', 'ilopez@mail.com', '8888-0009', 'Matagalpa'),
('C010', 'Julia', 'Morales', 'jmorales@mail.com', '8888-0010', 'Managua'),
('C011', 'Kevin', 'Duarte', 'kduarte@mail.com', '8888-0011', 'Masaya'),
('C012', 'Lorena', 'Campos', 'lcampos@mail.com', '8888-0012', 'León'),
('C013', 'Mario', 'Vega', 'mvega@mail.com', '8888-0013', 'Granada'),
('C014', 'Nadia', 'Ortiz', 'nortiz@mail.com', '8888-0014', 'Estelí'),
('C015', 'Oscar', 'Navarro', 'onavarro@mail.com', '8888-0015', 'Managua'),
('C016', 'Patricia', 'Luna', 'pluna@mail.com', '8888-0016', 'Rivas'),
('C017', 'Quintín', 'Soto', 'qsoto@mail.com', '8888-0017', 'Jinotepe'),
('C018', 'Raquel', 'Guzmán', 'rguzman@mail.com', '8888-0018', 'Matagalpa'),
('C019', 'Samuel', 'Herrera', 'sherrera@mail.com', '8888-0019', 'Managua'), 
('C020', 'Teresa', 'Arias', 'tarias@mail.com', '8888-0020', 'Masaya');     

INSERT INTO TVenta (nClienteID, nMetodoPagoID, dFechaVenta, nMontoTotal, cEstado)
VALUES 
(1, 1, '2024-01-10', 150.00, 'Pagada'), (2, 2, '2024-01-12', 300.50, 'Pagada'),
(3, 3, '2024-01-15', 450.00, 'Pendiente'), (4, 1, '2024-01-20', 120.00, 'Pagada'),
(5, 2, '2024-02-05', 800.00, 'Pagada'), (6, 3, '2024-02-10', 250.75, 'Pendiente'),
(7, 1, '2024-02-14', 60.00, 'Pagada'), (8, 2, '2024-02-18', 950.00, 'Pagada'),
(9, 3, '2024-03-01', 1100.00, 'Pendiente'), (10, 1, '2024-03-05', 45.00, 'Pagada'),
(11, 2, '2024-03-12', 330.00, 'Pagada'), (12, 3, '2024-03-20', 410.25, 'Pagada'),
(13, 1, '2024-04-02', 15.50, 'Pendiente'), (14, 2, '2024-04-08', 500.00, 'Pagada'),
(15, 3, '2024-04-15', 750.00, 'Pagada'), (16, 1, '2024-04-22', 85.00, 'Pagada'),
(17, 2, '2024-05-01', 1200.00, 'Pendiente'), (18, 3, '2024-05-10', 640.00, 'Pagada'),
(1, 2, '2024-05-15', 200.00, 'Pagada'), (2, 3, '2024-05-20', 180.00, 'Pagada'),
(3, 1, '2024-06-05', 90.00, 'Pagada'), (4, 2, '2024-06-11', 400.00, 'Pendiente'),
(5, 3, '2024-06-18', 550.00, 'Pagada'), (6, 1, '2024-07-02', 75.00, 'Pagada'),
(7, 2, '2024-07-09', 310.00, 'Pagada'), (8, 3, '2024-07-14', 1050.00, 'Pendiente'),
(9, 1, '2024-07-22', 50.00, 'Pagada'), (10, 2, '2024-08-01', 600.00, 'Pagada'),
(11, 3, '2024-08-08', 720.00, 'Pagada'), (12, 1, '2024-08-15', 130.00, 'Pagada'),
(13, 2, '2024-08-25', 280.00, 'Pendiente'), (14, 3, '2024-09-03', 490.00, 'Pagada'),
(15, 1, '2024-09-10', 65.00, 'Pagada'), (16, 2, '2024-09-18', 880.00, 'Pagada'),
(17, 3, '2024-09-25', 1300.00, 'Pendiente'), (18, 1, '2024-10-02', 40.00, 'Pagada'),
(1, 3, '2024-10-10', 500.00, 'Pagada'), (2, 1, '2024-10-15', 110.00, 'Pagada'),
(3, 2, '2024-10-22', 270.00, 'Pagada'), (4, 3, '2024-11-05', 820.00, 'Pendiente'),
(5, 1, '2024-11-12', 95.00, 'Pagada'), (6, 2, '2024-11-19', 340.00, 'Pagada'),
(7, 3, '2024-11-26', 610.00, 'Pagada'), (8, 1, '2024-12-01', 80.00, 'Pagada'),
(9, 2, '2024-12-08', 450.00, 'Pendiente'), (10, 3, '2024-12-15', 990.00, 'Pagada'),
(11, 1, '2024-12-20', 105.00, 'Pagada'), (12, 2, '2024-12-24', 530.00, 'Pagada'),
(13, 3, '2024-12-28', 770.00, 'Pendiente'), (14, 1, '2024-12-30', 25.00, 'Pagada');

UPDATE TVenta SET nMontoTotal = nMontoTotal * 1.05 WHERE cEstado = 'Pendiente';

DELETE FROM TCliente
WHERE nClienteID NOT IN (SELECT DISTINCT nClienteID FROM TVenta);

SELECT TOP 5 
    C.cNombre, 
    C.cApellido, 
    SUM(V.nMontoTotal) AS TotalComprado
FROM TCliente C
INNER JOIN TVenta V ON C.nClienteID = V.nClienteID
GROUP BY C.cNombre, C.cApellido
ORDER BY TotalComprado DESC;

SELECT 
    YEAR(dFechaVenta) AS Anio, 
    MONTH(dFechaVenta) AS Mes, 
    COUNT(nVentaID) AS CantidadVentas,
    SUM(nMontoTotal) AS IngresoTotal
FROM TVenta
GROUP BY YEAR(dFechaVenta), MONTH(dFechaVenta)
ORDER BY Anio DESC, Mes DESC;

SELECT 
    C.cNombre, 
    C.cApellido, 
    AVG(V.nMontoTotal) AS PromedioGastoPorVenta
FROM TCliente C
INNER JOIN TVenta V ON C.nClienteID = V.nClienteID
GROUP BY C.cNombre, C.cApellido
ORDER BY PromedioGastoPorVenta DESC;

SELECT 
    V.nVentaID,
    C.cNombre + ' ' + C.cApellido AS NombreCliente,
    V.dFechaVenta,
    V.nMontoTotal,
    MP.cNombreMetodo AS MetodoDePago,
    V.cEstado
FROM TVenta V
INNER JOIN TCliente C ON V.nClienteID = C.nClienteID
INNER JOIN TMetodoPago MP ON V.nMetodoPagoID = MP.nMetodoPagoID
ORDER BY V.dFechaVenta DESC;



