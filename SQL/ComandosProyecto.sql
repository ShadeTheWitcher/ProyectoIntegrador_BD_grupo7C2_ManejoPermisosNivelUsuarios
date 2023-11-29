USE base_consorcioPI;

-------------------------------------- Creamos Usuarios Y Agregamos Permisos ------------------------------------------

-- Se necesita tener una instancia MIXTA para realizar esto
-- Crear dos usuarios de servidor SQL Server:
CREATE LOGIN UsuarioAdmin WITH PASSWORD = 'pwAdmin';
CREATE LOGIN UsuarioSoloLectura WITH PASSWORD = 'pwSoloLectura';


--Crea usuario dentro de la base consorcio
CREATE USER UsuarioAdmin FOR LOGIN UsuarioAdmin;
--Asignar permisos al usuario de administrador:
ALTER ROLE db_owner ADD MEMBER UsuarioAdmin;


--Crea usuario dentro de la base consorcio
CREATE USER UsuarioSoloLectura FOR LOGIN UsuarioSoloLectura;
--Asignar permisos al usuario de solo lectura:
ALTER ROLE db_datareader ADD MEMBER UsuarioSoloLectura;


--Creado previamente el procedimiento almacenado
--Damos acceso al usuario de solo lectura al procedimiento
GRANT EXECUTE ON dbo.InsertarAdministrador TO UsuarioSoloLectura;

------------------------------------------------------------------------------------------------------------------------

------------------------------------------------ Prueba de Permisos ----------------------------------------------------
-- Inserción con el usuario de administrador
EXECUTE AS LOGIN = 'UsuarioAdmin'; --Execute as login se usa para ejecutar usando permisos especiales
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Palermo Alejandro', 'N', '123996', 'M', GETDATE());
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Bianchi Roberto', 'S', '128856', 'M', GETDATE());
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Roman Anacleto', 'S', '177456', 'M', GETDATE());
REVERT; --REVERT en SQL Server se utiliza para volver al contexto de seguridad original


--Insercion con procedimiento Admin
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'Romero Agustina', 'S', 3794222222, 'F', '19920828';
REVERT; 


-- Inserción con el usuario de solo lectura sin proceso almacenado
EXECUTE AS LOGIN = 'UsuarioSoloLectura';
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Schiavi Laura', 'S', '111456', 'F', GETDATE()); -- NO PODRA HACERLO 
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Abbondanzieri Carlos', 'N', '144456', 'M', GETDATE()); -- NO PODRA HACERLO 
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Schelotto Oscar', 'S', '123356', 'M', GETDATE()); -- NO PODRA HACERLO 
REVERT;

--Insercion con procedimiento Solo lectura
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'Cavani Agusto', 'S', 3794222222, 'M', '19920828'; --Si podra hacerlo
REVERT; 

--Comprobamos inserción
Select * from administrador
WHERE apeynom LIKE ('Cavani%')


-- Revocar permiso de ejecución del procedimiento almacenado
REVOKE EXECUTE ON dbo.InsertarAdministrador FROM UsuarioSoloLectura; 


--Insercion con procedimiento con el permiso revocado
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'Benedetto Anastasia', 'S', 3794244222, 'M', '19920828'; --Ya no podra ejecutarlo porque le quitamos el permiso
REVERT; 
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------ Aplicamos TRIGGERS ----------------------------------------------------

--Creamos la tabla AUDITORIA para la utilización de TRIGGER

--Creamos TRIGGER para administrador

--Probamos TRIGGER 

--Insertamos registros con el Administrador
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'Messi Hernesto', 'S', 3794222665, 'M', '19920828';
REVERT; 

--Insertamos registros con el Usuario de sólo lectura
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'Martinez Rogelio', 'S', 3794444222, 'M', '19920828'; 
REVERT; 

--Visualizamos resultados
Select * from auditoria
----------------------------------------------------------------------------------------------------------------------


------------------------------------------------- Prueba con VISTAS --------------------------------------------------
--Creamos otro usuario para probar
CREATE LOGIN UsuarioVista WITH PASSWORD = 'pwVista';
CREATE USER UsuarioVista FOR LOGIN UsuarioVista;


--Otrogamos permiso de select en la tabla admin
GRANT SELECT ON dbo.administrador TO UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --Comprobamos que puede usar select en administrador
REVERT;


--Revocamos los permisos directos de SELECT en la tabla administrador para evitar que el usuario acceda directamente a ella.
REVOKE SELECT ON dbo.administrador FROM UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --Comprobamos que no puede usar select en administrador
REVERT;


-- Creamos una vista que permitira que solo se visualize las columnas especificadas
CREATE VIEW dbo.VistaAdministrador AS
SELECT idadmin, apeynom, tel, sexo, fechnac
FROM dbo.administrador;

--Otorgamos permisos SELECT al usuario en la vista creada, permitiéndole consultar datos a través de esta vista.
GRANT SELECT ON dbo.VistaAdministrador TO UsuarioVista;

--Probamos la vista
EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * FROM dbo.VistaAdministrador; --Aparecera la vista que creamos antes
REVERT;

--Probamos nuevamente el SELECT sin la vista creada
EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --Comprobamos que no puede usar select en administrador
REVERT;
----------------------------------------------------------------------------------------------------------------------

