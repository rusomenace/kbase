# Unifi Manager certificate installation

I recently had similar problems with replacing the self-signed SSL cert included with the Unifi software, but I was able to overcome them.  This is the exact solution I used, and it worked for me.  There were several clues on this thread that lead me to the solution.  I am not trying to take credit for anyone elses work above, they just were complete enough for me in my situation so I thought others may be in the same boat.

***BACKUP YOUR UNIFI INSTALL BEFORE PROCEEDING***

I'm running the controller on a Windows VM
I tried using the process defined in the Wiki to generate the CSR and import the CRT (and chain).  Everything ran without error, so I restarted the controller software...leaving me unable to access the UI anymore at all.
I restored the %UNIFI_BASE%\data\keystore file from an earlier backup, restarted the controller software, and then the UI came back up with the old self-signed cert.
## Solution starts here
- Download "Keystore Explorer" (like someone else here recommended). (\\software\Software\Certificates esto es de TQ)
- Download "DigiCertUtil". (\\software\Software\Certificates esto es de TQ)
- Import your new cert into the DigiCert Util.
- Export the cert, including the private key, using the "key file (PKCS12)" option and use "aircontrolenterprise" as encryption password.
- Open up Keystore Explorer, and open up the "%UNIFI_BASE%\data\keystore" file (C:\Users\netadmin\Ubiquiti Unifi\data).  Use "aircontrolenterprise" as the password.
- From the "Tools" menu, choose "Import Key Pair".  The default option of PKCS #12 should be fine.
- Use "aircontrolenterprise" as the Decryption Password, and browse to the location of the file you created in Step 10.
- When Prompted for a "New Key Pair Alias", change it to simply "unifi" and click OK.
- You will be prompted to overwrite the existing alias.  Go ahead and click "Yes".
From the File menu, choose Save.
Close Keystore Explorer
Restart the Unifi software
You should be all set now.

