Durante el bastionado de servidor emergio el problema de que no deshabilitaba el VBS, para ello hay que realizar esta accion:

If Credential Guard is enabled with UEFI Lock, the EFI variables stored in firmware must be cleared using the command bcdedit.exe. From an elevated command prompt, run the following commands:

```sh
bcdedit /set {0cb3b571-2f2e-4343-a879-d86a476d7215} loadoptions DISABLE-LSA-ISO,DISABLE-VBS
bcdedit /set vsmlaunchtype off
```
Durante el proximo reinicio de Windows se debe aprobar la eliminacion de VBS.

Ref: https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/configure?tabs=reg#disable-credential-guard