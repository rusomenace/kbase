# Example query UUDI

## Toda la regla completa
```
show firewall policy | grep 8bce9e02-8bbb-51e9-d016-e8e35799b90e -f
```

## Solo nombre y id de regla
```
show firewall policy | grep -B 2 8bce9e02-8bbb-51e9-d016-e8e35799b90e 
```
