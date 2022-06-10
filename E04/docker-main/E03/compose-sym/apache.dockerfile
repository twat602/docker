FROM ubuntu/apache2:latest
# Vars d'env
ENV APACHE_RUN_USER=symfony
ENV APACHE_RUN_GROUP=symfony

# Créer notre dossier de code pour le serveur
RUN mkdir -p /var/www/html/public
# Fichier de config pour NGINX

COPY apache/default.conf /etc/apache2/sites-available/000-symfony.conf

RUN a2ensite 000-symfony.conf

RUN a2enmod rewrite actions alias proxy_fcgi setenvif
# Modifier le USER de APACHE; sur ubuntu c'est dans le ficher envvars
# sed (stream editor) est un outil de modificatin de texte

RUN sed -i "s/www-data/${APACHE_RUN_USER}/g" /etc/apache2/envvars

RUN cat /etc/apache2/envvars

RUN groupadd ${APACHE_RUN_GROUP}

RUN useradd -g ${APACHE_RUN_GROUP} ${APACHE_RUN_USER}
