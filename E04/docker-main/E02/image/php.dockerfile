FROM php:8.1.6-fpm-alpine

ENV PHPUSER=laravel
ENV PHPGROUP=laravel

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public

COPY source/index.php /var/www/html/public/index.php

# Add packages for laravels
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 9000

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
