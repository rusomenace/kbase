Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties "DisplayName", "LastLogonDate", "LockedOut", "LastBadPasswordAttempt", "PasswordLastSet", "PasswordExpired", "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname","LockedOut", "LastLogonDate", "LastBadPasswordAttempt", "PasswordLastSet", "PasswordExpired", @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Sort-Object ExpiryDate | Format-Table -Autosize



