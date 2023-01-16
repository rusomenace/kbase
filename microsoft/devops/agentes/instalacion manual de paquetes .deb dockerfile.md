###Este es un ejemplo de descarga de paquete debian e instalacion
```
# Packages for wkhtmltopdf. These are available in ubuntu but not in debian 9. Base image uses debian 9.
RUN wget -q -O /tmp/libjpeg-turbo8.deb http://archive.ubuntu.com/ubuntu/pool/main/libj/libjpeg-turbo/libjpeg-turbo8_2.0.1-0ubuntu2_amd64.deb \
  && dpkg -i /tmp/libjpeg-turbo8.deb \
  && rm /tmp/libjpeg-turbo8.deb
```
```
RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i /tmp/libpng12.deb \
  && rm /tmp/libpng12.deb
```