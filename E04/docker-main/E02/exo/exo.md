# Docker compose

# Exo, faire un serveur apache24 + symfony (+ nodejs ?)

`docker build --no-cache -t sym-apache .`

`docker run --rm -p 80:80 -v /var/www/html/docker/E02/exo/source:/var/www/html/public sym-apache`
