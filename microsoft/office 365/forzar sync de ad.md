**To check the scheduler's current configuration**
Start Windows PowerShell on the server running the AAD connect 1.1 and type
```
Import-Module ADSync
Get-ADSyncScheduler
```
**To force a full sync from Windows PowerShell**
```
Import-Module ADSync
Start-ADSyncSyncCycle -PolicyType Initial
```
**To force a delta sync**
```
Import-Module ADSync
Start-ADSyncSyncCycle -PolicyType Delta
```
No you actually need to set SMTP: in the proxy address attribute of ad to match the mail attribute fled, then you need to specify all secondary mail addresses with lowercase smtp: in the proxy address attributes girls for dirsync to snc to office 365