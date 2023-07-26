# Manejo servicios en Linux con Ansible: Modulo systemd vs service

The module **service** is a generic one. According to the Ansible documentation :

    Supported init systems include BSD init, OpenRC, SysV, Solaris SMF, systemd, upstart.

Example:
```yaml
    - name: Iniciar servicio de Docker
      service:
        name: docker
        state: started
        enabled: yes
```

The module **systemd** is available only from Ansible 2.2 and is dedicated to systemd.

According to the developers of Ansible :

    we are moving away from having everything in a monolithic 'service' module and splitting into specific modules, following the same model the 'package' module has.

Example:
```yaml
    - name: Iniciar el servicio de Docker en systemd
      systemd:
        name: docker
        state: started
        enabled: yes
```