USE [base_consorcioPI]
GO
/****** Object:  Trigger [dbo].[tradministradorInsert]    Script Date: 18/11/2023 23:25:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tradministradorInsert]
   ON  [dbo].[administrador]
   AFTER Insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET NOCOUNT ON;

	-- Insert statements for trigger here
	INSERT INTO dbo.auditoria(tabla_afectada, columna_afectada, valor_Anterior, valor_actual, usuario, fecha_hora, accion)
	SELECT 'dbo.administrador','idadmin', NULL, inserted.idadmin, SYSTEM_USER, CURRENT_TIMESTAMP, 'Insert' FROM inserted;

	INSERT INTO dbo.auditoria(tabla_afectada, columna_afectada, valor_Anterior, valor_actual, usuario, fecha_hora, accion)
	SELECT 'dbo.administrador','apeynom', NULL, inserted.apeynom, SYSTEM_USER, CURRENT_TIMESTAMP, 'Insert' FROM inserted;

	INSERT INTO dbo.auditoria(tabla_afectada, columna_afectada, valor_Anterior, valor_actual, usuario, fecha_hora, accion)
	SELECT 'dbo.administrador','viveahi', NULL, inserted.viveahi, SYSTEM_USER, CURRENT_TIMESTAMP, 'Insert' FROM inserted;

	INSERT INTO dbo.auditoria(tabla_afectada, columna_afectada, valor_Anterior, valor_actual, usuario, fecha_hora, accion)
	SELECT 'dbo.administrador','tel', NULL, inserted.tel, SYSTEM_USER, CURRENT_TIMESTAMP, 'Insert' FROM inserted;

	INSERT INTO dbo.auditoria(tabla_afectada, columna_afectada, valor_Anterior, valor_actual, usuario, fecha_hora, accion)
	SELECT 'dbo.administrador','sexo', NULL, inserted.sexo, SYSTEM_USER, CURRENT_TIMESTAMP, 'Insert' FROM inserted;

	INSERT INTO dbo.auditoria(tabla_afectada, columna_afectada, valor_Anterior, valor_actual, usuario, fecha_hora, accion)
	SELECT 'dbo.administrador','fechnac', NULL, inserted.fechnac, SYSTEM_USER, CURRENT_TIMESTAMP, 'Insert' FROM inserted;
    

END

