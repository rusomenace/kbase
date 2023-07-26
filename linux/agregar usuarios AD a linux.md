# Como agregar permisos para loguearse a Linux a usuarios de AD

Utilizamos realm que ya debe estar instalado en el sistema:

```bash
realm permit ltrejo@tq.com.ar 
```

> Es importante agregar el dominio @tq.com.ar, de otra forma no funcionará

Editamos el archivo **/etc/sudoers.d/domain_admins** agregando una linea como esta al final:

```
ltrejo@tq.com.ar    ALL=(ALL)   ALL
```

Una forma sencilla de hacer podria ser *(reemplazar por el usuario correspondiente)*:

```bash
realm permit ltrejo@tq.com.ar && echo -e "\nltrejo@tq.com.ar\tALL=(ALL)\tALL" | sudo tee -a /etc/sudoers.d/domain_admins
```