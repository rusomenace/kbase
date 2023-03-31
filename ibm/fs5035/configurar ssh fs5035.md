# Generating an SSH key pair using PuTTY

## Generate SSH keys using the PuTTY key generator (PuTTYgen):
* Start PuTTYgen by clicking Start > Programs > PuTTY > PuTTYgen. The PuTTY Key Generator panel is displayed.
* Click SSH-2 RSA as the type of key to generate.
Note: Leave the number of bits in a generated key value at 1024.
* Click Generate and then move the cursor around the blank area of the Key section to generate the random characters that create a unique key. When the key has been completely generated, the information about the new key is displayed in the Key section.
> Attention: Do not modify the Key fingerprint or the Key comment fields; this can cause your key to no longer be valid.
* *(Optional)* Enter a passphrase in the Key passphrase and Confirm passphrase fields. The passphrase encrypts the key on the disk; therefore, it is not possible to use the key without first entering the passphrase.
## Save the public key by:
* Click Save public key. You are prompted for the name and location of the public key.
* Type icat.pub as the name of the public key and specify the location where you want to save the public key. For example, you can create a directory on your computer called keys to store both the public and private keys.
* Click Save.
* Save the private key by:
* Click Save private key. The PuTTYgen Warning panel is displayed.
* Click Yes to save the private key without a passphrase.
* Type icat as the name of the private key, and specify the location where you want to save the private key. For example, you can create a directory on your computer called keys to store both the public and private keys. It is recommended that you save your public and private keys in the same location.
* Click Save.
* Close the PuTTY Key Generator window.

[Generating an SSH key pair using PuTTY](https://www.ibm.com/docs/en/flashsystem-7x00/7.8.x?topic=host-generating-ssh-key-pair-using-putty)

# Configuring a PuTTY session for the CLI

> You must configure a PuTTY session using the Secure Shell (SSH) password. If you require command line access without entering a password, use the SSH key pair that you created for the command-line interface (CLI).

**Attention:** Do not run scripts that create child processes that run in the background and call Storwize® V7000 commands. This can cause the system to lose access to data and cause data to be lost.

## Complete the following steps to configure a PuTTY session for the CLI:
* Select Start > Programs > PuTTY > PuTTY. The PuTTY Configuration window opens.
* Click Session in the Category navigation tree. The Basic options for your PuTTY session are displayed.
* Click SSH as the Protocol option.
* Click Only on clean exit as the Close window on exit option. This ensures that connection errors are displayed.
* Click Connection > SSH in the Category navigation tree. The options controlling SSH connections are displayed.
* Click 2 as the Preferred SSH protocol version.
* Click Connection > SSH > Auth in the Category navigation tree. The Options controller SSH authentication are displayed.
* Click Browse or type the fully qualified file name and location of the SSH client and password. If no password is used, the private key in the Private key file for authentication field.
* Click Connection > Data in the Category navigation tree.
* Type the user name that you want to use on the Storwize V7000 in the Auto-login username field.
* Click Session in the Category navigation tree. The Basic options for your PuTTY session are displayed.
* In the Host Name (or IP Address) field, type the name or Internet Protocol (IP) address of one of the Storwize V7000 clustered system (system) IP addresses or host names.
* Type 22 in the Port field. The Storwize V7000 system uses the standard SSH port.
* Type the name that you want to use to associate with this session in the Saved Sessions field. For example, you can name the session Storwize V7000 System 1.
Click Save.
## Results
* You have now configured a PuTTY session for the CLI.

> Note: If you configured more than one IP address for the Storwize V7000 system, repeat the previous steps to create another saved session for the second IP address. This can then be used if the first IP address is unavailable.

[Configuring a PuTTY session for the CLI](https://www.ibm.com/docs/en/flashsystem-7x00/7.8.x?topic=host-configuring-putty-session-cli)