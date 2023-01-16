# Fiber channel and zonning

## Facts
hba: host bus adapter
fcp: protocolo de comunicacion de FC
wwn: world wide name direcciones 16 hexa super largas
wwnn: world wide node name es el nombre asignado a un nodo en la red de storage y puede identificar varias interfaces de redes
wwpn: world wide port name es el nombre aignado en cada nodo a cada puerto, como en el caso de las placas con 2 puertos de FC y equivalen a la MAC en ethernet. Estan grabadas por el fabricante y son unicas
      ambas se asignan a storage y clients
domain id: cada switch tiene un domain id unico y no se puede cambiar, con mas de un switch aprenden cada nombre y manejan el ruteo entre ellos
fcid: es el equivalente a ip address en FC comando: show flogi database
fcns: fibre channel name service es como una table de ruteo de fcid comando: show fcns database
alua: asymetric logical unit assignment: maneja automaticamente el mejor path de acceso al storage
multipathing: ocurre a nivel iniciador con opcion de conexion activo/activo utilizando  alua
              la inteligencia de ruteo es a la inversa de networking ethernet, en vez de ocurrir en los dispositivos de networking ocurre a nivel software en los iniciadores

## Pasos para configurar una zona

1.Crear un alias que es como un acceso directo asociado al puerto del servidor de fiber channel, usar nombres descriptivos y claros como esxi01_hba1
  Los comandos de cli suelen ser alicreate y alishow: alicreate "esxi01_hba1", "10:xx:xx:xx"
  El valor 10:xx:xx:xx ahce referencia al WWPN world wide port name y es exclusivo, unico y harcode en cada placa y puerto de FC
  Para verificar la conectividad se puede usar el comando nodefind: 10:xx:xx:xx
  El alias se puede crear tanto en el switch como en el storage
2.Se puede crear una zona y agregar directamente los puertos
  zonecreate "zoneacme", "esxi01_hba1"; "array_port1" (array port corresponde a un grupo de puertos y en este ejemplo es sobre el storage
3.Verificar el estado de la zona
```
cfgactvshow | more  
```

4.Configuracion efectiva
```
cfg:activecfg1
```

5.Agregar la zona a la configuracion activa de la zona
```
cfgadd "activecfg1","zoneacme" o multiples zonas cfgadd "activecfg1","zoneacme";zoneacme2"
```

6.Salva la zonfiguracion activa
```
cfgsave
```

7.Habilitar la zona de configuracion activa
```
cfgenable "activecfg1"
```
  
Una recomendacion es que se crea una zona por cada servidor vinculado a cada storage pero este caso es para prevenir accesos de servers a luns incorrectas

Lun masking: para fijar un vinculo entre en un server y un nodo en particular

## Port-Channel-brocade trunking
Comandos para verificar los puertos
```
portcfgshow
switchshow
```

## Slow drain issue

b2b credits es un buffer que aplica a los puertos en entrada y salida sin esto el puerto no envia o recibe informacion
Por cada paquete se resta un valor y por cada recepcion y confirmacion se suma un valor

Ejemplo
b2b=40
Frame sent
resta 1 queda en 39
R_Ready receive
suma 1 vuelve a 40

El problema con el drain es cuando no se reciben los R_Ready y se pierde el credito de b2b en el caso del ejemplo los 40 llegan a 0 y no se puede transmitir mas datos
Esto generalmente esta relacionado con la falta de procesamiento de los dispositivos conectados
Hay que verificar si las placas tienen algun problema de descarte
