FROM nginx:stable-alpine
# Vars d'env
ENV NGINXUSER=teacher
ENV NGINXGROUP=teacher

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN adduser -g ${NGINXGROUP} -s /bin/sh -D ${NGINXUSER}

# Créer notre dossier de code pour le serveur
RUN mkdir -p /var/www/html/public

# Fichier de config pour NGINX
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Modifier le USER de NGINX
# sed (stream editor) est un outil de modification de texte
# !! nginx attention aux deux espaces
RUN sed -i "s/user  nginx/user  ${NGINXUSER}/g" /etc/nginx/nginx.conf
