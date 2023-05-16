# Remove Internet Explorer from Windows Server
Run CMD or Powershell as admin
```
dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64
```