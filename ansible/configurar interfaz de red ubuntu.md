# Playbook ejemplo configurar interfaz de red en Ubuntu utilizando Netplan

```yaml
---
- name: Configurar netplan para interfaz de red ens160
  hosts: localhost
  become: true

  tasks:
  - name: Configurar netplan
    template:
      src: templates/01-netcfg.yaml.j2
      dest: /etc/netplan/01-netcfg.yaml
    vars:
      hostname: "ansibleubuntu1"
      interface: "ens160"
      ip_address: "192.168.101.49"
      netmask: "255.255.255.0"
      gateway: "192.168.101.255"
      dns_servers:
        - "10.1.1.13"
        - "10.1.1.15"
      domain_search: "tq.com.ar"
      static_routes:
        - destination: "10.1.1.0/24"
          gateway: "192.168.101.250"
        - destination: "0.0.0.0/0"
          gateway: "192.168.101.253"
    notify:
      - apply netplan
  handlers:
  - name: apply netplan
    shell: netplan apply
```

# Plantilla j2

Luego debemos crear el archivo de template en la ruta indicada en la variable **src** dentro de **template** en el playbook anterior. En este caso *"01-netcfg.yaml.j2"*

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    {{ interface }}:
      dhcp4: no
      dhcp6: no
      addresses: [{{ ip_address }}/{{ netmask }}]
      gateway4: {{ gateway }}
      nameservers:
        addresses: [{{ dns_servers[0] }}, {{ dns_servers[1] }}]
        search: [{{ domain_search }}]
      routes:
        {% for route in static_routes %}
        - to: {{ route.destination }}
          via: {{ route.gateway }}
        {% endfor %}
```
