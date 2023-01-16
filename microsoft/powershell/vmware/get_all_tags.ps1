<#
.Synopsis
This is the short description
.Description
Este comando trae todos los tags de todas las VMs en vcenter
.Example
$vmTags = Get-VM | Get-TagAssignment
#>
$vmTags = Get-VM | Get-TagAssignment
$vmTags