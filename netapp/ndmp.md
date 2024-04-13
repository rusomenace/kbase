1. Habilitar NDMP en SVM_CIFS
```
vserver show-protocols
vserver add-protocols -vserver SVM_CIFS -protocols ndmp
vserver show-protocols
```
2. Vemos la version de ndmp
```
vserver services ndmp version
```
3. Vemos el estado de ndmp en los vserver
```
vserver services ndmp show
```
4. Habilitamos ndmp en el vserver
```
vserver services ndmp on -vserver SVM_CIFS
vserver services ndmp show
```
5. Generamos una clave para el usuari vsamin
```
vserver services ndmp generate-password -vserver SVM_CIFS -user vsadmin
```