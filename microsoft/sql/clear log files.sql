-- Declare database name in variable
DECLARE @DatabaseName NVARCHAR(100) = 'Supervielle';

-- Truncate the log by changing the database recovery model to SIMPLE.  
ALTER DATABASE Supervielle  
SET RECOVERY SIMPLE;  
GO  
-- Shrink the truncated log file to 1 MB.  
DBCC SHRINKFILE (Supervielle_Log, 1);  
GO  
-- Reset the database recovery model.  
ALTER DATABASE Supervielle
SET RECOVERY FULL;  
GO  

-- Declare database name in variable
DECLARE @DatabaseName NVARCHAR(100) = 'Supervielle';

-- Display log file name / location / size / disk size
SELECT
    name AS 'LogFileName',
    physical_name AS 'LogFilePath',
    size * 8 / 1024.0 AS 'LogFileSize_GB',
    CAST(ROUND(FILEPROPERTY(name, 'SpaceUsed') * 8 / 1024.0, 2) AS DECIMAL(10, 2)) AS 'PhysicalSize_GB'
FROM
    sys.master_files
WHERE
    type = 1 -- Log files
    AND database_id = DB_ID(@DatabaseName);

