### Preguntar la RetentionPolicy
```
Get-Mailbox -Identity "hmaslowski@tqcorp.com" | ft Alias,RetentionPolicy
```
### Definir la RetentionPolicy
```
Set-Mailbox -Identity "hmaslowski@tqcorp.com" -RetentionPolicy "RP - 1 year move to archive"
Set-Mailbox -Identity "hmaslowski@tqcorp.com" -RetentionPolicy "RP - 2 year move to archive"
```
### Query para ver las RetentionPolicy de todos los usuarios
```
Get-Mailbox -ResultSize Unlimited | ft -auto Alias,Archive
```
### Query de todos los usuarios y aplicacion de RetentionPolicy
```
Get-Mailbox -ResultSize Unlimited | Set-Mailbox -RetentionPolicy  "RP - 2 year move to archive"
```