## How to delete files from datastore
 
#### Datastore FS5010
```
find /vmfs/volumes/5f99f272-687c2a44-7846-48df37db591c -name vmware-*.log -exec rm {} \;
 ```
#### Datastore DS2200
```
find /vmfs/volumes/600117a6-dd2054c8-7305-040973d93f10 -name vmware-*.log -exec rm {} \;
```
**Ref:** https://unix.stackexchange.com/questions/167823/finds-exec-rm-vs-delete
