# ps script que lee de las OUs seleccionadas los usuarios existentes y los agreda al grupo $groupname
# Si el usuario no pertenes a ninguna OU del if lo elimina del grupo

Import-Module ActiveDirectory
$groupname = "Grp_Nexus_Read"
$dev = Get-ADUser -Filter * -SearchBase "OU=dev,OU=users,OU=site0,OU=arg,DC=tq,DC=com,DC=ar"
$qa = Get-ADUser -Filter * -SearchBase "OU=qa,OU=users,OU=site0,OU=arg,DC=tq,DC=com,DC=ar"
$users = ($dev + $qa)
foreach($user in $users)
{
  Add-ADGroupMember -Identity $groupname -Members $user.samaccountname -ErrorAction SilentlyContinue
}
$members = Get-ADGroupMember -Identity $groupname
foreach($member in $members)
{  
  if(($member.distinguishedname -notlike "*OU=dev,OU=users,OU=site0,OU=arg,DC=tq,DC=com,DC=ar*") -and ($member.distinguishedname -notlike "*OU=qa,OU=users,OU=site0,OU=arg,DC=tq,DC=com,DC=ar*"))
  
  {
    Remove-ADGroupMember -Identity $groupname -Members $member.samaccountname -Confirm:$false
  }
}
# SIG # Begin signature block
# MIII9wYJKoZIhvcNAQcCoIII6DCCCOQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB0xpqmkd/s36cb
# wkkYcUF+cXhKGCSXExg2Qy2U/feMNaCCBikwggYlMIIFDaADAgECAhNfAAAAWW5O
# DZTgT/M1AAAAAABZMA0GCSqGSIb3DQEBCwUAMFsxEjAQBgoJkiaJk/IsZAEZFgJh
# cjETMBEGCgmSJomT8ixkARkWA2NvbTESMBAGCgmSJomT8ixkARkWAnRxMRwwGgYD
# VQQDExN0cS1UUUFSU1ZXMTlEQzAxLUNBMB4XDTIxMDMwNTE3NDIxN1oXDTIzMDMw
# NTE3NTIxN1owgZMxEjAQBgoJkiaJk/IsZAEZFgJhcjETMBEGCgmSJomT8ixkARkW
# A2NvbTESMBAGCgmSJomT8ixkARkWAnRxMQwwCgYDVQQLEwNhcmcxDjAMBgNVBAsT
# BXNpdGUwMQ4wDAYDVQQLEwV1c2VyczELMAkGA1UECxMCaXQxGTAXBgNVBAMTEEhl
# cm5hbiBNYXNsb3dza2kwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDx
# EVoDo0uB8WOl6FjBS7dQcAWizV3dK1PmIvfLMjxNXf28ckYzt5zlDvSWMOGUOA5x
# APNdv2rwsS7EGnfPO8i4aWlCOyv6XmV6ZlA84+9It5HQLhfjWInhxX5OQeQL3E8s
# xSoy2phoI3YPA+xCy5xePNfdT2C2RRMJiQMKgl4gregPFKJQDBRt4CWj3mzy63TK
# hzUMecxx6dsDHYE4UBZjM+dGMorMkOMvLlWp3p+lTmyeHP7lcqP7tTg5FzEzGMbJ
# hlI49Iiq8WR3Qk69Cns6Mc2GixN+p4u+WDLUalGQK363T5znHG+jftEK9wbRZC7n
# m0artvajNq5hf6jhgHPdAgMBAAGjggKnMIICozA+BgkrBgEEAYI3FQcEMTAvBicr
# BgEEAYI3FQiCtc90h+iUb4b9hyGG/ogFhYncLYEUhJ22C4edvVsCAWQCAQUwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwCwYDVR0PBAQDAgeAMAwGA1UdEwEB/wQCMAAwGwYJ
# KwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQU37HeQ/ZpFrV37RtJ
# sJEkHrCQ7Z4wHwYDVR0jBBgwFoAU71czxp7PSwoQoNsmnHxKEs6zfBMwgdgGA1Ud
# HwSB0DCBzTCByqCBx6CBxIaBwWxkYXA6Ly8vQ049dHEtVFFBUlNWVzE5REMwMS1D
# QSxDTj1UUUFSU1ZXMTlEQzAxLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2
# aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPXRxLERDPWNvbSxE
# Qz1hcj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9
# Y1JMRGlzdHJpYnV0aW9uUG9pbnQwgcYGCCsGAQUFBwEBBIG5MIG2MIGzBggrBgEF
# BQcwAoaBpmxkYXA6Ly8vQ049dHEtVFFBUlNWVzE5REMwMS1DQSxDTj1BSUEsQ049
# UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJh
# dGlvbixEQz10cSxEQz1jb20sREM9YXI/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVj
# dENsYXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwMAYDVR0RBCkwJ6AlBgorBgEE
# AYI3FAIDoBcMFWhtYXNsb3dza2lAdHFjb3JwLmNvbTANBgkqhkiG9w0BAQsFAAOC
# AQEAu2HS02K4+2oapEV2VZZCYDOhu4SM6Psf/WHlHLQfVV7Ry51S58i1BqXAkzgs
# sykcCaVUpBs7CgG6CuGegaPQfiLOXXOqozf9klvWIKBO3ifVHjavnanOzxyVI4fg
# WsjS8kF9wLlbSA8/LgDHUZ2WzhAWET4qEUuBw9gdXAp8VNQMseX1n6fxjitTSks5
# jw7El5U/5KdieVKP2E65/IvMeDwQrf3gU2G2z2AVk97hwlwPqh3hb+SWWwaDUUAQ
# laMkgzqA2x2H+Q27yWqk75yQxdD0NinGkTNkFrigw8WuroBRXhoHiibSSn/GReim
# C2gR7ymTPCsb0WM/kgqmVngzwTGCAiQwggIgAgEBMHIwWzESMBAGCgmSJomT8ixk
# ARkWAmFyMRMwEQYKCZImiZPyLGQBGRYDY29tMRIwEAYKCZImiZPyLGQBGRYCdHEx
# HDAaBgNVBAMTE3RxLVRRQVJTVlcxOURDMDEtQ0ECE18AAABZbk4NlOBP8zUAAAAA
# AFkwDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZ
# BgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYB
# BAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgTDPvcwIeQiF8NNnl05eIe8p9rTXgz5Kc
# AIh9R/tGP8kwDQYJKoZIhvcNAQEBBQAEggEANx1jloc/sg4VXJ39g203rHsrzcwz
# I+rJO5+wgWJDGD8Oeyj23i1VDN8982b1XTNWmwKWviKN1a8kPaAA0oX8ff3kXUeY
# bEWZUlF0Gr83PXbTUyJGm/TTAji3fL70SWBKganezbwkyraQZ4G1V656SaNN8vVI
# 2bt5ooL6sFKkOlYvB4zTbjyeBK4vhXJTpV8+4qAGo20X2fdNQwAWpTvlAiyJb1E5
# eMrKoGoCis076dpf/204L+mOwue76U7tZacE4Np1IPwNKk4+9rHLfjNnfx3D94ER
# NMza4C7/zxgt1oiYW/rwr0hngiUWbNXhvUKn9tEPbfW+3QVIGothhLS0PQ==
# SIG # End signature block
