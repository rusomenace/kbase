## Actualizar
sudo apt -y update

## Agregar repos
```
sudo tee -a /etc/apt/sources.list <<EOF
deb http://us.archive.ubuntu.com/ubuntu/ bionic universe
deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe
EOF
```

## Definir correctamente el nombre fqdn
```
sudo hostnamectl set-hostname myubuntu.example.com
```

## Check
```
hostnamectl
```

## Modificar la config de domain_admins
```
cat /etc/resolv.conf
```

## Verificar que el hostname incluya el dominio correspondiente
```
server.dominio.local
```

## Instalar los paquetes
```
sudo apt update
sudo apt -y install realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
```

## Descubri el dominio
```
realm discover tq.com.ar
```

## Buscar ayuda y adjuntar al dominio
```
realm join --help
realm join -U administrator tq.com.ar
```

## Verificar que ingreso correctamente
```
realm list
```

## Crear el homedir por defecto
```
sudo bash -c "cat > /usr/share/pam-configs/mkhomedir" <<EOF
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF
```

## Activarlo
```
sudo pam-auth-update
```
***Seleccionar la opcion activate mkhomedir***

## Reiniciar el servicio y verificar estado
```
systemctl restart sssd
systemctl status sssd
```

# Limit to users
## To permit a user access via SSH and console, use the command:
```
realm permit user1@example.com
realm permit user2@example.com user3@example.com
```
## Permit access to group – Examples
```
sudo realm permit -g sysadmins
sudo realm permit -g 'Domain Admins'
```

## Configure Sudo Access
***By default Domain users won’t have permission to escalate privilege to root. Users have to be granted access based on usernames or groups.***

## Let’s first create sudo permissions grants file.
```
nano /etc/sudoers.d/domain_admins
```

## Add single user:
```
user1@example.com        ALL=(ALL)       ALL
```

## Add another user:
```
user1@example.com     ALL=(ALL)   ALL
user2@example.com     ALL=(ALL)   ALL
```

## Add group
```
%group1@example.com     ALL=(ALL)   ALL
```

## Add group with two or three names.
```
%security\ users@example.com       ALL=(ALL)       ALL
%system\ super\ admins@example.com ALL=(ALL)       ALL
```

## Probar un request a un usuario
```
id username@domain.local
```
## Consultar el detalle de la configuracion y ver usuarios dados de alta
```
realm list
```