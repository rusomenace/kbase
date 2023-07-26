# Solucionar error "could not activate connection device is strictly unmanaged" en nmtui

## Step 1 - Check for netplan settings

Make sure renderer is NetworkManager in the /etc/netplan/:

ls /etc/netplan/
# if config file is 01-network-manager-all.yaml

```bash
cat /etc/netplan/01-network-manager-all.yaml
```

Check for /etc/NetworkManager/NetworkManager.conf file too:

```bash
sudo cat /etc/NetworkManager/NetworkManager.conf
```

## Step 2 - List managed devices

Type:

```bash
nmcli device
```

Note down unmanaged devices and their type, such as wifi, ethernet, wireguard, etc.

## Step 3 - Check /etc/NetworkManager/conf.d/ directory

Make sure your device is not marked as unmanaged-devices

```bash
sudo grep -ri unmanaged-devices /etc/NetworkManager/conf.d/
sudo grep -ri unmanaged-devices /etc/NetworkManager/
```

## Step 4 - Check for /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf file

```bash
sudo vim /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
```

Make sure Ethernet, Wifi, WireGuard all set as exception. Here is how it looks when ethernet and wireguard disabled:

```ini
[keyfile]
unmanaged-devices=*,except:type:wifi,except:type:gsm,except:type:cdma
```

Add ethernet by appending to the unmanaged-devices list. For example:

```
except:type:ethernet
```

Here is how it should look:

```ini
[keyfile]
unmanaged-devices=*,except:type:wifi,except:type:gsm,except:type:cdma,except:type:ethernet
```

Finally reload config:

```bash
sudo systemctl reload NetworkManager.service 
```

Verify it:

```bash
nmcli device
nmcli connection show
```

Turn networking off and on again:

```bash
nmcli networking off
nmcli networking on
```

Test it:

```bash
nmcli connection up wg0
nmcli connection up 'Wired connection 1'
```