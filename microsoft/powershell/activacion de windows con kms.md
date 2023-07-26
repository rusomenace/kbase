# Activar windows via KMS

## Activar Remotamente

```
Invoke-Command -ComputerName COMPUTER_NAME_HERE -ScriptBlock {cscript.exe c:\windows\system32\slmgr.vbs /skms replace_kms_here ; cscript.exe c:\windows\system32\slmgr.vbs /ato}
```

## El siguiente script usa el kms interno de TQ para configurarse y activarse
```
$activation = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | where { $_.PartialProductKey } | select -ExpandProperty LicenseStatus
if ($activation -ne "1") {
    slmgr.vbs /skms kms.tq.com.ar
Write-Host -Foregroundcolor CYAN "INFO: KMS Registered"
    slmgr.vbs /ato
Write-Host -Foregroundcolor CYAN "INFO: Windows is activated"
    start-sleep -Seconds 20
}
Stop-Process -name "*wscript*"
Stop-Process -name "*wscript*"
```

To review:
Incluir la opción de batch mode en la invocación de cscript.exe
Options:
 //B         Batch mode: Suppresses script errors and prompts from displaying