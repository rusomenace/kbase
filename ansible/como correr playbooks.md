# Como correr playbooks?

## De forma regular

```bash
ansible-playbook playbook_file.yml
```

## Correrlos con privilegios (sudo)

```bash
ansible-playbook --ask-become-pass playbook_file.yml
```