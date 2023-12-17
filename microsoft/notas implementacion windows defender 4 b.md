## Company portal intune onboiard devices
https://www.youtube.com/watch?v=TKQxEckBHiE

## Onboarding
https://www.youtube.com/watch?v=z3R_aq0pu0Y

## Onboarding servers 2019
https://www.youtube.com/watch?v=41znEhWlK-w

## Onboarding servers 2016
https://www.youtube.com/watch?v=8eJ0ATUY9-U

3cLbJJB2YgEbv9Yk

## Offboarding

## Obtener el ID de la maquina
Ejemplo de windows 11
```
31126ca51b1d0988528263dfec036fd7ce801eca
```
Copy the machine you want to offboard in the machine list and obtain the machine ID from the URL (…/machines/<machine ID>)
Navigate to API explorer (Left pane in ATP > Partners & APIs > API explorer)
Change first drop-down to "POST"
Paste this URL (https://api.securitycenter.windows.com/api/machines/{machine-id}/offboard)
Enter machine ID in the URL (keep the entire URL, just replace <MachineID>)
Run query (This will force machine to run the offboarding script next time the machine checks in.)
Include this comment (remove the first and last quotations):
               "{

               "Comment": "Offboard machine by automation"

               }"

     8. Repeat 1-6 for each machine you'd like to remove


## Application creation:
Application (client) ID: 9ec92d60-187f-49f9-9f0f-b03b2ef87590

## Secrets
value: SwM8Q~sGvTb-_C88AZP90mwITfGf4.wAi6f10bCw
secret id: c64cfd7f-c392-4a64-b5d3-2f8221d6f84c

## Servicios indispensables en funcionamiento
Connected User Experiences and Telemetry: AUTO

# Importantisimo
https://ulyssesneves.com/2021/09/07/hybrid-azure-ad-join-fixing-error-message-server-error-the-user-certificate-is-not-found-on-the-device-with-id/

Se habla de como purgar los certificados y realizar una sincronizacion para que el equipo quede activo en azure ad

# Target deployment
https://learn.microsoft.com/en-us/azure/active-directory/devices/hybrid-join-control

Variables de registro para apuntar a SCP

# GPO Autoenrollment
https://learn.microsoft.com/en-us/windows/client-management/enroll-a-windows-10-device-automatically-using-group-policy

