# Preparar Ansible Control

## Instalar Ansible en Ubuntu

```bash
sudo apt remove ansible
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```
> Se realiza la instalación de esta manera ya que instalar Ansible desde los repositorios de la distribución o a traves de PIP no suele incluir archivos necesarios como ansible.cfg

##  SSH Keys

Generar las Key SSD exclusivas para ansible:

```bash
ssh-keygen -t ed25519 -C "Ansible"
```

Copiar la clave ssh a los servidores de destino:

```bash
ssh-copy-id -i ~/.ssh/ansible.pub <IP Adderss>
```

Como conectarse por ssh utilizando una key especifica:

```bash
ssh -i .ssh/<key_name> <IP Address>
```

## Configurar el inventario

Crear un directorio en home para contener el inventario. Esto no es obligatorio hacerlo de esta manera pero para contener la configuracion relevante a ansible en un solo punto crearemos un directorio *ansiblecontrol* en el home con subdirectorios para cada componente.

```bash
mkdir -p ~/ansiblecontrol/inventory
```
> Donde */home/uroot/ansiblecontrol/* el directorio que deseamos crear para ansible

### Editamos la configuracion para incluir el inventario

```bash
sudo nano /etc/ansible/ansible.cfg
```

Y agregamos las siguientes lineas al final del archivo de configuración:

```bash
[defaults]
inventory = /home/uroot/ansiblecontrol/inventory/inventory
private_key_file = ~/.ssh/ansible
```

Y testamos la correcta comunicacion con los servidores del inventario (si ya disponen ansible instalado)

```bash
ansible all --key-file ~/.ssh/ansible -i ~/ansiblecontrol/inventory/inventory -m ping
```

Si todo salió bien también podriamos utilizar el mismo comando de forma simplificada:

```bash
ansible all -m ping
```

> El modulo *ping* en ansible no es una comunicación icmp solamente sino que se conecta efectivamente por ssh a los destinos y ejecuta el modulo para obtener una respuesta: *"ping:pong"*. Esto significa que podria tenerse respuesta por un tradicional ping al destino pero no necesariamente respuesta desde el modulo ping de ansible.
> Por otro lado, no solicita que le indiquemos la key ssh ya que la indicamos en el archivo ansible.cfg

### Algunas variables útiles para utilizar en el inventario:

- **ansible_host** un alias para darle al host en caso de no poder o no querer usar dns
- **ansible_port** el numero de puerto si no se utiliza el 22 que es el defecto de ssh
- **ansible_user** el username para conectarse. Util si el control es ubuntu (uroot) y el restino es rocky (rroot)
- **ansible_password** el password a utilizar para autenticar. Nunca usar texto plano, siempre usar Vault
- **ansible_ssh_private_key_file** la private key usada por ssh
- **ansible_become** equivalente a sudo o ansible_su
- **ansible_become_method** permite elegir el metodo de escalamiento
- **ansible_become_user** equivalente ansible_sudo_user o ansible_su_user, permite elegir el usuario de sudo o con privilegios
- **ansible_become_password** equivalente a ansible_sudo_password o ansible_su_password, el password a utilizar para autenticar con sudo. Nunca usar texto plano, siempre usar Vault

*Ejemplo de entrada de inventario con variables*
```ini
some_host         ansible_port=2222     ansible_user=manager
aws_host          ansible_ssh_private_key_file=/home/example/.ssh/aws.pem
```

### Listar host del inventario

```bash
ansible all --list-host
```

