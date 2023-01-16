### Como crear archivos de claves encriptadas para powershell
```
"somepassword" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\Tools\securepassword.txt"
```

### Como recuperar la clave para asignarla a una variable
```
$password = Get-Content "C:\Tools\securepassword.txt" | ConvertTo-SecureString
```