## Registry edition

```
Press Shift + F10
```
A DOS box appears. Typ regedit and hit enter

Navigate to **HKEY_LOCAL_MACHINE\SYSTEM\Setup** and create a new Key named LabConfig
```
hklm\system\setup\LabConfig\
```
Create in the LabConfig Key a ```ByPassTPMCheck DWORD (32-bit)``` with the value of 1
Close the Regedit window
Type exit to leave the command prompt
Click on the Red X in the right corner and the setup will start again

## How to install Windows 11 on unsupported devices
Microsoft's official bypass is to add a Registry value named ```AllowUpgradesWithUnsupportedTPMOrCPU``` and then install Windows 11 using bootable media.

The whole registry entry required can be seen below.

```
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup]
"AllowUpgradesWithUnsupportedTPMOrCPU"=dword:00000001
```