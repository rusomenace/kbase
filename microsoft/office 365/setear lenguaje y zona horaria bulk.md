### Comando para definir globalmente todas las cuentas con un lenguaje y un timezone
```
get-mailbox | Set-MailboxRegionalConfiguration -Language  -TimeZone
```
### The Language ID is a number that corresponds to the correct language type. The following table shows you which number corresponds to which language.
```
Language: English (United States) 	1033
Timezone: 070 	S.A. Eastern Standard Time 	(GMT-03:00) Buenos Aires, Georgetown

Set-MailboxRegionalConfiguration
```
### Syntax:
```
Set-MailboxRegionalConfiguration -Identity <MailboxIdParameter> [-Confirm [<SwitchParameter>]] [-DateFormat <String>] [-DomainController <Fqdn>] [-Language <CultureInfo>] [-LocalizeDefaultFolderName <SwitchParameter>] [-TimeFormat <String>] [-TimeZone <ExTimeZoneValue>] [-WhatIf [<SwitchParameter>]]
```
### Ejemplo:
```
Set-MailboxRegionalConfiguration -Identity tstark -DateFormat dd-MMM-yy
```
## Formatos validos de fechas
"en-US". Valid formats include "M/d/yyyy, M/d/yy, MM/dd/yy, MM/dd/yyyy, yy/MM/dd, yyyy-MM-dd, dd-MMM-yy"

### Obtener todos los resultados de las casillas de correo:
```
Get-Mailbox | Get-MailboxRegionalConfiguration
```
## Para office 365:

### Configuracion Individual
```
Set-MailboxRegionalConfiguration -Identity bblanco -Language en-US -DateFormat dd-MMM-yy -TimeZone "Argentina Standard Time"
```
### Todas las cuentas
```
Get-mailbox -ResultSize unlimited | Set-MailboxRegionalConfiguration  -Language en-US -DateFormat dd-MMM-yy -TimeZone "Argentina Standard Time"
```