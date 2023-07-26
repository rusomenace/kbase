# Como renombrar un servidor Linux

```bash
sudo hostnamectl set-hostname NEWSERVERNAME
```

Chequeamos que el nombre se haya aplicado correctamente

```bash
hostnamectl
```

Editamos el archivo host para evitar que el servidor intente resolver su propio nombre contra la red y lo haga localmente:

```bash
sudo nano /etx/hosts
```

Editamos la linea que contenga el 127.0.1.1

```
127.0.1.1 NEWSERVERNAME
```