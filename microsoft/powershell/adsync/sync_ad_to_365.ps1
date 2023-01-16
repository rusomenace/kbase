$TmpSess = New-PSSession -Computer TQARSVW16AAD01
Invoke-Command -Session $TmpSess {C:\Tools\Sync.ps1}