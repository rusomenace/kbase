# Como instalar .Net 3.5 offline en Windows server

Conectar la unidad de DVD y montar la iso de windows.
La misma deberá conectarse en la unidad D, En caso de montarse en una unidad diferente cambiar la ruta de destino en los pasos siguientes.


## Metodo 1
Abrir powershell como administrador y ejecutar:
´´´´
Dism /online /enable-feature /featurename:NetFX3 /All /Source:D:\sources\sxs /LimitAccess
´´´
## Metodo 2
´´´
Enable-WindowsOptionalFeature –Online –FeatureName NetFx3 –All -LimitAccess -Source D:\sources\sxs
´´´
## Metodo
Utilizar el instalador offiline en la siguiente ruta:
´´´
\\software\d$\Software\Microsoft\.Net Framework\
´´´

## Verificar si está instalado
´´´
Get-WindowsFeature Net-Framework-Core
´´´