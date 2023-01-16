## Brocade commands are usually very easy to find out. Simply type “help”, but what exactly does each command do? Here’s a list:
```
Info
uptime                          – Same as unix uptime
date                            – Same as unix date
version                         – Gives versions of firmwares & OS
```
## Hardware State
```
faultshow                     – Show switch faults
fanshow                       – Show switch FAN faults
psshow                        – Show switch POWER SUPPLY faults
tempshow                      – Show switch TEMPERATURE values
switchstatusshow              – Overall status of switch
```

## Config
```
agtcfgshow                  – Show SNMP config
configshow                  – Show switch config
gbicshow                    – Show GBIC slots and serial numbers
licenseshow                 – Show license data
supportshow                 – Like Sun’s explorer – gets many configs at once
switchshow                  – Show switch ports and connections
zoneshow                    – Show zone and switch aliases
```

## IP
```
bcastshow                   – Show broadcast routing
ifmodeshow                  – show interface mode (duplex)
ifshow                      – Like unix netstat -s
ipaddrshow                  – Like unix netstat -i
interfaceshow               – Like unix ndd
```

## Performance
```
ifshow                      – Like unix netstat -s
portperfshow                – Show interface mode (duplex)
portshow                    – Show stats on a port
portrouteshow               – Show routes on a port
portstatsshow               – Show stats (netstat -s) on a port
```

## Misc Show
```
diagshow                     – Show diagnostics – paged output
errdump                      – Show diagnostics – no paged output
fabricshow                   – Show fabric
fspfshow                     – Show FSPF protocol info
mqshow                       – Show queues
nbrstateshow                 – Show FSPF neighbor states
nsshow                       – Show name servers
nsallshow                    – Show all name servers
porterrshow                  – Like mpstat – shows port info
switchstatuspolicyshow       – Show config at when errors are flagged
```