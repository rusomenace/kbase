$username = "hmaslowski@tqcorp.com"
$password = "Macoco78."
$cred = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $userName, $(convertto-securestring $Password -asplaintext -force)
Connect-SPOService -Url https://tqcorp-admin.sharepoint.com -Credential $cred