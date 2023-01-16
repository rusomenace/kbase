# SSH

## Consultas de encriptacion de SSH
```
nmap -p22 -n -sV --script ssh2-enum-algos devops.tqcorp.com
```
El servidor ssh para el repositorio tiene algoritmos debiles por lo que se llevan a cabo los siguientes cambios en la base de datos de config

## Query y modificacion de SQL
```
exec prc_SetRegistryValue 1, '#\Configuration\SshServer\KexInitOptions\encryption_algorithms\', 'aes128-ctr,aes256-ctr'

exec prc_SetRegistryValue 1, '#\Configuration\SshServer\KexInitOptions\kex_algorithms\', 'diffie-hellman-group-exchange-sha256'
```
Reiniciar el servidor de **devops**
## SSH generacion de llaves privadas y publicas
***El siguiente ejemplo se utiliza la cuenta hmaslowski pero debera generarse y darse de alta las llaves correspondientes a cada usuario***
### WSL2
El siguiente comando genera todas las llaves
```
ssh-keygen -t rsa -b 4096 -C "hmaslowski"
```
El resultado es similar a esto
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/uroot/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/uroot/.ssh/id_rsa
Your public key has been saved in /home/uroot/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:buT46uGD9j36RYIJsoh0J1n/e6zb+qVr+bLxMOD65mA hmaslowski
The key's randomart image is:
+---[RSA 4096]----+
|     .           |
|    o .          |
| ..+.. .         |
|o..oo. o.        |
|o .   o So.      |
|       =.o+      |
|     .oE+o.*..   |
|    o.o=+o++B    |
|   . o**BB=*=o   |
+----[SHA256]-----+
```
Durante el proceso se va a solicitar una clave para utilizar la llave privada, tanto la clave como el archivo id_rsa deben ser resguardados correctamente
Visualizar el archivo publico
```
cat id_rsa.pub
```
Dara como resultado la clave publica similar a esto
```
cat id_rsa.pub
```
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7MsRh914Rs1u0HVSXmM8ixmyb9vJof89/
tdHNsDIDc2H8EOTim24ffCwq451JY2s0HxiVqwMOUckZdLyvOPSdeTQTHAdB2USRouObDIzb
bxSGrkliBqeu7vv4FzwjM+xCnLtyAUG3uDts0BqCOkG16VYDul0nU0pT063stcADmFkc4/1M
8DFsJ/RnKcgdPdiOUA5MxGLxo/IdWIJqz48PvPXurKVGoE4th6mKIySwXQqURAGhVnrJjcXf
6ZTYVHFrYvD39YarVy9Ts6PyMYAhzyNyOaVhj1VOB601/8BlvJaYPdkUNER42KZ0cUbN+fbd
/+6eb2SfNJvFy3san5LcEFq8KiY29QA6V8cBuTXtg+y8a3csTtIwCWVhV43yet4CW7EyrIkq
VbQwjEeqRej4gMzs4cKFOU7TEg2W0oSFxgLHBji8bzsTD6a6dTKoFcyZQiIBhJiebwKXgkjN
fz9gLsCOrxZN2QadyhfjY2KzK0ypeni8hWVqqG6QhyjKCkcC6eeBrvMPzunKOl+W0NYJVh5I
CxA2Qqg/+O1BzmnnW+SbywHqsARTujIcn5G8a85gEnM3G2DglFg2pi5ce7Sa0lU/hIDNp/Nv
v4Ijde/6dhMXyn1dKnDDqOdWZoEj4Bf6we+a1tW9XQSNVWfcs0+LRhHCMo+XeLxEbPQzMiQ
== hmaslowski
```
El ssh-rsa anterior es el que se debe cargar en devops para el usuario en cuestion en la siguiente ruta
- Iniciar sesion en devops con el usuario, en este caso hmaslowski
- Menu superior a la derecha del usuario
- security
- ssh public keys
- add y pegar la llave ssh-rsa
