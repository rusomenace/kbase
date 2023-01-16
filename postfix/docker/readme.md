Se utiliza como base el repositorio de https://github.com/juanluisbaptiste/docker-postfix
Se hace un git pull y se construye la imagen como postfix/postfix:latest
La implementacion hace uso de un archivo .env, no sirve subir los archivos main.cf y master.cf
Se utiliza docker-compose para iniciar y apagar el stack de servicio con nombre de proyecto