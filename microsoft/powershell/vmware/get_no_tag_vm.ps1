$VMnoTag = Get-VM | ?{(Get-TagAssignment $_) -eq $null}
$VMnoTag | Where-Object  {($_.name -Match "TQARSV*") -and ($_.name -ne "TQARSVW19DC03") -and ($_.name -ne "TQARSVW19UBQT01")}  | Select-Object -Property Name, Notes