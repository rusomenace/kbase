$ComputerList=Import-Csv "C:\Tools\VMWare\workstation.csv"
foreach ($Row in $ComputerList){
$Computer=$Row.computer
$vm = get-view -ViewType VirtualMachine -filter @{"Name"="$Computer"}
$vm.config | select name,nestedhvenabled,annotation
}