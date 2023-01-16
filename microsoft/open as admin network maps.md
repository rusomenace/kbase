There is an easier solution. To implement it, you have to make some changes to the registry:
- Open the registry editor (regedit.exe)
- Go to HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System 
- Create a new parameter (DWORD type) with the name EnableLinkedConnections and the value 1 
***Tip. The same can be done with a single command***
```
reg add «HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System» /v «EnableLinkedConnections» /t REG_DWORD /d 0x00000001 /f
```
- Restart your computer

## MS KB
Detail to configure the EnableLinkedConnections" registry entry
- In Registry Editor, locate and then click the following registry subkey: 
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
```
- Right-click Configuration, click New, and then click DWORD (32-bit) Value. 
- Name the new registry entry as EnableLinkedConnections.
- Double-click the EnableLinkedConnections registry entry. 
- In the Edit DWORD Value dialog box, type 1 in the Value data field, and then click OK.
- Exit Registry Editor, and then restart the computer.


