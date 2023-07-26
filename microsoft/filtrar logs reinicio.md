# Como filtrar logs para obtener reinicios del sistema

Ingresar al visor de eventos con WIN+R *"eventvwr.msc"*

Windows Logs => System => Filter current log (en la columna derecha)

Filtrar de la siguiente manera:
- Event Sources: **Kernel-general**
- Event ID: **13**

Si pueden aplicar mas  filtros como tiempo, usuarios etc

Aceptar

Para guardar este filtro click en *Save filter to custom view* y elegir un nombre deseado