$tag = read-host "Nombre del tag, agregar *?"
Write-Verbose -Message "Search tag result" -Verbose
Write-Progress -Activity "Getting requested tags" -Status "Executing" 
Get-TagAssignment | where {$_.Tag -like "$tag"}