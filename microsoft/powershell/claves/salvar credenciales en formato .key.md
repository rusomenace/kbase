El siguiente es un comando que aplica para el guardado de credenciales en un archivo ofuscado
```
$credential = Get-Credential ; $credential.Password | ConvertFrom-SecureString | Set-Content %userprofile%\Documents\GIT\Tools\ABM\Key\usuario.tenant.key
```

Reemplazar usuario por lo que corresponda, ejemplo: bblanco, hmaslowski, ltrejo, etc.