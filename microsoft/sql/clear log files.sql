USE {database-name};  
GO  
-- Truncate the log by changing the database recovery model to SIMPLE.  
ALTER DATABASE {database-name}
SET RECOVERY SIMPLE;  
GO  
-- Shrink the truncated log file to 1 MB.  
DBCC SHRINKFILE ({database-file-name}, 1);  
GO  
-- Reset the database recovery model.  
ALTER DATABASE {database-name}
SET RECOVERY FULL;  
GO 


To find database file names use below query

select * from sys.database_files;