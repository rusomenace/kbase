# Port Security

Mostrar el listado completo de cada mac address en cada interfaz de red
```
display mac-address
```
Mostrar el listado de una mac address en una interfaz de red
```
display mac-address GigabitEthernet 1/0/43
```

# Asegurar un puerto con una mac address
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
5. Ejecutamos los siguientes comandos para asegurar el puerto en cuestion
```
port-security enable
port-security mac-address AAAA-BBBB-XXXX vlan 10
port-security protect-action protect (funcionamiento por defecto)
```
6. Ejecutamos el comando ```quit``` 2 veces hasta quedar en el menu ```< >```
7. Salvamos la configuracion
```
save
```