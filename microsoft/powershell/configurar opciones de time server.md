Suggested Actions
You can configure the Domain Controller holding the PDCE role to use an NTP Server to synchronize time, there are several approaches:

To configure time synchronization via command line, on the PDC emulator open administrative Command Prompt and use the following commands:
```
w32tm.exe /config /syncfromflags:manual /manualpeerlist:131.107.13.100,0x8 /reliable:yes /update
```
```
w32tm.exe /config /update
```
**Note:** The IP address in the example is a National Institute of Standards and Technology (NIST) time server at Microsoft in Redmond, Washington. Replace this IP address with the time service of your choice.

To configure time synchronization via registry edit on the PDC emulator perform the following action:

Open Registry Editor(regedit.exe)
Navigate to the following registry key: ```HKLM\System\CurrentControlSet\Services\W32Time\Parameters```

To use a specific NTP source, modify the Type value to NTP
Modify the NtpServervalue to contain the NTP server to synchronize time with followed by 0x8, for example 131.107.13.100,0x8. 

Multiple NTP servers must be space-delimited, for example 131.107.13.100,0x8 24.56.178.140,0x8
Open an administrative Command prompt and execute the following command: w32tm /config /update
To configure time synchronization via Group Policy

## Open Group Policy Management Console
Create a new GPO
Open the GPO and navigate to Computer Settings -> Administrative Templates -> System -> Windows Time Service -> Time Providers
Double click the Configure Windows NTP Client.
Set the state to Enabled
Configure the Typeto NTP
Configure NTPServerto point to an IP address of a time server, followed by ,0x8, for example:  131.107.13.100,0x8
Close the Group Policy Editor
In the Security Filteringpane of the Group Policy management console remove Authenticated users for the newly created policy and add the machine that holds the PDC Emulatorrole
Link the GPO to Domain ControllersOU

Ref: https://learn.microsoft.com/en-us/services-hub/unified/health/remediation-steps-ad/configure-the-root-pdc-with-an-authoritative-time-source-and-avoid-widespread-time-skew