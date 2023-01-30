# Como instalar MS Project

## Instalación

### Recomendaciones previas

Para evitar inconvenientes con el registro y el perfil del usuario, se deberá realizar la instalación con credenciales distintas a a las del usuario.
Por lo tanto, una buena manera de llevar a cabo la tarea es coordinar con el usuario para realizar la instalación cuando no se encuentre trabajando, ya que la VM solo soporta 1 sesión en simultaneo.

### Proceso de instalación
Desde la VM del usuario, descargar la siguiente carpeta completa en un directorio que prefiera dentro de la VM:
\\software\Software\Microsoft\Office365\Project 2016 X64\

* IMPORTANTE: No se debe ejecutar el instalador mediante la red, se debe copiar la carpeta y correr la instalación localmente

Lanzar CMD como administrador y ejecutar el script "setup.bat" que se encuentra en la carpeta de instalación *(en otras instalaciones como la de Visio es posible que en lugar de un .bat se encuentre un archivo .ps1 que se debe ejecutar con PowerShell)*

Comenzará el instalador. Puede demorar algunos minutos en finalizar la carga
* Nota: El instalador le solicitará cerrar las aplicaciones del paquete office que tenga abiertas como Outlook, Excel etc

## Activación
Una vez finalizada la instalación **NO** ejecutar el programa y abrir el archivo "Activacion.txt" que tambien se encuentra en la carpeta de instalación. Allí se encuentran las distintas alternativas de activación.

Ejecutar Project y verificar que ha sido activado correctamente desde File => Account => Product Activation. El resultado debe ser "Product Activated"