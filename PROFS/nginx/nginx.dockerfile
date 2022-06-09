FROM nginx:stable-alpine

# Créé notre dossier de code
RUN mkdir -p /var/www/html/public

# On envoie notre configuration pour le site par défaut
COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY src/index.html /var/www/html/public/index.html
COPY src/js/app.js /var/www/html/public/js/app.js
COPY src/index.php /var/www/html/public/index.php
# sed (stream editor) est outil de modification de texte
#
RUN sed -i "s/user  nginx/user  teacher/g" /etc/nginx/nginx.conf

EXPOSE 80

RUN adduser -g teacher -s /bin/sh -D teacher
