-- Database backup
BACKUP DATABASE ONILSA2017
TO DISK = 'W:\Temp\ONILSA2017.bak'
GO

-- Database log backup
USE ONILSA
GO
BACKUP LOG ONILSA2017 TO DISK = 'W:\Temp\ONILSA2017_Log.trn'
GO

-- Database log shrink
USE ONILSA2017
GO
DBCC SHRINKFILE('ONILSA_Log', 1)
GO

-- Muestra los nombres de los archivos de la DB
USE ONILSA
GO
EXEC sp_helpfile
GO
