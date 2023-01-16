# SNMP Rules

netsh advfirewall firewall add rule name="SNMP UDP Port 161 In" dir=in action=allow protocol=UDP localport=161
netsh advfirewall firewall add rule name="SNMPTRAP UDP Port 162 In" dir=in action=allow protocol=UDP localport=162
netsh advfirewall firewall add rule name="SNMP UDP Port 161 Out" dir=out action=allow protocol=UDP localport=161
netsh advfirewall firewall add rule name="SNMPTRAP UDP Port 162 Out" dir=out action=allow protocol=UDP localport=162
