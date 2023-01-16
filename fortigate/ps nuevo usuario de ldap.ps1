$userName = "hmaslowski"
$password = Get-Content "C:\Tools\ABM\creds.txt" | ConvertTo-SecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $password
New-SshSession -ComputerName "tqarfw02.tqcorp.com" -Credential $cred


$Command = @"
config user local
edit bblanco@tqcorp.com
set email-to "bblanco@tqcorp"
set type ldap
set ldap-server "tq.com.ar"
end
config user group
edit "ldap_grp-tq_all"
append member "bblanco@tqcorp.com"
end
"@

Invoke-SSHCommand -SessionId 0 -Command $Command
Get-SSHSession | Remove-SSHSession
