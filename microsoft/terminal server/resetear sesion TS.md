# Como resetear sesion remota de Terminal Server

Pasos a seguir para averiguar el session id de forma remota sin necesidad de ingresar al servidor de Terminal Server

```batch
query user /server:TQARSVW16TS01
```

Otra opcion es:

```batch
query user /server:TQARSVW16TS01
```

Para proceder a resetear la sesión ejecutamos:

```batch
reset session /V /SERVER:TQARSVW16TS01 <session_id> 
```

> Donde "session_id" colocar el id que obtuvimos anteriormente
 
---

## Guia de Microsoft con parametros adicionales

```batch
reset session {<sessionname> | <sessionID>} [/server:<servername>] [/v]
```


## Parameters
| Parameter            | Description                                                                                                                                                                                                                      |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| \<sessionname>        | Specifies the name of the session that you want to reset. To determine the name of the session, use the query session command.                                                                                                   |
| \<sessionID>          | Specifies the ID of the session to reset.                                                                                                                                                                                        |
| /server:<servername> | Specifies the terminal server containing the session that you want  to reset. Otherwise, it uses the current Remote Desktop Session Host  server. This parameter is required only if you use this command from a  remote server. |
| /v                   | Displays information about the actions being performed.                                                                                                                                                                          |
| /?                   | Displays help at the command prompt.                                                                                                                                                                                             |

## Examples

To reset the session designated rdp-tcp#6, type:
```batch
reset session rdp-tcp#6
```

To reset the session that uses session ID 3, type:

```batch
reset session 3
```


REF: [Reset session in Terminal Server](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reset-session)  
REF: [Remote Desktop Services (Terminal Services) command-line tools reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/remote-desktop-services-terminal-services-command-reference)  
REF: [TQIT-98831 - SC no abre en mi VPN](https://gemini.tqcorp.com/gemini/issue/ViewIssue.aspx?id=98831&PROJID=19)