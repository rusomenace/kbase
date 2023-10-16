# Implementacion on Prem de LAPS

- [Que es Windows LAPS?](https://learn.microsoft.com/es-es/windows-server/identity/laps/laps-overview)
- [Video sintetizado](https://www.youtube.com/watch?v=iI1XA2G420U&t=604s)
- [Descargas en MS](https://www.microsoft.com/en-us/download/details.aspx?id=46899)

## Notas importantes
- La instalacion de LAPS requiere permisos de modificacion del esquema de Active Directory
- La instalacion del modulo de LAPS requiere que los servidores o estaciones de trabajo involucradas reinicien minimamente 1 vez y puede que hasta 2
- El deploy de LAPS es via GPO

## Implementacion

1
Realizar instalacion completa de LAPS en el controlador de dominio. Cuando se dice completa es elegir todos los componentes en wizard de instalacion.
El archivo necesario para servidores y estaciones de trabajo de 64 bits es: LAPS.x64.msi