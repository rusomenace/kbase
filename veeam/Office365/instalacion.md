# Veeam for office 365

Ref: https://www.veeam.com/free-backup-microsoft-office-365.html

## Caracteristicas

- FREE backup for Microsoft 365 (Office 365)
- Up to 10 users and 1TB of SharePoint data
- No feature limitations
- Se puede instalar en el mismo servidor de Veeam Backup & Replication

Documentacion formal de isntalacion y manejo: https://helpcenter.veeam.com/docs/vbo365/guide/configuration.html?ver=60

## Notas de instalacion

- La instalacion de la aplicacion es un clasico next next next
- El repositorio para respaldo debe ser un disco fisico, un arreglo de discos, una LUN FC o iscsi, no soporta mapeos de red del estilo de \\
- A la hora de registrar un tenant es conveniente registrar la aplicacion de cero, para eso se debe seguir el paso a paso y crear un certificado para que sea validado en azure
- El metodo de validacion consiste en abrir una pagina web y colocar una clave, posteriormente se debera logear al tenant para permitir crear la aplicacion
- Si se quiere usar una aplicacion existente se debera ingresar al 
  
    ```
    azure active directory
    applications
    app registrations
    ```
- Se recomienda usar un nombre descriptivo para la aplicacion
- De querer registrar la aplicacion manualmente esa es la ubicacion

*Nota: Los puntos de restauracion no se manejan en la tarea si no en el repositorio mismo*