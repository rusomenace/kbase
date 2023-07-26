# Conectar Ansible a Fortigate

Desde el servidor de Ansible Control ejecutar el siguiente comando para instalar el modulo *fortios*

```bash
sudo ansible-galaxy collection install fortinet.fortios
```
Crear una entrada en el inventario con los dispositivos fortigate a administrar. Por ejemplo:

```yaml
[fortigate]
tqarfw02 ansible_host=	10.1.1.253 ansible_user=admin ansible_password=secret
```
Crear un playbook de Ansible que utilice el módulo *fortiosapi*. Por ejemplo:

```yaml
- name: Configurar interfaz en FortiGate
  hosts: fortigate
  gather_facts: no
  collections:
    - fortinet.fortios
  tasks:
    - name: Configurar interfaz
      fortios_system_interface:
        url: "{{ fortigate.ansible_host }}"
        username: "{{ fortigate.ansible_user }}"
        password: "{{ fortigate.ansible_password }}"
        adom: "root"
        vdom: "root"
        intf: "port1"
        ip: "192.168.1.2/24"
```
> En este ejemplo el playbook configura la interfaz "port1" con la dirección IP "192.168.1.2/24"


