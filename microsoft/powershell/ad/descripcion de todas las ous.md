### Query
```
Get-ADOrganizationalUnit -Filter 'Name -like "*"' | FT Name, DistinguishedName -A
```
### Result
```
Name                               DistinguishedName
----                               -----------------
Microsoft Exchange Security Groups OU=Microsoft Exchange Security Groups,DC=tq,DC=com,DC=ar
Domain Controllers                 OU=Domain Controllers,DC=tq,DC=com,DC=ar
ARG                                OU=ARG,DC=tq,DC=com,DC=ar
Site0                              OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Users                              OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Domain Servers                     OU=Domain Servers,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Groups                             OU=Groups,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Desarrollo                         OU=Desarrollo,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
IT                                 OU=IT,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Network Services                   OU=Network Services,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Direccion                          OU=Direccion,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
2012                               OU=2012,OU=Domain Servers,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Support                            OU=Support,DC=tq,DC=com,DC=ar
Distribution List                  OU=Distribution List,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
2003                               OU=2003,OU=Domain Servers,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
2008                               OU=2008,OU=Domain Servers,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
QA                                 OU=QA,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Administration                     OU=Administration,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Workstations                       OU=Workstations,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Virtual                            OU=Virtual,OU=Workstations,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
7                                  OU=7,OU=Virtual,OU=Workstations,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Desktop                            OU=Desktop,OU=Workstations,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
HR                                 OU=HR,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Meaningless                        OU=Meaningless,OU=Groups,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Laptop                             OU=Laptop,OU=Workstations,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Standalone Servers                 OU=Standalone Servers,DC=tq,DC=com,DC=ar
Comercial                          OU=Comercial,OU=Users,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
2016                               OU=2016,OU=Domain Servers,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
2019                               OU=2019,OU=Domain Servers,OU=Site0,OU=ARG,DC=tq,DC=com,DC=ar
Delete                             OU=Delete,OU=ARG,DC=tq,DC=com,DC=ar
```