FROM ubuntu/apache2:latest

#
RUN mkdir -p /var/www/html/public

COPY conf/default.conf /etc/apache2/sites-available/000-symfony.conf
COPY src/index.php /var/www/html/public/index.php

# Apache enable ce virtual host
RUN a2ensite 000-symfony.conf

RUN a2enmod rewrite actions alias proxy_fcgi setenvif

RUN sed -i "s/www-data/teacher/g" /etc/apache2/envvars

RUN groupadd teacher

RUN useradd -g teacher teacher