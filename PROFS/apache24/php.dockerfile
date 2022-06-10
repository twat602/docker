FROM php:8.1.6-fpm-alpine

# Variable d'environemment
ENV USER=teacher

RUN adduser -g teacher -s /bin/sh -D teacher

RUN sed -i "s/user = www-data/user = ${USER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = teacher/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public

COPY  src/index.php /var/www/html/public/index.php
# Extensions qui ne font pas partie de l'image de base.
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 9000

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
