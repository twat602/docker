# Docker, Episode 2

---

Dans l'épisode précédent, on a vu qu'on avait pas mal de commande et que Docker était assez flexible, on va profiter de ça pour installer `nginx`

Notre but est de construire un container qui peut faire tourner un serveur web et d'exécuter les requêtes d'un container PHP qu'on fera dans un second temps.

Pour y parvenir, il faudra connecter les containers.

Anticipons un peu et collons déjà ces règles dans le terminal, elles permettront de faire communiquer nos conteneurs, les requêtes reçues seront transmises à docker, ces règles ne persistent pas, il faudrait donc créér un script qui les exécute automatiquement quand on démarre le serveur:

```bash
# Enable forwarding from Docker containers to the outside world
# By default, traffic from containers connected to the default bridge network is not forwarded to the outside world. To enable forwarding, you need to change two settings. These are not Docker commands and they affect the Docker host’s kernel.

# Configure the Linux kernel to allow IP forwarding.
sudo sysctl net.ipv4.conf.all.forwarding=1
# Change the policy for the iptables FORWARD policy from DROP to ACCEPT.

# cat /proc/sys/net/ipv4/ip_forward pour checker

sudo iptables -P FORWARD ACCEPT
# These settings do not persist across a reboot, so you may need to add them to a start-up script.
```

On installe ce logiciel pour persister ces infos :

`sudo apt-get install iptables-persistent`, on accpte les changements.

On choisi la distro `nginx:stable-alpine` car alpine linux est une distro réputée pour être légère, stable, et de bien s'accorder aux containers.

Il faut réfléchir et faire attention à choisir la bonne image pour démarrer avec une image custom.

On peut au choix désactiver apache24 et nginx, ainsi que mysql et tout ce qui pourrait tourner sur des ports dont on va se servir, ou, binder les ports 8080, 8000 etc etc quand on exécutera les commandes, je vais désactiver mes serveurs, vous ne devriez pas avoir à faire ça.

Définissons nos besoin :

-   `PHP81`
-   `Nginx` que l'on doit configurer un minimum
-   Un utilisateur autre que root
-   MySQL
-   Du code PHP :/ (donc surement composer)

Le plan, on doit installer :

-   [x] Nginx
-   [x] PHP
-   [x] MySQL
-   [x] Composer
    -   [x] Installer une app laravel
-   [x] Nodejs / npm
    -   [x] `npm run watch`
    -   [ ] `npm run dev`
    -   [x] `npm run development`
    -   [ ] `npm run prod`
    -   [x] `npm run production`
-   [x] `php artisan`

On commence par Nginx, on créé un ficheir `nginx.dockerfile` :

```docker
FROM nginx:stable-alpine
# Vars d'env, on va répliquer les users de notre OS
ENV NGINXUSER=laravel
ENV NGINXGROUP=laravel

# Créer notre dossier de code pour le serveur
RUN mkdir -p /var/www/html/public
# Fichier de config pour NGINX
ADD nginx/default.conf /etc/nginx/conf.d/default.conf
# Modifier le USER de NGINX
# sed est un outil de modification de texte
RUN sed -i "s/user www-data/user ${NGINXUSER}/g" /etc/nginx/nginx.conf

RUN adduser -g ${NGINXGROUP} -s /bin/sh -D ${NGINXUSER}
```

On utilise Alpine car c'est une distro légère et stable.

On peut taper la commande `docker build -f nginx.dockerfile --no-cache -t firstnginx .`

suivi par

`docker run --rm -p 80:80 firstnginx`

On se mange une erreur car on a pas de code source, on va se servir des volumes pour arranger ça.

On créer un dossier `source` et un fichier `index.html`.

> **Attention à donner le chemin complet du dossier de code source à docker**

Et la commande `docker run --rm -p 80:80 -v /var/www/html/docker/E02/image/source:/var/www/html/public firstnginx`

On s'est servi d'un volume pour notre fichier HTML, mais c'est pas très pratique, on modifie notre Dockerfile pour y copier nos fichiers.

## Le container PHP

Faire un conteneur PHP et le faire communiquer avec nginx, puis face à la galère qui s'annonce si on doit ajouter SQL, nodejs etc etc, on passe a docker compose.

On crée un fichier php.dockerfile, on choisit alpine aussi pour se faciliter la tâche et on fait notre image.

```docker
FROM php:8.1.6-fpm-alpine

ENV PHPUSER=laravel
ENV PHPGROUP=laravel

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public

# Add packages for laravel ou autre
RUN docker-php-ext-install pdo pdo_mysql

EXPOSE 9000

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
```

On build: `docker build . -f php.dockerfile -t customphpfpm`

On fait tourner nginx et on le lie a phpfpm. Attention à l'option `--link`, elle est dépréciée.

Il faut commencer par créer un réseau avec docker.

`docker network create nginx`, pour créer un network.

`docker network rm nginx` pour l'effacer.

On peut connecter deux containers à notre network, il y a quelques étapes à respecter scrupuleusement. On doit modifier nos fichiers `nginx/default.conf` et `php.dockerfile`

On ajoute un bloc dans le fichier de conf de `nginx`:

```nginx
location ~ \.php$ {
    try_files $uri =404;
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass localhost:9000; # C'est temporaire
    fastcgi_index index.php;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param PATH_INFO $fastcgi_path_info;
}
```

Ensuite, `php.dockerfile`, on ajoute une ligne :

```docker
COPY source/index.php /var/www/html/public/index.php
```

On rebuild nos images, on les exécute et on les reconnecte à notre network.

`docker run --rm --network=nginx customphpfpm`

`docker run --rm -p 80:80 --network=nginx --network-alias test firstnginx`

C'est bien ça marche mais on code des trucs en dur, et on doit ajouter MySQL, donc mais on va pas faire comme ça, car à chaque fois recompiler notre image, c'est débile.

On va créer un autre réseau avec un`subnet` :  system of interconnections within a communications system that allows the components to communicate directly with each other.

On efface d'abord notre réseau basique `docker network rm nginx`

`docker network create --driver bridge --subnet 172.22.1.0/24 --gateway 172.22.1.1 nginx`

A partir de la on modifie une dernière fois notre fichier de conf nginx, pour spécifier un ip, celui-ci sera fixe, on rebuild notre image `nginx`

On lance les conteneurs et on les connecte avec ces commandes:

`docker ps` pour voir les conteneurs en fonctionnement

`docker network connect --ip 172.22.1.2 NOMRESEAU NOMCONTENEUR`

On est satisfait de notre image `nginx`, on va l'envoyer sur dockerhub pour pouvoir nous en resservir facilement.

On va sur dockerhub créer un token, Read, Write Delete

On copie ce token qqpart safe et on fait un login dans le terminal:

`docker login -u laurentoclock`

`7d9c5025-2045-43c3-958d-c8a7b3b74452`

On cré un repo sur dockerhub et on suit les instructions. On se rappelle les commandes :

`docker tag local-image:tagname new-repo:tagname`

Pour moi : `docker tag firstnginx:latest laurentoclock/nginx:latest`

`docker push new-repo:tagname`

Pour moi : `docker push laurentoclock/nginx:latest`

Et on est bon. On pourra se resservir de ce fichier à l'étape suivante.

## Exo : La même chose avec apache24

C'est mieux mais, il a maintenant le problème de `MySQL`, on doit l'ajouter aussi, avec toutes ces commandes dans le terminal on s'en sort plus, en attendant de voir un nouvel outil, on va faire la même chose ave apache24


# et après on passe à docker compose
On va plutôt utiliser un outil qui va gérer ça pour nous et qui s'appelle `docker compose`.


## Docker compose avec MySQL ou postgres (les deux ? oui mais pas le même jour)

## Ensuite, faire la même chose avec nginx + laravel + composer + npm + docker compose

## Penser aux permissions pour laravel, sauf sur macos :/

TODO: Régler le problème des permissions, mais sur macos ça passe :/

`sudo chown -R user:group ./src`
`sudo chmod -R ugo+w src/storage`
`sudo chmod -R ugo+w src/public`

## Exo, faire la même chose avec apache24 + symfony
