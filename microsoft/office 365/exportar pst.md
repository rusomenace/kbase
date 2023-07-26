# Exportar PST de un usuario dado de baja

* *Importante*: Para correr este proceso es necesario que la cuenta tenga permisos sobre eDiscovery (Permissions => Roles => eDiscovery Manager)

1. Ingresar a [la web de compliance de Microsoft 365](https://compliance.microsoft.com/) utilizando las credenciales de admin.
2. En la barra de la izquierda, dentro de la categoria **Solutions** acceder a **Content search**.
3. Click sobre **New Search** y comenzará el wizard donde nos solicitará un nombre para la busqueda. Allí colocamos el nombre de usuario al que extraeremos los datos y luego **Next**.
4. Luego en la ventana **Locations** seleccionar *Specific Locations* y habilitar el botón **Exchange Mailboxes**. Allí seleccionar **Choose user, groups or teams** y en la nueva ventana seleccionar el usuario al que debemos exportar sus correos y finalizamos con **Done** y continuamos con **Next**.
5. Aquí una parte importante. Dentro de **Define your search conditions** eliminar las *Keywords* utilizando el botón de delete a la derecha y se eliminará ese campo. Hacer click en **Add Condition** elegir **Type** y una nueva ventana de condiciones se deplegará. Tildar **E-Mail Messages** y luego **Next**.
6. Verificar que la información sea correcta y proseguir con **Submit**. Si todo resultó correcto, aparecerá el mensaje *New search created* y finalizamos el asistente.
7. Nuevamente en la ventana de *Content search* aparecerá nuestra busqueda que nos permitirá seguir con los pasos siguientes una vez que pase al estado *Completed*. Este proceso puede demorar algunos minutos.
8. Una vez finalizado, seleccionamos la busqueda que generamos anteriormente y hacemos click en **Actions** y luego **Export Results**.
9. Dejar las opciones por defecto en *Output options* y *Export Exchange content as*
10. Si todo resulta correcto, se visibilizará el mensaje *A job has been created*
11. Una vez que el status cambia a *Completed* ingresar a al tab **Export** y doble click sobre el usuario a exportar sus .pst
12. En la sección **Export key** click en **Copy to clipboard** y por ultimo click arriba en **Download Result**
13. Recordar correr este proceso desde MS Edge y de esta manera aparecerá una ventana a la que hay que abrir haciendo click en *open*. Una nueva ventana solicitará instalar una aplicación y procedemos con *Install*
14. En el primer campo **pegamos la llave** o key que copiamos previamente, seleccionamos la ruta donde deseamos guardar el archivo y click en *Start*
15. *eDiscovery Export Tool* realizará la exportación en el directorio que le hemos indicado y una vez finalizado debemos copiar la carpeta *usuario_Export* en [el siguiente directorio:](\\tqarsvw19fs01\d$\FileBackups\PST\O365Export) \\\tqarsvw19fs01\d$\FileBackups\PST\O365Export