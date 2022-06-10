# Docker

Qu'est-ce que Docker ?

C'est un truc en plus à apprendre :)

Un outil qui sert à harmoniser les machines de dev, de staging et de prod, avec Docker on évite le fameux :

- ça ne marche pas ton truc !
- mais ça marche sur ma machine !

Plus sérieusement, avec Docker on peut configurer des environnements de dev très rapidement, les répliquer exactement pour tout le monde, tout le monde aura donc le même environnement de travail, la prod y compris. Sans avoir besoin d'avoir des machines virtuelles super lourdes, on aura juste besoin d'installer Docker.

Docker se sert de conteneur pour construire, partager et faire tourner des apps, un container est une machine virtuelle légère, qui contient les logiciels nécessaires à faire tourner nos applications : <http://docker.com/ressources/what-container>

Chaque conteneur contient un OS, les logiciels nécessaires et notre code source.

- Pourquoi c'est utile ? :

  - C'est utile, car docker permet de faire tourner notre app sans avoir à configurer une machine pour une application. On peut ainsi sur la même machine faire tourner plusieurs applications, sans avoir besoin de lourdes machines virtuelles. Les conteneurs ne contiennent que ce qui est nécessaire pour faire tourner notre app, on utilise donc moins de ressources.

  - Les conteneurs sont portables et peuvent être déployés n'importe ou très rapidement

  - L'environnement de travail peut être partagé très facilement et très rapidement.

  - C'est la première étape pour déployer une app disponible à grande échelle.

## Installation de Docker

<http://docs.docker.com/engine/install/ubuntu> Faire attention à la version d'ubuntu, sinon installer WSL2 et docker.exe.

## Utilisation basique : Commandes de base

- `docker run hello-world` <https://hub.docker.com/_/hello-world>
- `docker ps` pour visualiser les conteneurs actifs sur notre système, si on exécute un conteneur, après que docker exécute un conteneur, il est éteint automatiquement, mais pas supprimé.
- Pour visualiser tous les conteneurs, actifs comme inactifs, on fait `docker ps -a`


Il y a au moins 30 tonnes de conteneur disponible sur docker hub <https://hub.docker.com/search?q=ubuntu>

Chaque conteneur a un nom et des tags qui y sont associés, les tags servent au versioning des conteneurs et pour déterminer ce qu'on veut comme build pour le conteneur qu'on souhaite utiliser.

Faire plusieurs fois la commande précédente pour montrer que les conteneurs s'accumulent.


On retourne dans le terminal et on fait :

- `docker run --rm hello-world`

Pourquoi on fait `--rm` ? Pour effacer nos conteneurs au fur et à mesure, il faut faire attention, on se retrouve vite pollué par le nombre de conteneurs et d'images si on n'est pas vigilant. On fait `docker ps -a` pour avoir la preuve.

Amusons-nous avec une distro linux :

- `docker run --rm ubuntu:latest`

Faire tourner ça ne nous dis rien de plus, car le conteneur n'exécute aucune commande.

On recommence en exécutant une commande :

- `docker run --rm ubuntu:latest cat /etc/os-release`

On essaye avec une version ancienne d'ubuntu :

- `docker run --rm ubuntu:18.04 cat /etc/os-release`

On essaye de run en background :

- `docker run --rm -d ubuntu:latest cat /etc-os-release`, Le flag `-d` pour exécuter le conteneur en arrière-plan.

On essaye avec un autre flag :

- `docker run --rm -di  ubuntu:latest /bin/bash`, le flag `-i` veut dire interactif, c'est toujours dans le background mais le conteneur tourne, la preuve avec `docker ps`

On se log à la machine :

- `docker ps` pour trouver le nom de la machine et :

- `docker exec -it NOMDELAMACHINE bash`, Si on ne met pas le flag `-t`, on pourra se logguer, mais pas faire de commandes.

On peut aussi faire toutes les commandes d'un coup :

- `docker run --rm -dti ubuntu:latest /bin/bash`, il suffit d'enlever le flag `-d`, mais le conteneur s'éteindra quand on tapera `exit`.

Le conteneur tourne toujours, il faut le stopper.

- `docker ps` pour obtenir la liste des conteneurs actifs.

Et on stoppe le conteneur soit par son nom, soit par son ID :

- `docker stop ID` ou `docker stop name`

On efface tous les conteneurs (actifs et inactifs) avec cette commande :

- `docker rm -f $(docker ps -aq)`

## Notre Premier Container

- On créé un fichier nommé Dockerfile, le but de ce fichier est de fournir à docker des instructions pour construire un container custom.

Le but est de faire un container, qui fera tourner `json-server` qui mettra à notre disposition une API REST à parti d'un fichier JSON, et qui est très pratique pour développer un front quand on n'a pas encore la BDD disponible. <https://www.npmjs.com/package/json-server>

La première instruction qui doit obligatoirement partir dans ce fichier Dockerfile est le `FROM`, c'est à partir de cette image de base que l'on fabrique notre image.

C'est la ou il ne faut pas se tromper, on n'installe pas un OS, car celui-ci est fourni par docker.

```docker
# Avec cette commande, on a un container avec nodejs et npm installés :)
FROM node:latest
```

On doit maintenant installé `json-server`:
mais avant on doit :

- Dire à docker dans quel répertoire on va travailler (à l'intérieur du conteneur) avec `WORKDIR`
- Exécuter une commande npm avec `RUN`
- Fournir un fichier `db.json` à `json-server`
  - On crée ce fichier `db.json`
  - On copie le fichier dans le conteneur avec l'instruction `COPY`
- Ensuite on fait tourner `json-server`

En profiter pour voir `COPY` vs `ADD`.

```docker
FROM node:latest

WORKDIR /home/server

RUN npm install -g json-server

COPY db.json /home/server/db.json
# Shell form, la commande sera
# ENTRYPOINT /bin/sh -c json-server db.json

ENTRYPOINT ["json-server", "db.json"]
```

Enfin on peut taper `docker build .` Docker recherche la Dockerfile et exécute les commandes pour fabriquer une image.

On vérifie avec `docker image list`

Notre image n'a pas de nom, mais on a une ID, on peut faire tourner notre container à partir de cette image gràce à l'ID:

`docker run --rm 31905ec6a32e`

On essaye d'aller sur `http://localhost:3000/articles` et ooopppss :-0, ça marche pas

Il faut exposer les ports du container au système d'exploitation

Par défaut `json-server` tourne sur localhost, Il faut aussi modifier le `host` pour spécifier l'adresse `0.0.0.0` qui est le bridge de docker, cela connectera notre machine avec docker.

Dans un nouveau terminal, on fait `docker ps`, on copie l'ID et on fait docker `docker stop ID`

On modifie notre Dockerfile

```docker
FROM node:latest

WORKDIR /home/server

RUN npm install -g json-server

COPY db.json /home/server/db.json
# Shell form, la commande sera
# ENTRYPOINT /bin/sh -c json-server db.json

EXPOSE 3000

ENTRYPOINT ["json-server", "db.json", "--host", "0.0.0.0"]
```

Et on tape `docker build . --no-cache -t testing-docker`, pour nommer l'image en même temps et ne pas être embêter par du cache éventuel. Ce sera plus facile de l'effacer ensuite.

Et on tape cette commande `docker run --rm -p 3000:3000 testing-docker`, le premier 3000 est le port de notre système, le second est celui de docker.

Cool, maintenant on modifie encore notre truc, pour overrider notre fichier `db.json` si besoin, on aura pas besoin d'un autre container pour tester une autre API. On se sert de la commande `CMD`.

On copie le fichier `db.json` et on le renomme `alt.json` par exemple, et on modifie les données pour que l'on puisse voir les différences, au passage on va aussi modifier le port sur lequel `json-server` tourne :

```docker
FROM node:latest

WORKDIR /home/server

RUN npm install -g json-server

COPY db.json /home/server/db.json
COPY alt.json /home/server/alt.json
# Shell form, la commande sera
# ENTRYPOINT /bin/sh -c json-server db.json

EXPOSE 3000

ENTRYPOINT ["json-server", "--port", "3004", "--host", "0.0.0.0"]

# Cette commande permet de donner des arguments optionnels en ligne de commande
CMD ["db.json"]
```

Et on tape cette commande `docker run --rm -p 3000:3004 testing-docker`, ça ne change rien.

Et on tape cette commande `docker run --rm -p 3000:3004 testing-docker alt.json` et ça change notre API.

> Attention, il faudra toujours aller sur le `http://localhost:3000`, c'est le port de `json-server` qu'on a changé, pas celui de notre machine.


## Trouver un exo

Faire un serveur express avec `nodemon` et `ejs`.