FROM nginx:stable-alpine
# Vars d'env
ENV NGINXUSER=laurent
ENV NGINXGROUP=laurent


RUN adduser -g laurent -s /bin/sh -D laurent

# Créer notre dossier de code pour le serveur
RUN mkdir -p /var/www/html/public

# Fichier de config pour NGINX
COPY nginx/default.prod.conf /etc/nginx/conf.d/default.conf

COPY nginx/certificat.test.pem /etc/nginx/certs/certificat.test.pem
COPY nginx/certificat.test-key.pem /etc/nginx/certs/certificat-test-key.pem

# Modifier le USER de NGINX
# sed (stream editor) est un outil de modification de texte
# !! nginx attention aux deux espaces
RUN sed -i "s/user  nginx/user laurent/g" /etc/nginx/nginx.conf
