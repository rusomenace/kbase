Los siguiente scripts sirven para validar los datos de los usuarios y atributos como UPN, direccion de correo, proxy addresses, etc. El objetivo es ver si los UPN, SID history e inmutable ID (caso entra 365) se estan respetando.

## Entra Azure AD

**CheckMSolUser.ps1**
```
# Import the MSOnline module
Import-Module MSOnline

# Prompt for the username
$username = Read-Host -Prompt "Please enter the username"

# Get the user details
$user = Get-MsolUser -UserPrincipalName $username

# Convert the ImmutableId from a Base64 string to a byte array
$immutableIdBytes = [System.Convert]::FromBase64String($user.ImmutableId)

# Convert the byte array to a GUID
$immutableIdGuid = New-Object -TypeName System.Guid -ArgumentList (,$immutableIdBytes)

# Get the SID
$sid = $user.ObjectId

# Print the attributes
Write-Host "UserPrincipalName: $($user.UserPrincipalName)" -ForegroundColor Green
Write-Host "ObjectID: $($user.ObjectId)" -ForegroundColor DarkGreen
Write-Host "DisplayName: $($user.DisplayName)" -ForegroundColor Green
Write-Host "Email Addresses: $($user.EmailAddresses)" -ForegroundColor DarkGreen
Write-Host "ImmutableID: $($immutableIdGuid)" -ForegroundColor DarkGreen
Write-Host "SID: $sid" -ForegroundColor Cyan
```

## Active Directory

**CheckUser.ps1**
```
# Import the Active Directory module
Import-Module ActiveDirectory

# Prompt for the username
$username = Read-Host -Prompt "Please enter the username"

# Get the user details
$user = Get-ADUser -Identity $username -Properties UserPrincipalName, ProxyAddresses, ObjectGUID, EmailAddress, SID, SIDHistory, mS-DS-ConsistencyGuid

# Convert the mS-DS-ConsistencyGuid from a byte array to a GUID
if ($user.'mS-DS-ConsistencyGuid' -ne $null) {
    $consistencyGuid = New-Object -TypeName System.Guid -ArgumentList (,$user.'mS-DS-ConsistencyGuid')
} else {
    $consistencyGuid = $null
}

# Print the attributes in cyan
Write-Host "UserPrincipalName: $($user.UserPrincipalName)" -ForegroundColor Green
Write-Host "ProxyAddresses: $($user.ProxyAddresses)" -ForegroundColor DarkGreen
Write-Host "ObjectGUID: $($user.ObjectGUID)" -ForegroundColor Green
Write-Host "UPN: $($user.UserPrincipalName)" -ForegroundColor DarkGreen
Write-Host "Email Addresses: $($user.EmailAddress)" -ForegroundColor DarkGreen
Write-Host "SID: $($user.SID)" -ForegroundColor DarkGreen
Write-Host "SIDHistory: $($user.SIDHistory)" -ForegroundColor DarkGreen
Write-Host "mS-DS-ConsistencyGuid: $($consistencyGuid)" -ForegroundColor Green

```