### Enable Copy and Paste Operations Between the Guest Operating System and Remote Console

To copy and paste between the guest operating system and remote console, you must enable copy and paste operations using the vSphere Client.
Procedure
1 Log into a vCenter Server system using the vSphere Client and select the virtual machine.
2 On the Summary tab, click Edit Settings.
3 Select Options > Advanced > General and click Configuration Parameters.
4 Click Add Row and type the following values in the Name and Value columns.
```
Name:isolation.tools.copy.disable
Value:false

Name:isolation.tools.paste.disable
Value:false
```
These options override any settings made in the guest operating system’s VMware Tools control panel.

5 Click OK to close the Configuration Parameters dialog box, and click OK again to close the Virtual Machine Properties dialog box.
6 Restart the virtual machine.

### PowerCLI
```
Connect-VIServer -Server 10.1.1.6 -Protocol https -User root -Password
get-vm W10-1803 | New-AdvancedSetting -Name isolation.tools.paste.disable -Value FALSE -Confirm:$false
get-vm W10-1803 | New-AdvancedSetting -Name isolation.tools.copy.disable -Value FALSE -Confirm:$false
```