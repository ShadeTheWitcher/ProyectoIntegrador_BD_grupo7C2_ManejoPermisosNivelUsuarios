--CREATE DATABASE base_consorcioPI;
go
-- USE base_consorcioPI;
go
-------------------
if object_id('gasto') is not null DROP TABLE gasto;
go
---------------------
if object_id('consorcio') is not null DROP TABLE consorcio
go
---------------------
if object_id('localidad') is not null DROP TABLE localidad
go
---------------------
if object_id('provincia') is not null DROP TABLE provincia
go
---------------------
if object_id('zona') is not null DROP TABLE zona
go
---------------------
if object_id('conserje') is not null DROP TABLE conserje
go
---------------------
if object_id('administrador') is not null DROP TABLE administrador
go
---------------------
if object_id('tipogasto') is not null DROP TABLE tipogasto
go
---------------------

Create table provincia (idprovincia int primary key, 
					    descripcion varchar(50),
						km2 int,
						cantdptos int,
						poblacion int,
						nomcabe varchar(50))
go
-------------------

Create table localidad (idprovincia int, 
						idlocalidad int, 
					    descripcion varchar(50),
					    Constraint PK_localidad PRIMARY KEY (idprovincia, idlocalidad),
						Constraint FK_localidad_pcia FOREIGN KEY (idprovincia)  REFERENCES provincia(idprovincia)						 					     					     					     				     					     
						)
go
-------------------

Create table zona		(idzona int identity primary key, 
					    descripcion varchar(50))
go
-------------------

Create table conserje	(idconserje int identity primary key, 
					     apeynom varchar(50),
					     tel varchar(20),
						 fechnac datetime,
					     estciv varchar(1)  NULL default ('S') 
						 CONSTRAINT CK_estadocivil CHECK (estciv IN ('S', 'C','D','O')),
							 	)
go
-------------------

Create table administrador	(idadmin int identity primary key, 
					     apeynom varchar(50),
					     viveahi varchar(1)  NULL default ('N') 
						 CONSTRAINT CK_habitante_viveahi CHECK (viveahi IN ('S', 'N')),
					     tel varchar(20),
					     sexo varchar(1)  NOT NULL 
						 CONSTRAINT CK_sexo CHECK (sexo IN ('F', 'M')),
                         fechnac datetime)

go
-------------------

Create table tipogasto	(idtipogasto int primary key, 
					    descripcion varchar(50))
go
-------------------

Create table consorcio	(idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
					     nombre varchar(50),
					     direccion varchar(250),					     
					     idzona int,	
						 idconserje int,	
						 idadmin int,	
					     Constraint PK_consorcio PRIMARY KEY (idprovincia, idlocalidad,idconsorcio),
						 Constraint FK_consorcio_pcia FOREIGN KEY (idprovincia,idlocalidad)  REFERENCES localidad(idprovincia,idlocalidad),
						 Constraint FK_consorcio_zona FOREIGN KEY (idzona)  REFERENCES zona(idzona),						 					     					     					     				     					     
						 Constraint FK_consorcio_conserje FOREIGN KEY (idconserje)  REFERENCES conserje(idconserje),
						 Constraint FK_consorcio_admin FOREIGN KEY (idadmin)  REFERENCES administrador(idadmin)						 					     					     					     				     					     						 						 						 					     					     					     				     					     						 
							)
go
-------------------

Create table gasto	(
						idgasto int identity,
						idprovincia int,
                         idlocalidad int,
                         idconsorcio int, 
					     periodo int,
					     fechapago datetime,					     
						 idtipogasto int,
						 importe decimal (8,2),	
					     Constraint PK_gasto PRIMARY KEY (idgasto),
						 Constraint FK_gasto_consorcio FOREIGN KEY (idprovincia,idlocalidad,idconsorcio)  REFERENCES consorcio(idprovincia,idlocalidad,idconsorcio),
						 Constraint FK_gasto_tipo FOREIGN KEY (idtipogasto)  REFERENCES tipogasto(idtipogasto)					     					     						 					     					     
							)
go

-- se necesita tener una instancia MIXTA para realizar esto
-- Crear dos usuarios de base de datos:
CREATE LOGIN UsuarioAdmin WITH PASSWORD = 'pwAdmin';
CREATE LOGIN UsuarioSoloLectura WITH PASSWORD = 'pwSoloLectura';

--Asignar permisos al usuario de administrador:
USE base_consorcioPI;
CREATE USER UsuarioAdmin FOR LOGIN UsuarioAdmin;
ALTER ROLE db_owner ADD MEMBER UsuarioAdmin;

--Asignar permisos al usuario de solo lectura:
USE base_consorcioPI;
CREATE USER UsuarioSoloLectura FOR LOGIN UsuarioSoloLectura;
GRANT EXECUTE TO UsuarioSoloLectura;



--PROCEDIMIENTOS ALMACENADOS

USE base_consorcioPI; 

-- Crear un procedimiento almacenado
CREATE PROCEDURE InsertarAdministrador
    @apeynom varchar(50),
    @viveahi varchar(1),
    @tel varchar(20),
    @sexo varchar(1),
    @fechnac datetime
AS
BEGIN
    INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
    VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac);
END;

-- Ejecutar el procedimiento para insertar un nuevo administrador
EXEC InsertarAdministrador
    @apeynom = 'Nombre Apellido',
    @viveahi = 'S',
    @tel = '123456',
    @sexo = 'M',
    @fechnac = '2023-10-26 12:00:00'; 


-- procedimiento que inserta con datos aleatorios 
CREATE PROCEDURE InsertarAdministradorAleatorio (@NumeroDeInserciones int)
AS
BEGIN -- BEGIN marca el inicio de un bloque de codigo
    DECLARE @contador int = 0; -- se inicializa un contador

    WHILE @contador < @NumeroDeInserciones --itera hasta llegar a la cantidad deseada

    BEGIN 
        -- Generar valores aleatorios
        DECLARE @apeynom varchar(50);
        DECLARE @viveahi varchar(1);
        DECLARE @tel varchar(20);
        DECLARE @sexo varchar(1);
        DECLARE @fechnac datetime;

        SELECT
            @apeynom = 'Nombre' + CAST(ABS(CHECKSUM(NEWID())) % 100 AS varchar) + ' Apellido',
            @viveahi = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'S' ELSE 'N' END,
            @tel = CAST(ABS(CHECKSUM(NEWID())) AS varchar),
            @sexo = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'M' ELSE 'F' END,
            @fechnac = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Insertar en la tabla "administrador"
        INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac)
        VALUES (@apeynom, @viveahi, @tel, @sexo, @fechnac);

        SET @contador = @contador + 1;
    END;
END;

-- Insertar registros aleatorios con la cantidad asignada
EXEC InsertarAdministradorAleatorio @NumeroDeInserciones = 33;






--insertar regristros duplicado
DECLARE @apeynom varchar(50) = 'Nombre Apellido'; --esto son variables donde asignamos valores temporales
DECLARE @viveahi varchar(1) = 'S';
DECLARE @tel varchar(20) = '123456';
DECLARE @sexo varchar(1) = 'M';
DECLARE @fechnac datetime = '2023-10-26 12:00:00';
-- Insertar registros duplicados llamando al procedimiento varias veces
EXEC InsertarAdministrador @apeynom, @viveahi, @tel, @sexo, @fechnac;
EXEC InsertarAdministrador @apeynom, @viveahi, @tel, @sexo, @fechnac;



--damos acceso al usuario de solo lectura al procedimiento
GRANT EXECUTE ON dbo.InsertarAdministradorAleatorio TO UsuarioSoloLectura;
GRANT EXECUTE ON dbo.InsertarAdministrador TO UsuarioSoloLectura;



-- Inserción con el usuario de administrador
EXECUTE AS LOGIN = 'UsuarioAdmin'; --Execute as login se usa para ejecutar usando permisos especiales
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT; --REVERT en SQL Server se utiliza para volver al contexto de seguridad original


-- Inserción con el usuario de solo lectura a través del procedimiento almacenado
EXECUTE AS LOGIN = 'UsuarioSoloLectura';
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE()); -- NO PODRA HACERLO
REVERT;



--insercion con procedimiento
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministradorAleatorio @NumeroDeInserciones = 1;
REVERT; 

--insercion con procedimiento
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministradorAleatorio @NumeroDeInserciones = 1; --si podra ejecutarlo
REVERT; 
