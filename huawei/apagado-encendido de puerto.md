# Apagado y encendido de un puerto

1. Identificar el puerto apagar, en este caso de ejemplo usamos GigabitEthernet 1/0/20
2. Ingresamos por ssh al switch
3. Ingresamos al modo de configuracion ```[ ]```
```
system-view
```
4. Accedemos al puerto
```
interface GigabitEthernet 1/0/20
```
5. Apagamos el puerto
```
shutdown
```
6. Ejecutamos el comando ```quit``` 2 veces hasta quedar en el menu ```< >```
7. Salvamos la configuracion
```
save
```
8. Para volver a habilitar el puerto volver a seguir los pasos desde 1 hasta 5 y en vez del comando ```shutdown``` ejecutamos el siguiente
```
undo shutdown
```
9. Seguir con puntos 6 y 7
