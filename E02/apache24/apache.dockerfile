FROM ubuntu/apache2:latest

# Créé notre dossier de code
RUN mkdir -p /var/www/html/public

COPY conf/default.conf /etc/apache2/sites-available/000-symfony.conf
COPY src/index.php /var/www/html/public/index.php


RUN a2ensite 000-symfony.conf

RUN a2enmod rewrite actions alias proxy_fcgi setenvif

RUN sed -i "s/APACHE_RUN_USER=www-data/APACHE_RUN_USER=student/g" /etc/apache2/envvars
RUN sed -i "s/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=student/g" /etc/apache2/envvars

RUN groupadd student
RUN useradd -g student student

EXPOSE 80

