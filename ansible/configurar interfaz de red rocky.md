# Playbook

```yaml
---
- name: Configurar red en ens192
  hosts: localhost
  become: yes
  vars:
    hostname: ansiblerocky1
    ip_address: 192.168.101.49
    netmask: 255.255.255.0
    gateway: 192.168.101.255
    dns_servers:
      - 10.1.1.13
      - 10.1.1.15
    domain_search: tq.com.ar
    static_routes:
      - dest: 10.1.1.0/24
        via: 192.168.101.250
      - dest: 0.0.0.0/24
        via: 192.168.101.253
  tasks:
    - name: Configurar hostname
      hostname:
        name: "{{ hostname }}"
      become: yes
    
    - name: Configurar red con network scripts
      template:
        src: templates/ifcfg.j2
        dest: /etc/sysconfig/network-scripts/ifcfg-ens192
        mode: '0644'
      notify: Reiniciar red
    
    - name: Configurar resolv.conf
      copy:
        dest: /etc/resolv.conf
        content: |
          nameserver {{ dns_servers[0] }}
          nameserver {{ dns_servers[1] }}
          search {{ domain_search }}
    
    - name: Configurar rutas estáticas
      lineinfile:
        dest: /etc/sysconfig/network-scripts/route-ens192
        line: "{{ item.dest }} via {{ item.via }}"
        create: yes
      with_items: "{{ static_routes }}"
    
  handlers:
    - name: Reiniciar red
      service:
        name: network
        state: restarted
```

Este playbook utiliza una plantilla para crear el archivo de configuración de la interfaz de red ens192 /etc/sysconfig/network-scripts/ifcfg-ens192 con la información de hostname, dirección IP, máscara de red, gateway y DNS. También configura el archivo /etc/resolv.conf con los DNS y el domain search, y añade las rutas estáticas especificadas en el parámetro static_routes. Al final, utiliza un handler para reiniciar el servicio de red después de aplicar los cambios.

# Plantilla j2

Crear la carpeta templates dentro del directorio donde se encuentre el playbook, y dentro ifcfg.j2 (si se elige otro nombre cambiar el en playbook) con la siguiente plantilla:

```yaml
DEVICE=ens192
BOOTPROTO=none
ONBOOT=yes
IPADDR={{ ip_address }}
NETMASK={{ netmask }}
GATEWAY={{ gateway }}
```