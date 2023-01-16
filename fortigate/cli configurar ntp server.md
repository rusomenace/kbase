## A custom NTP server can be configured via CLI as follows:
```
config system ntp 
set ntpsync enable 
set type custom        -----> Change type first
set syncinterval 1 
config ntpserver 
edit 1 
set server "1.1.1.1"   -----> NTP server IP 
set ntpv3 disable 
next 
end 
set source-ip 0.0.0.0 
set server-mode disable 
end
```