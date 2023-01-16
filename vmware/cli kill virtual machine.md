## #Obtener lista de virtuales
```
esxcli vm process list
```

### Power off the virtual machine from the list by running this command
```
esxcli vm process kill --type=[soft,hard,force] --world-id=WorldNumber
```
