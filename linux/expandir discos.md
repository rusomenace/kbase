Ref: [https://packetpushers.net/ubuntu-extend-your-default-lvm-space/](https://packetpushers.net/ubuntu-extend-your-default-lvm-space/)

## Verficar tamaño de disco
```df -h```

## Si no se ve espacio libre re escanear la unidad
```echo 1>/sys/class/block/sda/device/rescan```

## Utilidad para incrementar el espacio de disco
```cfdisk```

## Una vez hecho el rezise extender la PV
```pvresize /dev/sda3```

## Verificar por espacio libre por asignar
```vgdisplay```

## Incrementar el size block
```lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv```

## Extender el filesystem
```resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv```
