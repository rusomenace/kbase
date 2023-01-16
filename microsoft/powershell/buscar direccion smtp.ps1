$username = read-host "Type in username"
#Set-Variable -Scope global -name username -value "hmaslowski"

Get-ADUser $username -Properties DistinguishedName, Name, Surname, GivenName, UserPrincipalName, proxyaddresses | Select-Object DistinguishedName, Name, Surname, GivenName, UserPrincipalName,@{n = "proxyAddress"; e = { $_.proxyAddresses | Where-object { $_ -clike "*" } } }