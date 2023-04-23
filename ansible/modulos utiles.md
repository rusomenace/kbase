# Ansible módulos útiles

### **ansible.builtin.package:**
Manejador de paquetes que funciona indistintamente para todas las distribuciones (apt, yum, dnf, etc.)

Ejemplo:
```yaml
- name: Instalar git
  ansible.builtin.package:
    name: git
    state: present
```

### **ansible.builtin.service:**
Manejar servicios indistintamente de la distribución (Ubuntu o Rocky)
Iniciar inmediatamente: *(state=started)*
Iniciar cuando inicia el sistema *(enabled=true)*

Ejemplo:
```yaml
- name: Iniciar y habilitar al inicio nginx
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

### **ansible.builtin.template:**
Para utilizar templates y distribuir archivos. Ideal para archivos de configuración

Ejemplo:
```yaml
- name: Configuracion app
  ansible.builtin.template:
    src: app_settings.j2
    dest: /opt/myapp/settings.conf
```

### **ansible.builtin.file:**
Manejar archivos, directorios o links

Ejemplo:
```yaml
- name: Crear directorio
  ansible.builtin.file:
    name: /opt/myapp
    state: directory
    mode: 0755
```

### **ansible.builtin.debug:**
Mostrar mensajes y mostrar resultados de variables

Ejemplo:
```yaml
- name: Mostrar Mensaje
  ansible.builtin.debug:
    msg: "Este es un mensaje"
```
```yaml
- name: Mostrar valor de la variable
  ansible.builtin.debug:
    var: nombre_de_la_variable
```
