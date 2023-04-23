# Como obtener Gather Facts

Si el inventario esta declarado con ansible host. Ejemplo:

```
[ubuntu]
ubuntu1 ansible_host=192.168.101.43
```

Se debe aclarar el nombre del host no la ip para obtener los gather facts:

```bash
ansible all -m gather_facts --limit ubuntu1
```
Si en cambio el inventario esta declarado solo con ip como por ejemplo:

```bash
[onlyip]
192.168.101.43
```

El gather facts debe ejecutarse de la siguiente manera

```bash
ansible all -m gather_facts --limit 192.168.101.43
```