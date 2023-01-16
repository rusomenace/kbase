Import-Module SkypeOnlineConnector
$Cred = Get-credential "hmaslowski@tqcorp.com"
$cred
$sfbSession = New-CsOnlineSession -Credential $cred
Import-PSSession $sfbSession