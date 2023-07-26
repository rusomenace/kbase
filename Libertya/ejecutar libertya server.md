# Como ejecutar libertya server (ubuntu)

## Cambiar a usuario root

```bash
sudo su
```

## Asegurarse que el servidor este detenido

```bash
at now -f /ServidorOXP/utils/DetenerServidor.sh.sh
```

Si está corriendo el servidor se detendrá, si no esta corriendo no hará nada.


## Iniciar servidor Libertya

```bash
at now -f /ServidorOXP/utils/IniciarServidor.sh
```

## Como ver el log en tiempo real

```bash
tail -f /ServidorOXP/jboss/server/libertya/log/server.log
```

