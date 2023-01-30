## Windows AD
Seguir la documentacion del siguiente link: https://docs.rockylinux.org/guides/security/authentication/active_directory_authentication/

## En el caso de TQ ejecutar el siguiente comando para garantizar ingreso al AD y join
```
update-crypto-policies --set DEFAULT:AD-SUPPORT-LEGACY
```
## Para unir al dominio con usuario especifico
```
realm join -U hmaslowski tq.com.ar
```
