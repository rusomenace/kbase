# Migracion de DFS a DFSR

Forzar la replicacion para que vaya todo mas rapido
```
Repadmin /syncall /force /APed
```

Verificar la publicacion del SYSVOL
```
Dcdiag /e /test:sysvolcheck /test:advertising
```

Verificar DNS
```
DCDiag /Test:DNS /e /v
```

## DFS a DFSR
1)
```
Dfsrmig /setglobalstate 1
Dfsrmig /getmigrationstate
```
2)
```
Dfsrmig /setglobalstate 2
Dfsrmig /getmigrationstate
```
3)
```
Dfsrmig /setglobalstate 3
Dfsrmig /getmigrationstate
```
### Comando para verificar el exito de la migracionde DFS-R

Type **dfsrmig /getglobalstate** to verify that the global migration state is Eliminated. The following output appears if the global migration state is Eliminated.
```
Current DFSR global state: ‘Eliminated’ 
Succeeded.
```
Type **dfsrmig /getmigrationstate** to confirm that all domain controllers have reached the Eliminated state. The following output should appear when all domain controllers reach the Eliminated state.
```
All Domain Controllers have migrated successfully to Global state (‘Eliminated’). 
Migration has reached a consistent state on all Domain Controllers. 
Succeeded.
```
This step can take some time. The time needed for all of the domain controllers to reach the prepared state depends on Active Directory latencies and the amount of data present in the SYSVOL shared folder.

On each domain controller in the domain, open a command prompt window and type **net share** to verify that the SYSVOL shared folder is shared by each domain controller in the domain and that this shared folder maps to the SYSVOL_DFSR folder that DFS Replication is replicating. Text that is similar to the following should appear as part of the output of the command.

Share name   Resource                        Remark
```
--------------------------------------------------------------------------------
[…]
NETLOGON     C:\Windows\SYSVOL_DFSR\sysvol\corp.contoso.com\SCRIPTS
                                             Logon server share
SYSVOL       C:\Windows\SYSVOL_DFSR\sysvol   Logon server share
```

## Policy definitions folder


To create a Central Store for .admx and .adml files, create a new folder named PolicyDefinitions in the following location (for example) on the domain controller:
```
\\contoso.com\SYSVOL\contoso.com\policies\PolicyDefinitions
```
When you already have such a folder that has a previously built Central Store, use a new folder describing the current version such as:
```
\\contoso.com\SYSVOL\contoso.com\policies\PolicyDefinitions-1803
```
Copy all files from the PolicyDefinitions folder on a source computer to the new PolicyDefinitions folder on the domain controller. The source location can be either of the following ones:
```
The C:\Windows\PolicyDefinitions folder on a Windows 8.1-based or Windows 10-based client computer
The C:\Program Files (x86)\Microsoft Group Policy\<version-specific>\PolicyDefinitions folder, if you have downloaded any of the Administrative Templates separately from the links above.
```
Links: 

- [Migracion DFS oficial de technet](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-r2-and-2008/dd640254(v=ws.10))
- [Streamline migration](https://techcommunity.microsoft.com/t5/storage-at-microsoft/streamlined-migration-of-frs-to-dfsr-sysvol/ba-p/425405)

Examen cervantes ciudadania
Instituto cervantes prueba ccse