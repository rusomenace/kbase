# Como restablecer la sincronizacion de los mails con flags en outlook para que se visualicen en la seccion To Do en teams:
> Para realizar esta tarea se debe habilitar el acceso web de Microsoft 365 para el usuario. En [Exchange Admin Center](https://admin.exchange.microsoft.com/#/mailboxes) ingresar a **Recipients**, **Mailboxes** y seleccionar el usuario.
> Seleccionarlo e ingresar a la opción **Manage email apps settings**. Habilitar las opciones **Mobile (Exchange ActiveSync)** y **Outlook on the web** y click en Save.

- Cerrar el outlook y Teams
- Ingresar a la interfaz web de To-Do (https://outlook.office.com/tasks/)
- Click en la rueda de opciones
- To Do Settings
- Se desactiva "Flagged email"
- Click en el botón "Sync"
- Volver a abrir las settings de To Do y habilitar nuevamente "Flagged Emails"
- Click nuevamente en el botón "Sync"
- Volver a abrir la aplicación de Outlook y Teams, los mails marcados con flags deberían sincronizarse nuevamente.
  
> **IMPORTANTE**: Una vez sincronizada correctamente repetir el paso inicial para desactivar el acceso por OWA. El mismo solo se habilita para permitir la sincronizacion con la web.