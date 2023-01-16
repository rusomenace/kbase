## Cambiar switch mode por interface mode

Deshabilitar DHCP en LAN
Habilitar management en WAN2
```
config sys global
set internal-switch-mode interface
end
```

## VDOM
```
config system global
set vdom-admin enable
end
```