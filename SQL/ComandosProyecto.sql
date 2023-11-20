USE base_consorcioPI;

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


-- Inserción con el usuario de administrador
EXECUTE AS LOGIN = 'UsuarioAdmin'; --Execute as login se usa para ejecutar usando permisos especiales
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE());
REVERT; --REVERT en SQL Server se utiliza para volver al contexto de seguridad original


-- Inserción con el usuario de solo lectura sin proceso almacenado
EXECUTE AS LOGIN = 'UsuarioSoloLectura';
INSERT INTO administrador (apeynom, viveahi, tel, sexo, fechnac) VALUES ('Admin', 'S', '123456', 'M', GETDATE()); -- NO PODRA HACERLO 
REVERT;


--Insercion con procedimiento Admin
EXECUTE AS LOGIN = 'UsuarioAdmin'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
REVERT; 

--insercion con procedimiento Solo lectura
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828'; --si podra ejecutarlo
REVERT; 

-- Revocar permiso de ejecución del procedimiento almacenado
REVOKE EXECUTE ON dbo.InsertarAdministrador FROM UsuarioSoloLectura; 

--Insercion con procedimiento con el permiso revocado
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828'; --ya no podra ejecutarlo porque le quitamos el permiso
REVERT; 

--Creamos la tabla AUDITORIA para la utilización de TRIGGER

--Creamos TRIGGER para administrador

--Probamos TRIGGER 

	--Insertamos registros con el administrador
	EXECUTE AS LOGIN = 'UsuarioAdmin'; 
	EXEC InsertarAdministrador 'LOPEZ JUAN CARLOS', 'S', 3794222222, 'M', '19920828';
	REVERT; 

	--Visualizamos resultados
	Select * from auditoria

	--Insertamos registros con el usuario de sólo lectura
	EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
	EXEC InsertarAdministrador 'RONCAGLIA ALFREDO ALEJANDRO', 'S', 3794244222, 'M', '19220828'; --si podra ejecutarlo
	REVERT; 

	--Visualizamos resultados
	Select * from auditoria



--///////////////////   EJEMPLO CON VISTAS  ////////////////////////---

--Creamos otro usuario para probar
CREATE LOGIN UsuarioVista WITH PASSWORD = 'pwVista';
CREATE USER UsuarioVista FOR LOGIN UsuarioVista;



--Otrogamos permiso de select en la tabla admin
GRANT SELECT ON dbo.administrador TO UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --comprobamos que puede usar select en administrador
REVERT;




--Revocamos los permisos directos de SELECT en la tabla administrador para evitar que el usuario acceda directamente a ella.
REVOKE SELECT ON dbo.administrador FROM UsuarioVista;

EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * from administrador --comprobamos que no puede usar select en administrador
REVERT;




-- Creamos una vista que permitira que solo se visualize las columnas especificadas
CREATE VIEW dbo.VistaAdministrador AS
SELECT idadmin, apeynom, tel, sexo, fechnac
FROM dbo.administrador;

--Otorgamos permisos SELECT al usuario en la vista creada, permitiéndole consultar datos a través de esta vista.
GRANT SELECT ON dbo.VistaAdministrador TO UsuarioVista;

--Probamos la vista
EXECUTE AS LOGIN = 'UsuarioVista'; 
SELECT * FROM dbo.VistaAdministrador; --aparecera la vista que creamos antes
REVERT;


