USE base_consorcioPI;

-- se necesita tener una instancia MIXTA para realizar esto
-- Crear dos usuarios de base de datos:
CREATE LOGIN UsuarioAdmin WITH PASSWORD = 'pwAdmin';
CREATE LOGIN UsuarioSoloLectura WITH PASSWORD = 'pwSoloLectura';



--Asignar permisos al usuario de administrador:
CREATE USER UsuarioAdmin FOR LOGIN UsuarioAdmin;
ALTER ROLE db_owner ADD MEMBER UsuarioAdmin;

--Asignar permisos al usuario de solo lectura:
CREATE USER UsuarioSoloLectura FOR LOGIN UsuarioSoloLectura;
GRANT EXECUTE TO UsuarioSoloLectura;


--damos acceso al usuario de solo lectura al procedimiento
GRANT EXECUTE ON dbo.procedimiento_insert_administrador TO UsuarioSoloLectura;


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
EXEC procedimiento_insert_administrador;
REVERT; 

--insercion con procedimiento
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC procedimiento_insert_administrador; --si podra ejecutarlo porque tiene permiso de ejecucion
REVERT; 

-- Revocar permiso de ejecución del procedimiento almacenado
REVOKE EXECUTE ON dbo.procedimiento_insert_administrador FROM UsuarioSoloLectura; 

--insercion con procedimiento
EXECUTE AS LOGIN = 'UsuarioSoloLectura'; 
EXEC procedimiento_insert_administrador; --ya no podra ejecutarlo porque le quitamos el permiso
REVERT; 
