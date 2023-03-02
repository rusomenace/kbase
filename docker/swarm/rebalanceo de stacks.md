## Comando para balancear todos los stacks y organizar vms en cada worker

```
docker service ls -q | xargs -i docker service update {} --force --detach=false --update-parallelism=1 --update-delay=30s
```