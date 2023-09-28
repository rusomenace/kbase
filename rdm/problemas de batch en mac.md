# Batch edit option for connection lag

Following thread: https://forum.devolutions.net/topics/39913/batch-edit--password-only. My colleague describes a technique to batch edit fields using a custom script instead of the batch edit interface.

You should be able to follow the advice in that thread but substitute the following script to set the default TCP ack timeout:

```
set value of _connection of property "RDP.TcpAcknowledgementTimeout" to 30000
save _connection
```

# Modify additional fields

Unfortunately no. This requires a bit of hacking around to get this information. For instance, you could create a new entry, make minimal changes to it and export it. Afterwards you can make the changes you want to do with it and export it again, you can then compare the two exported files and you should see new/modified properties and this should give you the information.


Note that this is XML, so if a properties (e.g. <TcpAcknowledgementTimeout>) is inside another tag (e.g. <RDP>) this will give you a path (i.e. RDP.TcpAcknowledgementTimeout).