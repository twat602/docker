FROM nginx:stable-alpine
# Vars d'env
ENV NGINXUSER=laravel
ENV NGINXGROUP=laravel

# Créer notre dossier de code pour le serveur
RUN mkdir -p /var/www/html/public
# Fichier de config pour NGINX
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# COPY source/index.html /var/www/html/public
# COPY source/js/app.js /var/www/html/public/js/app.js
COPY source/index.php /var/www/html/public/index.php
# Modifier le USER de NGINX
# sed (stream editor) est un outil de modification de texte
RUN sed -i "s/user  nginx/user  ${NGINXUSER}/g" /etc/nginx/nginx.conf

EXPOSE 80

RUN adduser -g ${NGINXGROUP} -s /bin/sh -D ${NGINXUSER}
