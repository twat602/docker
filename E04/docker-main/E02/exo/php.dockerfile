FROM php:8.1.6-fpm-alpine

ENV PHPUSER=teacher
ENV PHPGROUP=teacher

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN addgroup -g 1006 --system teacher
RUN adduser -G www-data --system -D -s /bin/sh -u 1006 teacher

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public


# Add packages for laravels
RUN docker-php-ext-install pdo pdo_mysql

CMD ["php-fpm"]
