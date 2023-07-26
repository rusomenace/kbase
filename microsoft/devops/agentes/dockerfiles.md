## Ubuntu 23.04, DotNet 6-7

```
FROM ubuntu:23.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    wget \
    git \
    iputils-ping \
    jq \
    lsb-release \
    zip \
    apt-utils \
    software-properties-common
RUN wget -q -O /tmp/packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/23.04/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb \
    && rm /tmp/packages-microsoft-prod.deb

RUN DEBIAN_FRONTEND=noninteractive apt-get update
# Ref: https://gist.github.com/prsanjay/f994e313df665bebcffbd0465b4ff653
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    dotnet-sdk-6.0 \
    dotnet-sdk-7.0 \
    aspnetcore-runtime-6.0 \
    aspnetcore-runtime-7.0 \
    dotnet-runtime-6.0 \
    dotnet-runtime-7.0
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ENV DOCKER_VERSION=20.10.9
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
rm docker-${DOCKER_VERSION}.tgz

# Instalacion de docker server
# RUN curl -fsSL https://get.docker.com | sh

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]
```