# --------------------------------------------------------- #
# |       Written by UnknownWorkspace | 25.05.2022        | #
# |-------------------------------------------------------| #
# |   The Nagios Plugin checks last run status and time   | #
# |          from Veeam Backup for Microsoft 365          | #
# --------------------------------------------------------- #

# Global variables
$name = $args[0]
$period = $args[1]
$critical = '0'
$warning = '0'

# Check job type and avoid syntax errors
if ($name -eq 'all'){
    $bck = Get-VBOJob
}else{
    $bck = Get-VBOJob -Name $name
    if ($null -eq $bck){
        Write-Host "UNKNOWN! '$name': No such job"
        exit 3
    }
}

# Veeam Backup job status check
foreach ($a in $bck){
    $name = $a.Name
#    $job = Get-VBOJob -Name $name / comented because there is no use in the script
    $lastrun = (Get-VBOJob -Name $name).LastRun
    $status = (Get-VBOJob -Name $name).LastStatus

    if ($status -eq "Failed"){
        Write-Host "CRITICAL! Errors were encountered during the backup process of the following job: '$name'."
        $critical = '1'
    }

    if ($status -ne "Success"){
        Write-Host "WARNING! Job '$name' didn't fully succeed."
        $warning = '1'
    }

    # Veeam Backup job last run check
    $now = (Get-Date).AddDays(-$period)
    $period = (Get-Date)
    $now = $now.ToString("yyyy-MM-dd")
        
    if((Get-Date $now) -gt (Get-Date $lastrun)){
        Write-Host "CRITICAL! Last run of job: '$name' more than $period days ago."
        $critical = '1'
    } else {
        $log += "** Job: '$name' executed $period ** "
    }
}

# Calculating exit code
if ($critical -ne '0') {
    exit 2 
} elseif ($warning -ne '0') {
    exit 1
} else {
    write-host $log
    exit 0
}
