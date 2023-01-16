**For PowerShell you'd put your custom Prompt() function in the relevant profile.**

Which can be set in your powershell profile
```
%userprofile%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

function Prompt {
    "PS ${env:USERNAME}@${env:COMPUTERNAME} $(Get-Location)> "
}
```

**For CMD you'd set/modify the PROMPT environment variable, e.g. via setx**
```
setx PROMPT "%"USERNAME"%"@"%"COMPUTERNAME"%"$s$m$p$g$s
```