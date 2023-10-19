# Como setear VLAN en switch echeverria

## Entrar al modo configuracion
```
enable
```

conf t o configure terminal
```
conf t
```

## Para ver la configuracion actual del puerto
```
do show running-config interface gi 1/0/36
```

## Reemplazar por el numero de la interfaz
```
interface gi 1/0/36
```

## Setear un mensaje descriptivo
```
banner motd mensaje
```

## Reemplazar por la VLAN correspondiente
```
switchport access vlan 154
```

## Salimos con exit o end
```
exit
```

## Guardamos los cambios con wr o write memory
```
wr
```