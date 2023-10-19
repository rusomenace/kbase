# Como configurar el cliente de Soft Clarity

1.Dar permisos de administrador al ususario que va a utilizar softclarity remotamente


4.Instalar desde la sesion del usuario la impresora a utilizar y dejarla como preferida. Se da como ejemplo la de DESARROLLO 
	\\TQ\netlogon\tqtools\Addprinter.bat TQARPTR02

4.1 Share del folder "Documents" para cuando quieran exportar files.
	Logueado en TS01 como el usuario nuevo, desde CMD As Administrator:
	NET SHARE SC-%USERNAME%=%USERPROFILE%\Documents /REMARK:"%USERNAME% Softclarity Docs" /GRANT:TQ\%USERNAME%,CHANGE



Desde la VM del usuario, ejecutar: 
	\\software\Software\SoftClarity\RDP\RDPDeploy.bat
	
	UTILIZAR los Acceeoss directora que se acaban de copiar el Desktop del PROFILE del usuario de la VM