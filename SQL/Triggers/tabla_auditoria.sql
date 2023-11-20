USE base_consorcioPI
go


CREATE TABLE auditoria (
    id_auditoria int identity primary key,
    tabla_afectada varchar(100),  
	columna_afectada varchar(100), 
    accion varchar(10),           
    fecha_hora datetime,          
    usuario varchar(50),        
    valor_anterior varchar(max),  
    valor_actual varchar(max),     
);