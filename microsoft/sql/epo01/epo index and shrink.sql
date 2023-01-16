use ePO_TQARSVW16EPO01
checkpoint

-- Para ver tamaños de files
exec sp_helpfile

-- Shrink de Database
DBCC SHRINKDATABASE(N'ePO_TQARSVW16EPO01' )
GO

-- Shrink de un File puntual, LOG en este caso, a un valor de 200MB
DBCC SHRINKFILE(ePO_TQARSVW16EPO01_log, 200);
GO
