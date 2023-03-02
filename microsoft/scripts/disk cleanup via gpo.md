# Disk Cleanup via GPO

Esta es la configuracion del archivo .bat via GPO
```
@Echo Off

:: Set all the CLEANMGR registry entries for Group #64

SET _Group_No=StateFlags0064

SET _RootKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches

:: Temporary Setup Files
REG ADD "%_RootKey%\Active Setup Temp Folders" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Branch Cache (WAN bandwidth optimization)
REG ADD "%_RootKey%\BranchCache" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Catalog Files for the Content Indexer (deletes all files in the folder c:\catalog.wci)
::REG ADD "%_RootKey%\Content Indexer Cleaner" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Delivery Optimization Files (service to share bandwidth for uploading Windows updates)
REG ADD "%_RootKey%\Delivery Optimization Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Diagnostic data viewer database files (Windows app that sends data to Microsoft)
REG ADD "%_RootKey%\Diagnostic Data Viewer database Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Direct X Shader cache (graphics cache, clearing this can can speed up application load time.)
REG ADD "%_RootKey%\D3D Shader Cache" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Downloaded Program Files (ActiveX controls and Java applets downloaded from the Internet)
REG ADD "%_RootKey%\Downloaded Program Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Downloads Folder (Automatically emptying this is probably a bad idea.)
::REG ADD "%_RootKey%\Downloads Folder" /v %_Group_No% /t REG_DWORD /d 00000002

:: Temporary Internet Files
REG ADD "%_RootKey%\Internet Cache Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Language resources Files (unused languages and keyboard layouts)
::REG ADD "%_RootKey%\Language Pack" /v %_Group_No% /t REG_DWORD /d 00000002

:: Offline Files (Web pages)
::REG ADD "%_RootKey%\Offline Pages Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Old ChkDsk Files
REG ADD "%_RootKey%\Old ChkDsk Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Recycle Bin
::::REG ADD "%_RootKey%\Recycle Bin" /v %_Group_No% /t REG_DWORD /d 00000002 /f
:::::: REMed out because Automatically emptying the Recycle Bin is almost never a good idea.

:: Retail Demo
::REG ADD "%_RootKey%\RetailDemo Offline Content" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Update package Backup Files (old versions)
REG ADD "%_RootKey%\ServicePack Cleanup" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Setup Log files (software install logs)
REG ADD "%_RootKey%\Setup Log Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: System Error memory dump files (These can be very large if the system has crashed)
REG ADD "%_RootKey%\System error memory dump files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: System Error minidump files (smaller memory crash dumps)
REG ADD "%_RootKey%\System error minidump files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Temporary Files (%Windir%\Temp and %Windir%\Logs)
REG ADD "%_RootKey%\Temporary Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Windows Update Cleanup (old system files not migrated during a Windows Upgrade)
REG ADD "%_RootKey%\Update Cleanup" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: User file history (Settings > Update & Security > Backup.)
::REG ADD "%_RootKey%\User file versions" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Thumbnails (Explorer will recreate thumbnails as each folder is viewed.)
REG ADD "%_RootKey%\Thumbnail Cache" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Windows Defender Antivirus
REG ADD "%_RootKey%\Windows Defender" /v %_Group_No% /d 2 /t REG_DWORD /f

:: Windows error reports and feedback diagnostics
REG ADD "%_RootKey%\Windows Error Reporting Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Electronic Software Delivery - used to "Reset your PC" to its factory default settings.
:: Don't clean up this unless you are prepared to Download & re-activate Windows if it crashes.
::::REG ADD "%_RootKey%\Windows ESD installation files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Windows Upgrade log files
REG ADD "%_RootKey%\Windows Upgrade Log Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: After setting the above registry entries, run CLEANMGR with the same group number:
cleanmgr.exe /sagerun:64

:: Clear the process
taskkill /F /im cleanmgr.exe
::taskkill /T /F /FI "IMAGENAME eq cleanmgr.exe"
Powershell -Command "Stop-Process -ProcessName 'cleanmgr' -Force"

::  Dism Cleanup
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
Dism.exe /online /Cleanup-Image /SPSuperseded
```

## matar la tarea de clean manager
En algunos casos el powershell para matar el proceso no funciona y se debe scriptear un nuevo bat con el siguiente comando para asegurar el finalizado del ejecutable
```
taskkill /F /IM cleanmgr.exe
```
## Ubicacion de archivos
En el dominio tq.com.ar se alojan en el AD en la siguiente ruta:
```
\\tq.com.ar\NETLOGON
```
En esa ubicacion se deberan colocar los archivos .bat

## Tarea programada
A continuacion se detallan las caracteristicas de la GPO

La configuracion aplica a **USUARIOS**

**Solapa General**
- User Configuration\Preferences\Control Panel Settings\Schedule Taks
- Accion: Update
- When running the task use the following account: NT AUTHORITY\SYSTEM
- Run with highest privileges
**Solapa Triggers**
- Se define una programacion por ejemplo todos los sabados o domingo a una hora especificada
**Solapa actions**
- Start a program: \\tq.com.ar\NETLOGON\masterrun.bat