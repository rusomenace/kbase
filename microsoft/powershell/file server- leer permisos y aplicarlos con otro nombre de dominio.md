Este script de powershell lee los permisos de todas las carpetas donde se define la variable DRIVE
En el ejemplo los dominio origen son CONTECLAB y alemania, se excluyen administrators y hmaslowski.
Idealmente es necesario revisar lo que va a bajar al CSV.

**ReadFolderPermissions.ps1**
```
# Define the drive letter or path
$drive = "E:\"

# Get all directories recursively from the drive
$folders = Get-ChildItem -Path $drive -Directory -Recurse

# Define an array to store the results
$results = @()

foreach ($folder in $folders) {
    $acl = Get-Acl -Path $folder.FullName
    foreach ($access in $acl.Access) {
        # Check if the identity is a group and does not start with "BUILTIN"
        # Assuming groups have a specific pattern like "CONTECLAB\" followed by the group name
        if ($access.IdentityReference -match "^(DOMAIN|CONTECLAB|alemania)\\(?!hmaslowski$|administrator$)") {
            $results += [PSCustomObject]@{
                Path      = $folder.FullName
                Identity  = $access.IdentityReference
                Rights    = $access.FileSystemRights
                Inherited = $access.IsInherited
            }
        }
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\tools\group_folder_permissions.csv" -NoTypeInformation

# Output results to console (optional)
$results | Format-Table -AutoSize

```
El siguiente script lee el CSV y aplica los mismo permisos pero con Dominio **Alemania**

**GiveFolderPermissions.ps1**
```
# Define the path to the CSV file
$csvPath = "C:\tools\group_folder_permissions.csv"

# Import the CSV file
$permissions = Import-Csv -Path $csvPath

foreach ($permission in $permissions) {
    $folderPath = $permission.Path
    $identity = $permission.Identity -replace "CONTECLAB", "ALEMANIA"
    $rights = [System.Security.AccessControl.FileSystemRights]$permission.Rights
    $inheritance = $permission.Inherited

    # Get the current ACL
    $acl = Get-Acl -Path $folderPath

    # Create a new FileSystemAccessRule
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($identity, $rights, "ContainerInherit,ObjectInherit", "None", "Allow")

    # Add the new access rule to the ACL
    $acl.AddAccessRule($accessRule)

    # Set the new ACL to the folder
    Set-Acl -Path $folderPath -AclObject $acl
}

Write-Output "Permissions applied successfully."

```