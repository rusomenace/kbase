## Disabling SELinux

Use the getenforce or sestatus commands to check in which mode SELinux is running. The getenforce command returns Enforcing, Permissive, or Disabled.
The ```sestatus``` command returns the SELinux status and the SELinux policy being used:
```
$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      31
```
### Procedure

Open the ```/etc/selinux/config``` file in a text editor of your choice, for example:
```
nano /etc/selinux/config
```
Configure the SELINUX=disabled option:
```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of these two values:
#       targeted - Targeted processes are protected,
#       mls - Multi Level Security protection.
SELINUXTYPE=targeted
```
***Save the change, and restart your system:***
```
reboot
```
### Verification

After reboot, confirm that the getenforce command returns Disabled:

```
getenforce
```
Disabled

## Changing to permissive mode

### Procedure

Open the ```/etc/selinux/config``` file in a text editor of your choice, for example:
```
nano /etc/selinux/config
```
Configure the SELINUX=permissive option:
```
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#       enforcing - SELinux security policy is enforced.
#       permissive - SELinux prints warnings instead of enforcing.
#       disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of these two values:
#       targeted - Targeted processes are protected,
#       mls - Multi Level Security protection.
SELINUXTYPE=targeted
```
***Save the change, and restart your system:***
```
reboot
```
### Verification

After the system restarts, confirm that the getenforce command returns Permissive:
```
getenforce
```
Permissive





**Ref:** https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux

