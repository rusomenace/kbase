#####################################################################################################

###                      Edit the variable below with your details                                ###

$username = "hmaslowski@tqcorp.com"
$password = Get-Content "C:\Tools\Office365\tenantcreds.txt" | ConvertTo-SecureString
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $password

#####################################################################################################

###   Teams Online

Connect-MicrosoftTeams -Credential $cred