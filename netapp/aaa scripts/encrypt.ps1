# Prompt for the password and convert it to a secure string
$SecurePassword = Read-Host -Prompt "Enter password" -AsSecureString

# Export the secure string to a file
$SecurePassword | ConvertFrom-SecureString | Out-File "C:\Tools\NetApp\encrypted_password.txt"
