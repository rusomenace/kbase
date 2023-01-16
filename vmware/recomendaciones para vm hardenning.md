### VMs CONFIGURATION

VMWare tools autoinstall disable
```
isolation.tools.autoinstall.disable=true
```
Disable disk Shrink
```
isolation.tools.diskShrink.disable=true
```
Tools automated
```
isolation.tools.hgfsServerSet.disable=true
```
Deshabilitar HARD
```
floppyX.present=false
parallelX.present=false
serialX.present=false
```
Avoid DoS Limit log size
```
log.keepOld set to 10
log.rotateSize set to 100000
```
Disable VIX attacks
```
isolation.tools.vixMessage.disable=true
```
Host info
```
tools.guestlib.enableHostInfo=false
```
VMSafe protection
```
vmsafe.enable=false
```
