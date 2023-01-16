## Ubuntu
Install the prerequisites:
```
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
```
Import an official nginx signing key so apt could verify the packages authenticity. Fetch the key:
```
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```
Verify that the downloaded file contains the proper key:
```
gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
```
The output should contain the full fingerprint 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 as follows:
```
pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
      573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
uid                      nginx signing key <signing-key@nginx.com>
```
***If the fingerprint is different, remove the file.***

To set up the apt repository for stable nginx packages, run the following command:
```
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```
If you would like to use mainline nginx packages, run the following command instead:
```
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```
Set up repository pinning to prefer our packages over distribution-provided ones:
```
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | sudo tee /etc/apt/preferences.d/99nginx
```
To install nginx, run the following commands:
```
sudo apt update
sudo apt install nginx
```

## Redhat 

***Se recomienda seguir la guia [Eliminar Nginx Completamente](https://devops.tqcorp.com/IT/Documents/_git/KBase?path=%2Fnginx%2Fdesinstalar%20completamente.md&version=GBmain&_a=preview) para eliminar nginx y reinstalar de cero, las actualizaciones "in place" no resultaron exitosas***

***Tambien se recomienda post instalacion seguir la guia para [actualizar](https://devops.tqcorp.com/IT/Documents/_git/KBase?path=%2Flinux%2FRedhat%208.2%2Factualizar.md&version=GBmain&_a=preview) el OS con los ultimos parches***


Install the prerequisites:
```
sudo yum install yum-utils
```
To set up the yum repository, create the file named ```/etc/yum.repos.d/nginx.repo``` with the following contents:
```
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/8/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```
***Importante, la baseurl debe usar release 8 en su path y no la variable que invoca la version del redhat, en 8.2 falla la descarga porque esa url no existe***
Base URL original de documentacion ```baseurl=http://nginx.org/packages/centos/$releasever/$basearch/```
```
[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
```
By default, the repository for stable nginx packages is used. If you would like to use mainline nginx packages, run the following command:
```
sudo yum-config-manager --enable nginx-mainline
```
To install nginx, run the following command:
```
sudo yum install nginx
```
When prompted to accept the GPG key, verify that the fingerprint matches **573B FD6B 3D8F BC64 1079 A6AB ABF5 BD82 7BD9 BF62**, and if so, accept it.

**Ref:** http://nginx.org/en/linux_packages.html#ubuntu