param (
    [switch]$RenameOrphanLayers
)
 
If ($RenameOrphanLayers) {
    Write-Warning "$($env:COMPUTERNAME) -RenameOrphanLayers option enabled, will rename all orphan layers"
}
 
# Get known layers on Docker images
[array]$ImageDetails += docker images -q | ForEach { docker inspect $_ | ConvertFrom-Json }
ForEach ($Image in $ImageDetails) {
    $ImageLayer = $Image.GraphDriver.Data.dir
     
    [array]$ImageLayers += $ImageLayer
    $LayerChain = Get-Content "$ImageLayer\layerchain.json"
    If ($LayerChainFileContent -ne "null") {
        [array]$ImageParentLayers += $LayerChain | ConvertFrom-Json
    }
}
 
# Get known layes on Docker containers
[array]$ContainerDetails = docker ps -a -q | ForEach { docker inspect $_ | ConvertFrom-Json}
ForEach ($Container in $ContainerDetails) {
    [array]$ContainerLayers += $Container.GraphDriver.Data.dir
}
 
# Get layers on disk
$LayersOnDisk = (Get-ChildItem -Path C:\ProgramData\Docker\windowsfilter -Directory).FullName
$ImageLayers += $ImageParentLayers
$UniqueImageLayers = $ImageLayers | Select-Object -Unique
[array]$KnownLayers = $UniqueImageLayers
$KnownLayers += $ContainerLayers
 
# Find orphan layers
$OrphanLayersTotal = 0
ForEach ($Layer in $LayersOnDisk) {
    If ($KnownLayers -notcontains $Layer) {
        [array]$OrphanLayer += $Layer
        $LayerSize = (Get-ChildItem -Path $Layer -Recurse -ErrorAction:SilentlyContinue | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum
        $OrphanLayersTotal += $LayerSize
        Write-Warning "$($env:COMPUTERNAME) - Found orphan layer: $($Layer -Replace '\r\n','') with size: $(($LayerSize -Replace '\r\n','') / 1MB) MB"
         
        If (($RenameOrphanLayers) -and ($Layer -notlike "*-removing")) {
            $LayerNewPath = $Layer + "-removing"
            Rename-Item -Path $Layer -NewName $LayerNewPath
        }
    }
}
 
Write-Host "$($env:COMPUTERNAME) - Layers on disk: $($LayersOnDisk.count)"
Write-Host "$($env:COMPUTERNAME) - Image layers: $($UniqueImageLayers.count)"
Write-Host "$($env:COMPUTERNAME) - Container layers: $($ContainerLayers.count)"
$OrphanLayersTotalMB = $OrphanLayersTotal / 1MB
Write-Warning "$($env:COMPUTERNAME) - Found $($OrphanLayer.count) orphan layers 
with total size $OrphanLayersTotalMB MB"
Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Restarting docker"
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Running"}))
{
    $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
    $svc.WaitForStatus('Stopped','00:00:20')
}
 
Get-Process | Where-Object {$_.Name -ilike "*docker*"} | Stop-Process -ErrorAction Continue -Confirm:$false -Force
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Stopped"} ))
{
    $svc | Start-Service
    $svc.WaitForStatus('Running','00:00:20')
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker restarted"

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Restarting docker"
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Running"}))
{
    $svc | Stop-Service -ErrorAction Continue -Confirm:$false -Force
    $svc.WaitForStatus('Stopped','00:00:20')
}
 
Get-Process | Where-Object {$_.Name -ilike "*docker*"} | Stop-Process -ErrorAction Continue -Confirm:$false -Force
 
foreach($svc in (Get-Service | Where-Object {$_.name -ilike "*docker*" -and $_.Status -ieq "Stopped"} ))
{
    $svc | Start-Service
    $svc.WaitForStatus('Running','00:00:20')
}

Write-Output "$((Get-Date).ToString("HH:mm:ss")) - Docker restarted"
# SIG # Begin signature block
# MIII0gYJKoZIhvcNAQcCoIIIwzCCCL8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwCSc4063lF80gEiCq1CbruV7
# EdigggYpMIIGJTCCBQ2gAwIBAgITXwAAAFluTg2U4E/zNQAAAAAAWTANBgkqhkiG
# 9w0BAQsFADBbMRIwEAYKCZImiZPyLGQBGRYCYXIxEzARBgoJkiaJk/IsZAEZFgNj
# b20xEjAQBgoJkiaJk/IsZAEZFgJ0cTEcMBoGA1UEAxMTdHEtVFFBUlNWVzE5REMw
# MS1DQTAeFw0yMTAzMDUxNzQyMTdaFw0yMzAzMDUxNzUyMTdaMIGTMRIwEAYKCZIm
# iZPyLGQBGRYCYXIxEzARBgoJkiaJk/IsZAEZFgNjb20xEjAQBgoJkiaJk/IsZAEZ
# FgJ0cTEMMAoGA1UECxMDYXJnMQ4wDAYDVQQLEwVzaXRlMDEOMAwGA1UECxMFdXNl
# cnMxCzAJBgNVBAsTAml0MRkwFwYDVQQDExBIZXJuYW4gTWFzbG93c2tpMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8RFaA6NLgfFjpehYwUu3UHAFos1d
# 3StT5iL3yzI8TV39vHJGM7ec5Q70ljDhlDgOcQDzXb9q8LEuxBp3zzvIuGlpQjsr
# +l5lemZQPOPvSLeR0C4X41iJ4cV+TkHkC9xPLMUqMtqYaCN2DwPsQsucXjzX3U9g
# tkUTCYkDCoJeIK3oDxSiUAwUbeAlo95s8ut0yoc1DHnMcenbAx2BOFAWYzPnRjKK
# zJDjLy5Vqd6fpU5snhz+5XKj+7U4ORcxMxjGyYZSOPSIqvFkd0JOvQp7OjHNhosT
# fqeLvlgy1GpRkCt+t0+c5xxvo37RCvcG0WQu55tGq7b2ozauYX+o4YBz3QIDAQAB
# o4ICpzCCAqMwPgYJKwYBBAGCNxUHBDEwLwYnKwYBBAGCNxUIgrXPdIfolG+G/Ych
# hv6IBYWJ3C2BFISdtguHnb1bAgFkAgEFMBMGA1UdJQQMMAoGCCsGAQUFBwMDMAsG
# A1UdDwQEAwIHgDAMBgNVHRMBAf8EAjAAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYB
# BQUHAwMwHQYDVR0OBBYEFN+x3kP2aRa1d+0bSbCRJB6wkO2eMB8GA1UdIwQYMBaA
# FO9XM8aez0sKEKDbJpx8ShLOs3wTMIHYBgNVHR8EgdAwgc0wgcqggceggcSGgcFs
# ZGFwOi8vL0NOPXRxLVRRQVJTVlcxOURDMDEtQ0EsQ049VFFBUlNWVzE5REMwMSxD
# Tj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMsQ049
# Q29uZmlndXJhdGlvbixEQz10cSxEQz1jb20sREM9YXI/Y2VydGlmaWNhdGVSZXZv
# Y2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50
# MIHGBggrBgEFBQcBAQSBuTCBtjCBswYIKwYBBQUHMAKGgaZsZGFwOi8vL0NOPXRx
# LVRRQVJTVlcxOURDMDEtQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZp
# Y2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9dHEsREM9Y29tLERD
# PWFyP2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9u
# QXV0aG9yaXR5MDAGA1UdEQQpMCegJQYKKwYBBAGCNxQCA6AXDBVobWFzbG93c2tp
# QHRxY29ycC5jb20wDQYJKoZIhvcNAQELBQADggEBALth0tNiuPtqGqRFdlWWQmAz
# obuEjOj7H/1h5Ry0H1Ve0cudUufItQalwJM4LLMpHAmlVKQbOwoBugrhnoGj0H4i
# zl1zqqM3/ZJb1iCgTt4n1R42r52pzs8clSOH4FrI0vJBfcC5W0gPPy4Ax1Gdls4Q
# FhE+KhFLgcPYHVwKfFTUDLHl9Z+n8Y4rU0pLOY8OxJeVP+SnYnlSj9hOufyLzHg8
# EK394FNhts9gFZPe4cJcD6od4W/kllsGg1FAEJWjJIM6gNsdh/kNu8lqpO+ckMXQ
# 9DYpxpEzZBa4oMPFrq6AUV4aB4om0kp/xkXopgtoEe8pkzwrG9FjP5IKplZ4M8Ex
# ggITMIICDwIBATByMFsxEjAQBgoJkiaJk/IsZAEZFgJhcjETMBEGCgmSJomT8ixk
# ARkWA2NvbTESMBAGCgmSJomT8ixkARkWAnRxMRwwGgYDVQQDExN0cS1UUUFSU1ZX
# MTlEQzAxLUNBAhNfAAAAWW5ODZTgT/M1AAAAAABZMAkGBSsOAwIaBQCgeDAYBgor
# BgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBS2
# fix1/R83RziSVH8R+wDc4xWHFDANBgkqhkiG9w0BAQEFAASCAQAgoR3xVBW4SWxx
# P0kz9uSaKfA9+uRLHSr5Q39svLAlkNUwbag+Ucipu0qWjOM5aFG7O/S5jH/wzPVg
# +pv1cloddXYeb6zIZoStlK922fUccc9UDW/+daQUvU5VPtqkHWAALZHgBB0BZZu2
# BXTqIm83Z1bnF69Ab4HBejAO5dDWNQdAVhKklUhn3ix8VoVfQQMIOLxjDJ0HMGHY
# HCcE0zfhvjvAqV9xwV15m6K4UWcnEqEuSYtehd+6f9BPcTusLOQB9C75gU7RC7VM
# Rdc0Qajnrsq7D+ccuitC276GngzlGhwxoAOTSLDNS8b+CtqauY8u3CW7CP95btCe
# okJwRn53
# SIG # End signature block
