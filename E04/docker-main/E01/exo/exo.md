# Création d'un server express avec Docker

---

```docker
FROM node:latest

WORKDIR /home/server

RUN npm install -g json-server

# COPY vs ADD

COPY db.json /home/server/db.json
COPY alt.json /home/server/alt.json
# Shell form, la commande sera
#ENTRYPOINT json-server db.json
#ENTRYPOINT /bin/sh -c json-server db.json

# EXPOSE 3000

ENTRYPOINT ["json-server", "--host", "0.0.0.0"]

CMD ["db.json"]
```