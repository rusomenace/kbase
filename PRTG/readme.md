# PRTG Readme

2022-12-29  -  9:10 

API Reference: https://www.paessler.com/manuals/prtg/application_programming_interface_api_definition?_ga=2.128552524.1585628758.1672315627-391411715.1672315627&_gl=1*1hp7apk*_ga*MzkxNDExNzE1LjE2NzIzMTU2Mjc.*_ga_JG3ST477CK*MTY3MjMxNTYyNi4xLjEuMTY3MjMxNTY0Ni4wLjAuMA..

HTTP API: https://www.paessler.com/manuals/prtg/http_api

**Ejemplos:**  
Para exportar la lista de **devices** como CSV:
https://prtg.tqcorp.com/api/table.xml?content=devices&output=csvtable&columns=device,host&count=1000
(Default son 500, por eso el count de 1000 para superar el default)


Para exportar la lista de **sensors** como CSV:
https://prtg.tqcorp.com/api/table.xml?content=sensors&output=csvtable&columns=device,sensor&count=1000
