$file = "c:\temp\WSUS_CleanUp_Wiz_{0:MMddyyyy_HHmm}.log" -f (Get-Date)
Start-Transcript -Path $file
$wsusserver = "tqarsvw16wsus01.tq.com.ar"
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")` | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer($wsusserver, $True,8531);
$cleanupScope = new-object Microsoft.UpdateServices.Administration.CleanupScope;
$cleanupScope.DeclineSupersededUpdates    = $true
$cleanupScope.DeclineExpiredUpdates       = $true
$cleanupScope.CleanupObsoleteUpdates      = $true
$cleanupScope.CompressUpdates             = $false
$cleanupScope.CleanupObsoleteComputers    = $true
$cleanupScope.CleanupUnneededContentFiles = $true
$cleanupManager = $wsus.GetCleanupManager();
$cleanupManager.PerformCleanup($cleanupScope);
Stop-Transcript