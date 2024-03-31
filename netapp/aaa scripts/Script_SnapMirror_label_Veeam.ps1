# 20240314
#
# 1.With the latest powershell module NetApp.Ontap there is a problem in the command response resulting on
# results taking too long or time out.
# The solution is to add -zapi to the login
# 2.Improve code and reduce of reduntant lines
# 3.Password encryption (see howto encrypt)
#
# Howto Encrypt
# Create a powershell scrypt with this code and modify path at discretion

## encrypt.ps1 begin
# Prompt for the password and convert it to a secure string
# $SecurePassword = Read-Host -Prompt "Enter password" -AsSecureString

# Export the secure string to a file
# $SecurePassword | ConvertFrom-SecureString | Out-File "C:\Tools\NetApp\encrypted_password.txt"
## encrypt.ps1 end

# Import the required module
Import-Module NetApp.Ontap

# Define the NetApp cluster and SVM
$SourceCluster = '10.210.230.13'
$SourceSVM1 = 'SVM_NFS'

# Define the SnapMirror label
$MirrorLabel = 'Veeam'

# Define an array of source volumes
$SourceVolumes = @('DS_NFS_01', 'DS_NFS_02', 'DS_NFS_03', 'DS_NFS_04')

# Decrypt the password
$EncryptedPassword = Get-Content "C:\Tools\NetApp\encrypted_password.txt"
$SecurePassword = ConvertTo-SecureString -String $EncryptedPassword

# Create a PSCredential object
$SourceCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "adm-contec", $SecurePassword

# Connect to the source cluster
Connect-NcController -Name $SourceCluster -Credential $SourceCredential -ZapiCall | Out-Null

# Iterate over each source volume
foreach ($Volume in $SourceVolumes) {
    # Get the latest snapshot containing '*Vee*'
    $LatestSnapshot = Get-NcSnapshot -Volume $Volume | Where-Object { $_.Name -like '*Vee*' } | Sort-Object -Property Created -Descending | Select-Object -First 1

    # Apply SnapMirror label to the latest snapshot
    Set-NcSnapshot -Snapshot $LatestSnapshot -Vserver $SourceSVM1 -Volume $Volume -SnapMirrorLabel $MirrorLabel | Out-Null
}
