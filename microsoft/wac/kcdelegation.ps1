#Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory

# hostname of wac server
$wac = "tqarsvw19wac01"

# server names top manage, additional servers "s1", "s2" and so on
$servers = "TQARWSW712"

# get the ident of object $wac
$wacobject = Get-ADComputer -Identity $wac

# set the resource-based kerberos constrained delegation for each node
foreach ($server in $servers)
{
$serverObject = Get-ADComputer -Identity $server
Set-ADComputer -Identity $serverObject -PrincipalsAllowedToDelegateToAccount $wacobject
}