FROM php:8.1.6-fpm-alpine

RUN adduser -g student -s /bin/sh -D student

RUN sed -i "s/user = www-data/user = student/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = student/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public

COPY src/index.php /var/www/html/public/index.php

RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 9000

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
