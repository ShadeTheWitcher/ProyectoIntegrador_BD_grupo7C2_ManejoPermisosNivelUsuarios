Use Proyecto_base_consorcio;
--Crear Usuario para administrador
CREATE USER adminUser FOR LOGIN admin with DEfault_schema = db_owner;

--Crear Usuario para lectura
Create Login adminLectura WITH Password = 'admin';
CREATE USER adminReader FOR LOGIN adminLectura with DEfault_schema = db_datareader;

--Agregar Permisos:
--Lectura
GRANT SELECT ON SCHEMA::dbo TO adminReader;

--Administrador
EXEC sp_addrolemember 'db_owner', 'adminUser';

--Dar permiso sobre procedimiento al usuario con permiso de s�lo lectura
GRANT EXECUTE ON procedimiento_insert_administrador TO adminReader;


--Sector Pruebas:
-- Inserciones usuario administrador
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('GONZ�LEZ MAR�A', 'N', '3624251689', 'F', '19781111');
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('RUIZ JORGE', 'S', '3624252689', 'M', '19800404');
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('FERN�NDEZ ANA', 'N', '3624253689', 'F', '19750515');

-- Inserciones usuario lectura
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('L�PEZ JOS�', 'S', '3624254689', 'M', '19810225');
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('MART�NEZ RAQUEL', 'N', '3624255689', 'F', '19721009');
Insert into administrador(apeynom,viveahi,tel,sexo,fechnac) values ('S�NCHEZ PEDRO', 'S', '3624256689', 'M', '19830128');

Alter table administrador Add fechaNacimiento DATE;
Alter table administrador Drop column fechaNacimiento;

--Ejecuci�n del procedimiento almacenado para usuario de s�lo lectura
EXEC procedimiento_insert_administrador;
