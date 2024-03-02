Get-VM | Get-HardDisk | Select-Object Parent, Name, @{Name="DatastoreFolder"; Expression={(Get-Datastore -Id $_.Datastore).Name + $_.Parent}}
