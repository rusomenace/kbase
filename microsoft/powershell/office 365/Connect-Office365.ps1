############################################################################################################################
###                                                                                                                      ###
###  	Script by Terry Munro -                                                                                          ###
###     Technical Blog -               http://365admin.com.au                                                            ###
###     Webpage -                      https://www.linkedin.com/in/terry-munro/                                          ###
###     TechNet Gallery Scripts -      http://tinyurl.com/TerryMunroTechNet                                              ###
###                                                                                                                      ###
###     TechNet Download link -        https://gallery.technet.microsoft.com/Office-365-Connection-364d270b              ###
###                                                                                                                      ###
###     Support -                      http://www.365admin.com.au/2017/01/how-to-connect-to-office-365-via.html          ###
###                                                                                                                      ###
###     Version 1.0 - 07/02/2017                                                                                         ###
###     Version 1.1 - 04/06/2017       Minor updates and updated name to show that it is a basic connection script       ### 
###                                                                                                                      ###
###                                                                                                                      ###
############################################################################################################################

###   Notes
###
###   This PowerShell connection script only connects to the following Office 365 Services
###   - Exchange Online
###   - Azure AD v1.0 - MSOL
###   - Azure AD v2.0 - Azure AD

###   For a PowerShell connection script that connects to ALL Office 365 Services, download my script for TechNet Gallery 
###   Download link - https://gallery.technet.microsoft.com/office/Office-365-and-Azure-e36eabeb


#####################################################################################################

###                      Edit the variable below with your details                                ###

$username = "hmaslowski@tqcorp.com"
$password = Get-Content "C:\Tools\Office365\tenantcreds.txt" | ConvertTo-SecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $password

#####################################################################################################

###
Import-Module MsOnline

###   Exchange Online
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection
Import-PSSession $Session 
Connect-ExchangeOnline -Credential $cred

###   Azure Active Directory v1.0
Connect-MsolService -Credential $cred