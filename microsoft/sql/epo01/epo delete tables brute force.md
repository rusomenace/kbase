## Destroy events Orion
```
DELETE FROM dbo.OrionSnapshot
```

## Destroy events DLP
```
TRUNCATE TABLE dbo.EPOProductEventsMT
GO
```

## Shrink de un File puntual, LOG en este caso, a un valor de 200MB
```
DBCC SHRINKFILE(ePO_TQARSVW16EPO01_log, 200);
GO
```
