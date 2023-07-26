# Como Resolver error: **UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Host key verification failed.", "unreachable": true}**

# Editar known_host

# SSH Keygen

```bash
ssh-keygen -R
```

The workaround with ansible would be to add this line in ansible.cfg under [defaults] section,

[defaults]
host_key_checking = False

> This will disable HostKeyChecking when making SSH connections.