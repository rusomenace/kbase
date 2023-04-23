# Vaultwarden

Herranmienta para gestionar usuarios y claves del dominio entre otras funcionalidades

Ref:
- [Docker compose de ejemplo](https://shownotes.opensourceisawesome.com/vaultwarden/)
- [Video intro de youtube](https://www.youtube.com/watch?v=mq7n_0Xs1Kg)

# Ejemplo de instalacion con servidor de correo en GMail
para poder enviar correo via GMail es necesario tener habilitado IMAP y SMTP y crear una clave de aplicacion en la parte de segudida de la cuenta, ejemplo de compose:
# Docker Compose
```
version: '3'

services:
  vaultwarden:
    restart: always
    container_name: vaultwarden
    image: vaultwarden/server:latest
    volumes:
      - /var/vaultwarden/data:/data/
    ports:
      - 8883:80
    environment:
      - SMTP_HOST=smtp.gmail.com                    ################################
      - SMTP_FROM=hernan.maslowski@gmail.com        #
      - SMTP_FROM_NAME=VaultWarden                  # Todos estos datos corresponden
      - SMTP_SECURITY=starttls                      # a la autenticacion con GMail
      - SMTP_PORT=587                               #
      - SMTP_USERNAME=hernan.maslowski@gmail.com    #
      - SMTP_PASSWORD=cqsuyoqrexnusycr              ################################
      - SMTP_TIMEOUT=30
      - SMTP_AUTH_MECHANISM="Plain"
      - LOGIN_RATELIMIT_MAX_BURST=10
      - LOGIN_RATELIMIT_SECONDS=60
      - DOMAIN=https://vaultwarden.acme-coyote.com:8882
      - INVITATION_ORG_NAME=HomeVault
      - INVITATIONS_ALLOWED=true
      - ADMIN_TOKEN=j;lk897J89f7d3k.das3
      - SIGNUPS_ALLOWED=false
      - SIGNUPS_DOMAINS_WHITELIST=acme-coyote.com
      - SIGNUPS_VERIFY=true
      - SIGNUPS_VERIFY_RESEND_TIME=3600
      - SIGNUPS_VERIFY_RESEND_LIMIT=6
      - EMERGENCY_ACCESS_ALLOWED=true
      - SENDS_ALLOWED=true
      - WEB_VAULT_ENABLED=true
```