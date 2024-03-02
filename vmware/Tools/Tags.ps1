$menu=@"
1 Get all VMs tags
2 Get specific VMs with tags
3 Get VMs with no tags
4 s

Q Quit

Select a task by number or Q to quit
"@
""
do
{
""
$r = Read-Host $menu

Switch ($r) {
"1"	{	
    $vmTags = Get-VM | Get-TagAssignment
    $vmTags
	}
"2" {
    $tag = read-host "Nombre del tag, agregar *?"
    Write-Verbose -Message "Search tag result" -Verbose
    Write-Progress -Activity "Getting requested tags" -Status "Executing" 
    Get-TagAssignment | Where-Object {$_.Tag -like "$tag"}
    }
"3" {
    $VMnoTag = Get-VM | Where-Object{(Get-TagAssignment $_) -eq $null}
    $VMnoTag | Where-Object  {($_.name -Match "TQARSV*") -and ($_.name -ne "TQARSVW19DC03") -and ($_.name -ne "TQARSVW19UBQT01")}  | Select-Object -Property Name, Notes
    }
"Q" {
    Write-Host "Quitting" -ForegroundColor DarkCyan
    exit	
    }
default {
    Write-Host "I don't understand what you want to do, try again" -ForegroundColor Yellow
        }
} #end switch
}
until ($selection -eq 'Q')