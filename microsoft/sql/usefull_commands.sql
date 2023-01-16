-- Muestra la collation del servidor
SELECT CONVERT (varchar(256), SERVERPROPERTY('collation'));


-- Identify Collation for a SQL Server database
DECLARE @DatabaseName as SYSNAME
SET @DatabaseName = 'ONILSA2017'  --Replace Database Name Here...
SELECT 
 DB_NAME(DB_ID(@DatabaseName)) AS DatabaseName
,DATABASEPROPERTYEX(@DatabaseName, 'Collation') AS CollationUsedBySQLServerDatabase
GO

-- BO Quick Health General
sp_Blitz;
GO

-- BO Quick Health con skip para Sharepoint y Dynamics, no chequea DB Object y trigers
EXEC sp_Blitz @CheckUserDatabaseObjects = 0;

-- BO Quick Health solamente las mas importante
EXEC sp_Blitz @IgnorePrioritiesAbove = 50;

-- BO BlitzIndex chequea todos los indices de todas las bases
sp_BlitzIndex @GetAllDatabases = 1;
GO

-- Muestra todas las collations de todas las bases de datos
SELECT name, collation_name
FROM sys.databases

-- Server version
Select @@version

-- Chequea la integridad de la base de datos
DBCC CHECKDB ('master')
DBCC CHECKDB ('model')
DBCC CHECKDB ('msdb')

-- Cambia parametro TARGET RECOVERY TIME
USE ONILSA
ALTER DATABASE ONILSA SET TARGET_RECOVERY_TIME = 60 SECONDS; 