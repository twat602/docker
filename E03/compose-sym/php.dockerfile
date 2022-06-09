FROM php:8.1.6-fpm-alpine

# Variable d'environemment
ENV USER=teacher

RUN adduser -g ${USER} -s /bin/sh -D ${USER}

RUN sed -i "s/user = www-data/user = ${USER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${USER}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public

# Extensions qui ne font pas partie de l'image de base.
RUN docker-php-ext-install pdo pdo_mysql

CMD ["php-fpm"]
