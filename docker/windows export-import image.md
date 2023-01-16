# Para exportar
	docker save -o c:\images\aspnet.tar mcr.microsoft.com/dotnet/framework/aspnet:latest
	docker save -o c:\images\iis.tar mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

# Para importar copiar las imagenes en .tar a la carpeta en server destino
	docker load -i aspnet.tar
	docker load -i iis.tar