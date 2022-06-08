FROM node:latest

# On crée un repértoire /home/server, et c'est aussi notre répertoire de travail par défaut
WORKDIR /home/server

# Ajoute le fichier db.json
COPY index.js /home/server/index.js
COPY package.json /home/server/package.json

# Exécuter une commande du système de l'image
RUN npm install -g nodemon

#ENTRYPOINT json-server db.json
#/bin/sh -c json-server db.json

# Ouvre le port 3000 du conteneur vers l'extérieur
EXPOSE 3000

ENTRYPOINT [ "nodemon"]

CMD [ "index.js" ]

