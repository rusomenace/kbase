$UsrName = read-host "Username en formato SAMACCOUNTNAME / nombre de NETBIOS"
$FullUsrName = ($UsrName.ToLower() +"@tqcorp.com")

# Remueve usuario del AD
Write-Host -Foregroundcolor CYAN "INFO: Removing user from AD..."
Import-Module ActiveDirectory
Remove-ADUser -Identity $UsrName -Confirm:$false

Write-Host -Foregroundcolor CYAN "INFO: Removing user photo..."
remove-item "P:\Folders\Soporte\Docs\Fotos\TQPhoto\$UsrName.jpg"

# Synchro en AAD: Azure Active Directory 
Write-Host -Foregroundcolor CYAN "INFO: Syncing Local Active Directory with Azure AD..."
P:\Folders\Soporte\Tools\Azure\Sync.ps1

# Remueve usuario de fortigate
Write-Host -Foregroundcolor CYAN "INFO: Removing AD user in fortigate TQARFW01..."
$user = [System.Environment]::GetEnvironmentVariable('username')
$password = Get-Content "C:\Tools\ABM\creds.txt" | ConvertTo-SecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $user, $password
New-SshSession -ComputerName "tqarfw01.tqcorp.com" -Credential $cred -AcceptKey:$True

$Command = @"
config user group
edit "ldap_grp-tq_all"
unselect member "$FullUsrName"
end
config user local
delete "$FullUsrName"
end
"@

Invoke-SSHCommand -SessionId 0 -Command $Command
Get-SSHSession | Remove-SSHSession