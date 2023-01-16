# Activar windows via KMS

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