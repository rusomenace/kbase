#Clear the file output content
Clear-Content C:\Tools\Wsus\Machines.txt

#Server List
Get-ADComputer -Filter {OperatingSystem -Like "*Server*"} | Select -Expand Name | Out-File C:\Tools\Wsus\Machines.txt

#No Servers
#Get-ADComputer -Filter {OperatingSystem -NotLike "*Server*"} | Select -Expand Name | Out-File C:\Test\Test.txt

#Export from specific Out-File
#Get-ADComputer -filter {Enabled -eq $True} -Properties cn -SearchBase "OU=servers,OU=computers,DC=example,DC=example" | select cn | ConvertTo-Csv -NoTypeInformation | Select-Object -skip 1 | Out-File d:\output.csv