## As an administrator of office 365, we can change other users photo via the steps below

1. log into exchange admin center (https://outlook.office365.com/ecp/) with your office 365 admin account.

2. click the upper right corner and select “another user”>> select the user whose photo you want to change.

3. click “edit information…” to change the user’s photo.

in this way, we don’t need to sign in to each user’s office 365 account page. however, we still need to open each user's account information page to change their picture.

note:to do that, please make sure you have been granted the following admin roles. if not, you cannot view the edit information… option in the user's page.
When you run ```Get-OwaMailboxPolicy | Set-OwaMailboxPolicy -SetPhotoEnabled $false``` without defining an Outlook Web App Policy by using -Identity parameter, it disables the feature for all Outlook Web App Policies in your tenant. Including the default Outlook Web Access Policy.

If you want to disable the feature for a specific set of users, then you can create a new Outlook Web App Policy, assign it to those who you wish to disable this feature, and then run the command as below.

### Eliminar la URL para definir una Foto
```
Get-OwaMailboxPolicy -Identity "OWAMailboxPolicy-Default" | Set-OwaMailboxPolicy -SetPhotoURL $false
```
### Habilitar o no la foto de perfil
```
Set-OwaMailboxPolicy -Identity "OWAMailboxPolicy-Default" -SetPhotoEnabled $True
```
## Consultar politica que aplica al usuario
```
Get-CASMailbox -Identity mdojman@tqcorp.onmicrosoft.com  | FL *owamailboxpolicy*
```