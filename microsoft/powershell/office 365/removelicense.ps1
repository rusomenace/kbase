# $cred = Get-Credential 
# Connect-MsolService -Credential $cred 
$licensedUsers = Get-MsolUser -All | ? {$_.isLicensed -eq "TRUE"} 
ForEach ($licensedUser in $licensedUsers) 
{
Write-Host "---------------------------------" 
Write-Host "UserPrincipalName-"$licensedUser.UserPrincipalName 
$accountSku = $licensedUser.Licenses.AccountSkuId 
Write-Host $accountSku 
# Disabled Plans 
$disabledPlans= @() 
$disabledPlans +="tqcorp:STREAM"
# $disabledPlans +="FLOW_O365_P2" agregar adicionales conforme convenga
$licensesAssigned = $licensedUser.Licenses.ServiceStatus 
foreach ($serviceStatus in $licensesAssigned) 
{ 
# A bit of logic to check if its not already disabled as we don't want to add twice 
if($serviceStatus.ProvisioningStatus -eq "Disabled")
{
$planName = $serviceStatus.ServicePlan.ServiceName 
Write-Host "Already Disabled - "$planName 
# if($planName -eq "FLOW_O365_P2" -or $planName -eq "POWERAPPS_O365_P2") en el caso de mas de un plan
if($planName -eq "tqcorp:STREAM")
{
# Do nothing as already added above
}
else
{
# Add to array as we want to keep it disabled 
$disabledPlans += $planName
}
}
}
# Now ready to create license Options and disable plabs for that user 
Write-Host "Disabling following licenses for user" 
Write-Host $disabledPlans
$licenseOptions = New-MsolLicenseOptions -AccountSkuId $accountSku -DisabledPlans $disabledPlans; 
Set-MsolUserLicense -UserPrincipalName $licensedUser.UserPrincipalName -LicenseOptions $licenseOptions
}