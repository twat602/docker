# Docker jour 2

-   Voir le README pour les détails.

Pour anticiper, on doit faire communiquer des conteneurs, les règles suivantes sont nécessaires :

```bash
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT
```

On installe ce logiciel pour persister les infos de la deuxième commande :

`sudo apt-get install iptables-persistent`, on accepte les changements.

On va faire un conteneur Ningx et un conteneur PHP-fpm, les requêtes reçues par Nginx doivent être transimise au conteneur php-fpm, si nécessaire.

> On choisit avec attention l'image de base.

Attention pour se connecter sur un conteneur `alpine` bash n'est pas installé, on exécute don c `/bin/sh` pour s'y connecter :

`docker exec -it NOMCONTENEUR /bin/sh`

Installation de nano sur `alpine`: `apk add nano`

Attention aux fichiers de configuration, il faut vérifier que les modifications sont effectués, c'est valable pour toutes les images que vous ferez.

## Docker network

Création d'un réseau docker:

`docker network create NOMRESEAU`

Pour observer notre réseau:

`docker network inspect NOMRESEAU`

Pou effacer un réseau:

`docker network rm NOMRESEAU`

---

Pour connecter un conteneur sur un réseau docker

`docker run --rm -p 80:80 --network=NOMRESEAU NOMCONTENEUR`

Pour créer un réseau customisé:

`docker network create --driver bridge --subnet 172.22.1.0/24 --gateway 172.22.1.1 nginx`

Pour connecter un conteneur sur notre réseau custom et choisir son ip :

`docker network connect --ip 172.22.1.3 NOMRESEAU NOMCONTENEUR`

> Le `/number` dans l'url représente les nombre d'ip qu'il nous restera à assigner:

> `172.22.1.0/24` Je pourrai assigner de 0 a 255, à la place du 0

> `172.22.1.0/16` Je pourrai assigner de 0 a 255, à la place du 0 et du 1

> `172.22.1.0/8` Je pourrai assigner de 0 a 255, à la place du 0 du 1 et du 22
