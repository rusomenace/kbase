# Procedimiento de actualizacion de nodos de esxi

## Puntos importantes a tener en cuenta
- Nodo02 y nodo04 ambos tienen discos nvme pciexpress intel p4600
- Localizar la posicion del vcenter en que nodo se encuentra
- Localizar la posicion del servidor TQARSVW19DC01
- La primer actualizacion de nodo es en el 04
- Verificar que la VM de los administradores no se encuentren en un nodo a apagar 1063 y 1001
- Procedimiento de actualizacion
- Poner el nodo en modo mantenimiento Posicionarse en Datacenter01 y realizar sobre updates / baselines / check compliance Tildar las opciones de host security patches y critical host patches Seleccionar la opcion remediate y elegir el nodo a actualizar

## Actualizacion de drivers intel p4600 en nodo 02 y 04
- Iniciar servicio de SSH
- Verificar que en los siguientes discos exista el parche intel-nvme-vmd-en_2.0.0.1146-1OEM.700.1.0.15843807_16259168.zip
    - esxi04-ds01
    - esxi02-ds01
- Conectarse por SSH a los servidores
- Ejecutar el siguiente comando segun corresponda nodo 02 y nodo04

Nodo02
```
esxcli software vib install -d "/vmfs/volumes/5fa2b0f0-57f2f004-11bc-1402ec8c757c/intel-nvme-vmd-en_2.0.0.1146-1OEM.700.1.0.15843807_16259168.zip" 
```
Nodo04
```
esxcli software vib install -d "/vmfs/volumes/61f462c6-f51f3d26-dfdc-48df37db591c/intel-nvme-vmd-en_2.0.0.1146-1OEM.700.1.0.15843807_16259168.zip"
```
- Reiniciar los nodos una vez que instale el vib file
- en caso de no contar con el nombre de los discos se pueden obtener mediante el siguiente comando
```
esxcli storage filesystem list 
```
## Importante: Cuando se inician las VMs verificar que las siguiente maquinas no se enciendan bajo ningun punto
- Todas las vcenter que tengan el comentario de REPLICA
- COMAFI-SRC
- MERLIN

- Una vez finalizada la actualizacion de todos los nodos volcar TQARSVW19DC01, TQARVCENTER, VM1063, VM1001 a un nodo ya actualizado
- Actualizar los nodos restantes
