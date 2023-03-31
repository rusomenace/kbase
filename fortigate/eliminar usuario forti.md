# Como eliminar un usuario en Fortigate

Ingresar al [Fortigate](https://10.1.1.254:10443/)

Dirigirse a *User & Authentication*=>*User Definition* y buscar el usuario a eliminar

Dado que los objetos en Forti no pueden ser eliminados hasta que no se elimine su pertenencia es necesario borrar los grupos a los que pertenece. Si el objeto aparece griseado y no se puede eliminar expandir hasta la columna Ref. (referencia) y hacer click en el numero de referencia.
Click en *Edit* y allí podremos seleccionar el usuario y eliminarlo