$menu=@"
1 Get all VMs tags
2 Get specific VMs with tags
3 Get VMs with no tags

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
    $vmTags = Get-VM | Get-TagAssignment | Select-Object -Property Entity, Tag
    $vmTags
	}
"2" {
    $tag = read-host "Nombre del tag, agregar *?"
    Write-Verbose -Message "Search tag result" -Verbose
    Write-Progress -Activity "Getting requested tags" -Status "Executing" 
    Get-TagAssignment | Where-Object {$_.Tag -like "$tag"}
    }
"3" {
    $VMnoTag = Get-VM | Where-Object { -not (Get-TagAssignment $_) }
    $VMnoTag | Select-Object -Property Name, Notes
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
