# Updating drive firmware

## GUI
This procedure updates firmware on a drive that is in the control enclosure or in one of the expansion enclosures. If the update would cause any volumes to go offline, the force option is required.

To update drive firmware for all drives by using the management GUI, select **Pools > Internal Storage > Actions > Update All**. You can also update individual drives.

## CLI
1. Run the following command for the drive that you are updating.
```
lsdependentvdisks -drive drive_id
```
If any volumes are returned, continuing with this procedure takes the volumes offline. To avoid losing access to data, resolve any redundancy errors to remove this problem before you continue with the update procedure.

2. Locate the firmware update file at the following website:
www.ibm.com/support

www.ibm.com/support/docview.wss?uid=ssg1S1004229

This website also provides a link to the Software Update Test Utility. This utility indicates whether any of your drives are not running at the latest level of firmware.

3. Using scp or pscp, copy the firmware update file and the Software Update Test Utility package to the /home/admin/upgrade directory by using the management IP address.

4. Run the applydrivesoftware command. You must specify the firmware update file, the firmware type, and either a list of drive IDs or the parameter -all to specify all drives:
```
applydrivesoftware -file name -type firmware -drive drive_id
```
To apply the update even if it causes one or more volumes to go offline, specify the -force option. Using the -force option can cause the loss of data. Use the -force option under the direction of a service representative.

> **Attention:** Do not use the -type fpga option, which updates Field Programmable Gate Array (FPGA) firmware, unless directed to do so by a service representative.

[Source](https://www.ibm.com/docs/en/flashsystem-5x00/8.2.x?topic=system-updating-drive-firmware)