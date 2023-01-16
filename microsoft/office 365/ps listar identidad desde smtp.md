```
Get-Mailbox -Identity * | Where-Object {$_.EmailAddresses -like 'smtp:hmaslowski@tqcorp.com'} | Format-List Identity
```