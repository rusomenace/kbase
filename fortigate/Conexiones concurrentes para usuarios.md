Modo global a todo el firewall:
```
config system global
set policy-auth-concurrent 1
end
```
With the auth-concurrent limit is set to 1, user can login from only 1 source IP.
Auth-concurrent setting can also be configured at user group or user level. If the concurrent setting is set at user or group level, it will have precedence over the global setting.
```
config user local
edit <name>
set auth-concurrent-override enable
set auth-concurrent-value (1-100)
end
```
***Note :***

The priority of the auth-concurrent setting is  User group > User > Global setting.
The auth-concurrent setting applies per VDOM. If the user is authenticated in one firewall policy, he will not beallowed to authenticated.
```
Auth-concurrent setting only applies to firewall authentication or captive portal authentication users.
```
