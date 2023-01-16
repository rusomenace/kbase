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