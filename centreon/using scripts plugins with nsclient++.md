Using Scripts / Plugins With NSClient++
Overview
This KB article explains how to use external scripts / plugins with NSClient++.

NSClient++ has a lot of built in functionality however you will likely run into a situation where you need to use a script to provide additional monitoring capabilities.

NSClient++ is capable of executing scripts such as:

Batch Script = .bat

Visual Basic Script = .vbs

PowerShell Script = .ps1

This KB article will  provide examples for these three types of scripts as each method is slightly different.

Requirements

This KB article uses NSClient++ version 0.4.x (and future versions) which requires the NRPE module to be enabled (scripts are not possible with check_nt). Please ensure NSClient has been configured correctly as per these KB articles:

Documentation - Configuring NSClient++

In addition to these settings, execute the follow commands on your windows server (in a command prompt) to ensure the External Scripts module is correctly loaded:

cd "\Program Files\NSClient++\" 
nscp settings --activate-module CheckExternalScripts --add-defaults
nscp settings --path "/settings/external scripts" --key "allow arguments" --set true
Batch Script

This example demonstrates how to add a batch script to NSClient++.

For this example you are going to create a basic script that takes two arguments.

Argument 1 = A number  (0, 1, 2, 3) that will be used as the exit code the script will exit with (this is how Nagios determines the status)

Argument 2 = A message that the script will display

Create Batch ScriptDisplay name
:
ArgoCD
Application (client) ID
:
72b6ef81-cfb7-4bcf-a6e6-1aff51eb1a5c
Object ID
:
13957018-4539-4d1f-8386-f21d0c2a0035
Directory (tenant) ID
:
3c206aca-d6e9-4290-9330-78ae7e2a2292

On your windows machine open the Notepad program.

Type / paste the following into Notepad.

@echo off 
if [%1] == [] echo No exit code was supplied, aborting! & exit /B 3 
if [%2] == [] echo No dummy message was supplied, aborting! & exit /B 3 
echo %~2 
exit /B %1%
Save the file into C:\Program Files\NSClient++\scripts with the name check_dummy.bat

Open a command prompt on your Windows machine and execute the following commands:

cd "\Program Files\NSClient++\scripts"
check_dummy.bat 2 "Something is CRITCAL"
echo %errorlevel%
The output will be as follows:

C:\Program Files\NSClient++\scripts>check_dummy.bat 2 "Something is CRITICAL" 
Something is CRITICAL 
 
C:\Program Files\NSClient++\scripts>echo %errorlevel% 
2
The output from the first command is what will be displayed in Nagios.

The output from the second command, the number 2, is how Nagios will determine that this plugin is reporting a CRITICAL state.

Update nsclient.ini Configuration File
Now you need to tell NSClient++ how to use the script.

Open the file C:\Program Files\NSClient++\nsclient.ini in Notepad.

Find this section in the file:

[/settings/external scripts/scripts]
If it doesn't exist then add it to the end of the file.

Under this section add the following line:

check_dummy_bat = scripts\\check_dummy.bat $ARG1$ "$ARG2$"
Save the file and then use services.msc to restart the NSClient++ service.

Test Script From Nagios
The last step is to test the script from your Nagios server. Open an SSH session to Nagios and execute the following:

/usr/local/nagios/libexec/check_nrpe -H your_windows_server_ip_address -c check_dummy_bat -a 2 "Something is CRITICAL"
echo $?
The output should look like this:

/usr/local/nagios/libexec/check_nrpe -H your_windows_server_ip_address -c check_dummy_bat -a 2 "Something is CRITICAL"
Something is CRITICAL|

echo $?
2
The output from the first command is what will be displayed in Nagios.

The output from the second command, the number 2, is how Nagios will determine that this plugin is reporting a CRITICAL state.

This completes the example of configuring NSClient++ to use a batch script. You will now need to go and create a service in Nagios XI (this falls outside the scope of this KB article).

Visual Basic Script

This example demonstrates how to add a visual basic script (vbs) to NSClient++.

For this example you are going to create a script that takes two arguments.

Argument 1 = A number  (0, 1, 2, 3) that will be used as the exit code the script will exit with (this is how Nagios determines the status)

Argument 2 = A message that the script will display

Create Visual Basic Script
On your windows machine open the Notepad program.

Type / paste the following into Notepad.

on error resume next 
If wscript.Arguments.Count < 1 Then 
    wscript.Echo "No exit code was supplied, aborting!" 
    wscript.Quit(3) 
ElseIf Wscript.Arguments.Count < 2 Then 
    wscript.Echo "No dummy message was supplied, aborting!" 
    wscript.Quit(3) 
End If 
wscript.Echo wscript.arguments.item(1) 
wscript.Quit(wscript.arguments.item(0)) 
Save the file into C:\Program Files\NSClient++\scripts with the name check_dummy.vbs

Open a command prompt on your Windows machine and execute the following commands:

cd "\Program Files\NSClient++\scripts"
cscript.exe //T:30 //NoLogo check_dummy.vbs 2 "Something is CRITCAL"
echo %errorlevel%
The output will be as follows:

C:\Program Files\NSClient++\scripts>cscript.exe //T:30 //NoLogo check_dummy.vbs 2 "Something is CRITCAL"
Something is CRITICAL 
 
C:\Program Files\NSClient++\scripts>echo %errorlevel% 
2
The output from the first command is what will be displayed in Nagios.

The output from the second command, the number 2, is how Nagios will determine that this plugin is reporting a CRITICAL state.

You need to execute the check_dummy.vbs script using cscript.exe as if forces the command to run in a command prompt and all output is passed to the command prompt.

//T:30 is a timeout of 30 seconds

//NoLogo suppresses the Microsoft banner from being displayed

Update nsclient.ini Configuration File
Now you need to tell NSClient++ how to use the script.

Open the file C:\Program Files\NSClient++\nsclient.ini in Notepad.

Find this section in the file:

[/settings/external scripts/scripts]
If it doesn't exist then add it to the end of the file.

Under this section add the following line:

check_dummy_vbs = cscript.exe //T:30 //NoLogo scripts\\check_dummy.vbs $ARG1$ "$ARG2$"
Save the file and then use services.msc to restart the NSClient++ service.

Test Script From Nagios
The last step is to test the script from your Nagios server. Open an SSH session to Nagios and execute the following:

/usr/local/nagios/libexec/check_nrpe -H your_windows_server_ip_address -c check_dummy_vbs -a 2 "Something is CRITICAL"
echo $?
The output should look like this:

/usr/local/nagios/libexec/check_nrpe -H your_windows_server_ip_address -c check_dummy_vbs -a 2 "Something is CRITICAL"
Something is CRITICAL|

echo $?
2
The output from the first command is what will be displayed in Nagios.

The output from the second command, the number 2, is how Nagios will determine that this plugin is reporting a CRITICAL state.

This completes the example of configuring NSClient++ to use a visual basic script. You will now need to go and create a service in Nagios XI (this falls outside the scope of this KB article).

PowerShell Script

This example demonstrates how to add a PowerShell script to NSClient++.

For this example you are going to create a basic script that takes two arguments.

Argument 1 = A number  (0, 1, 2, 3) that will be used as the exit code the script will exit with (this is how Nagios determines the status)

Argument 2 = A message that the script will display

Create PowerShell Script
On your windows machine open the Notepad program.

Type / paste the following into Notepad.

if ($args.count -lt 1) { write-host "No exit code was supplied, aborting!"; exit 3 } 
if ($args.count -lt 2) { write-host "No dummy message was supplied, aborting!"; exit 3 } 
write-host $args[1] 
exit $args[0] 
Save the file into C:\Program Files\NSClient++\scripts with the name check_dummy.ps1

Open a command prompt as an administrator on your Windows machine and execute the following command:

powershell.exe Set-ExecutionPolicy Bypass
That command configured PowerShell to run scripts and is required.

Now execute the following commands:

cd "\Program Files\NSClient++\scripts"
powershell.exe -File check_dummy.ps1 2 "Something is CRITICAL"
echo %errorlevel%
The output will be as follows:

C:\Program Files\NSClient++\scripts>powershell.exe -File check_dummy.ps1 2 "Something is CRITICAL"
Something is CRITICAL 
 
C:\Program Files\NSClient++\scripts>echo %errorlevel% 
2
The output from the first command is what will be displayed in Nagios.

The output from the second command, the number 2, is how Nagios will determine that this plugin is reporting a CRITICAL

state.

Update nsclient.ini Configuration File
Now you need to tell NSClient++ how to use the script.

Open the file C:\Program Files\NSClient++\nsclient.ini in Notepad.

Find this section in the file:

[/settings/external scripts/scripts]
If it doesn't exist then add it to the end of the file.

Under this section add the following line:

check_dummy_ps1 = cmd /c echo scripts\\check_dummy.ps1 $ARG1$ "$ARG2$"; exit($lastexitcode) | powershell.exe -command -
Save the file and then use services.msc to restart the NSClient++ service.

Test PowerShell Script From Nagios
The last step is to test the script from your Nagios server. Open an SSH session to Nagios and execute the following:

/usr/local/nagios/libexec/check_nrpe -H your_windows_server_ip_address -c check_dummy_ps1 -a 2 "Something is CRITICAL"
echo $?
The output should look like this:

/usr/local/nagios/libexec/check_nrpe -H your_windows_server_ip_address -c check_dummy_ps1 -a 2 "Something is CRITICAL"
Something is CRITICAL|

echo $?
2
The output from the first command is what will be displayed in Nagios.

The output from the second command, the number 2, is how Nagios will determine that this plugin is reporting a CRITICAL state.

This completes the example of configuring NSClient++ to use a PowerShell script. You will now need to go and create a service in Nagios XI (this falls outside the scope of this KB article).