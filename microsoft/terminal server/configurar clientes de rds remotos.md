- Dar permisos de administrador al ususario que va a utilizar softclarity remotamente
- Importar el archivo "CurrentUserSoftclarity.reg" a la registry para crear valores
- Se restaura desde sesión CMD con Run As Administrator 
```
REG RESTORE "HKCU\Software\VB and VBA Program Settings\OE\INICIO" SoftclarityCurrentUserSettingsINICIO.hiv
```
- Instalar desde la sesion del usuario la impresora a utilizar y dejarla como preferida. Se da como ejemplo la de DESARROLLO 
```
\\TQ\netlogon\tqtools\Addprinter.bat TQARPTR02
```
- Share del folder "Documents" para cuando quieran exportar files.
	Desde CMD As Administrator:
```
	NET SHARE SC-%USERNAME%=%USERPROFILE%\Documents /REMARK:"%USERNAME% Softclarity Docs" /GRANT:TQ\%USERNAME%,CHANGE
```
- Usuario y clave de testing: audit / audit
- URL para remote Desktop Apps en Windows 10: https://rds.tqcorp.com/rdweb/feed/webfeed.aspx

- Configuración de Remote Desktop desde TS01: Server Manager / Remote Desktop Services / Collections / Collection01 // En la lista de Remote Apps, Softclarity / Right Click / User Assignment - Agregar el usuario - Apply / OK
- Configuración de Acceso desde el Client: .- En Windows 10, descargar de Microsoft Store "Remote Desktop Services". Si por algun motivo no se logra, acceder vía Web

- Configuración de Acceso desde el Client - Ocpión WEB: .- Utilizar Microsoft Edge, Crear Bookmark a https://tqarsvw16ts01/RDWeb
copiar Softclarity.lnk a Desktop en la TERMINAL del USUARIO del usuario
POR EJEMPLO: copy 
```
\\tqarsvw16ts01\c$\Temp.TS01\Softclarity\Softclarity.lnk \\TQARWSW1023\C$\Users\EVONSCHMELING\Desktop
```
