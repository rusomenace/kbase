# Introduction 
Evaluar la solicion de sonarqube

## Getting Started
Se opta por montar la demo en container:
1.	Caracteristicas
2.	Instalacion
3.	Pre-produccion

## 1
SQ tiene 2 tipos de soluciones, pago y community.
La diferencia sustancial radica en que el licenciamiamiento permite acalisis de branch o main, ==la version community solamente analiza main==

## Detalle de licenciamiento

### Developer $150
- SonarLint IDE integration
- SonarQube
- Branch analysis
- Pull Request decoration
- Taint analysis
- 24 languages

### Enterprise $20.000
- SonarLint IDE integration
- SonarQube
- Branch analysis
- Pull Request decoration
- Taint analysis
- 29 languages
- Parallel processing of analysis reports
- Multiple DevOps platform instances
- Monorepo support for PR Decoration
- Security engine customization 
- Security reports
- Portfolio Management & PDF Executive Reports
- Project PDF reports
- Audit trailing
- Project transfer
- 2 additional test/stage licenses

## 2
Se opta por la instalacion en container para demo, la instancia que esta corriendo esta en modo de prueba y utiliza una base de datos integration

```
version: '3.3'
services:
    sonarqube:
        container_name: sonarqube
        environment:
            - SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true
        ports:
            - '9000:9000'
        image: 'sonarqube:community'
```

## 3
Para un ambiente de produccion se recomienda el siguiente aprovisionamiento de virtualizacion:

- 3 VCPUs
- 16 GB ram 
- HDD minimamente NVMe | SSD y 40GB para arriba sin estimar el codigo o el volumen a analizar (thin prov.)
- Hay que sarrollar un archivo de docker-compose que integren un container de mysql y sonarqube para que elasticsearch utilize un motor de datos exclusivo