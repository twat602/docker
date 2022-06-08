FROM node:latest

# On crée un repértoire /home/server, et c'est aussi notre répertoire de travail par défaut
WORKDIR /home/server

# Exécuter une commande du système de l'image
RUN npm install -g json-server
# Ajoute le fichier db.json
COPY db.json /home/server/db.json
COPY db2.json /home/server/db2.json

#ENTRYPOINT json-server db.json
#/bin/sh -c json-server db.json

# Ouvre le port 3000 du conteneur vers l'extérieur
#EXPOSE 3000

ENTRYPOINT [ "json-server", "--port", "3000", "--host", "0.0.0.0"]

CMD [ "db.json" ]
