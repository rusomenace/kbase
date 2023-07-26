Configuraciones adicionales no incluidas en el documento de instalacion

## Configuracion SELinux/AppArmor

### Configuracion con AppArmor (nativo de ubuntu)

Verificar el estado de Apparmor

```bash
sudo apparmor_status
```

```bash
sudo aa-status | grep postgres
```

Si aparece un resultado reemplazarlo

```bash
sudo nano /etc/apparmor.d/resultado_aa-status # Cambiar este valor segun corresponda
```

Reiniciar servicios:

```bash
sudo systemctl restart apparmor
```

```bash
sudo systemctl restart postgresql
```

### Instalacion y verificacion de estado SELinux

Instalamos con el siguiente comando:

```bash
sudo apt install policycoreutils && sudo apt-get install policycoreutils-python-utils
```

Verificamos que SELinux esta disponible y funcionando en el sistema

```bash
sestatus
```

Otra opcion

```bash
getenforce
```

### Configuracion SElinux para PostgreSQL

Habilitamos SELinux:

```bash
sudo nano /etc/selinux/config
```

Y editamos la linea "SELINUX=" para que quede de la siguiente forma:

```
SELINUX=permissive
```

Configuramos los contextos:

```bash
sudo semanage fcontext -a -t postgresql_db_t '/usr/local/pgsql/data(/.*)?'
sudo restorecon -Rv /usr/local/pgsql/data/
```

Actualizamos la politica de SELinux

```bash
sudo restorecon -Rv /etc
```

Reiniciar el sistema

Realizar este paso **SOLO** si configuramos PostgreSQL en un puerto no estandard o queremos de todas formas especificar el puerto en el contexto de SELinux configuramos:

```bash
sudo semanage port -a -t postgresql_port_t -p tcp 5432 # Reemplazar por el puerto deseado
```

Es recomendable reiniciar el servicio de PostgreSQL

```bash
sudo systemctl restart postgresql
sudo setenforce 1
```

Reiniciar el sistema


### Solo si deseamos DESHABILITAR SELinux

Modificamos la configuracion con el siguiente comando

```bash
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
```

Actualizamos la politica de SELinux

```bash
sudo restorecon -Rv /etc
```

Reiniciamos el sistema