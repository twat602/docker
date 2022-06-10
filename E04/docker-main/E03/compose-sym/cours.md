# Docker Compose

Construire un fichier yml en respectant les bonnes pratiques de la doc officielle.

Le but du jeu mainteant est d'installer une app avec un framework, on choisit laravel.

Les besoins:

- PHP81
- composer
- nginx
- MySQL
- node / npm

Créons un fichier `docker-compose.yml`, c'est dans ce fichier qu'on va définir tous nos service en respectant la règle un service par conteneur.

Ca fait pas mal de conteneurs à gérer et c'est compliqué, mais `docker compose` est là pour nous aider :)

Attention, il faut modifier le fichier `default.conf` et remplacer l'IP par `php:9000`

On commence par mettre en place nginx :

C'est facile, on a déjà fait cette image, on va s'en servir :

```yaml
services:
    nginx:
        build:
            context: .
            dockerfile: nginx.dockerfile
        ports:
            - 80:80
        volumes:
            - ./src:/var/www/html
```

## MySQL

```yaml

    mysql:
        image: mariadb:10.5
        ports:
            - 3306:3306
        environnement:
            MYSQL_USER: laravel
            MYSQL_PASSWORD: secret
            MARIADB_DATABASE: laravel
            MARIADB_ROOT_PASSWORD: secret
            MARIADB_ALLOW_EMPTY_ROOT_PASSWORD: true
            MARIADB_RANDOM_ROOT_PASSWORD: secret
        volumes:
            - ./mysql:/var/lib/mysql
```

Si on a besoin de se connecter à `mysql` : `docker run -it --network compose_default --rm mariadb mysql -hcompose-mysql-1 -ularavel -p`. Le flag `-h` pour spécifier le host, il faudra inspecter le network pour être sûr d'avoir le bon.
On utilise un volume pour assurer la persistance des données.

## PHP

```yaml
    php:
        build:
            context: .
            dockerfile: php.dockerfile
            volumes:
                - ./src:/var/www/html
```

On peut faire notre fichier `php.dockerfile`

```docker
FROM php:8.1.6-fpm-alpine

ENV PHPUSER=teacher
ENV PHPGROUP=teacher

RUN addgroup -g 1006 --system teacher
RUN adduser -G www-data --system -D -s /bin/sh -u 1006 teacher

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html/public


# Add packages for laravels
RUN docker-php-ext-install pdo pdo_mysql

CMD ["php-fpm"]
```

## Composer

```docker
    composer:
        build:
            context: .
            dockerfile: composer.dockerfile
        volumes:
            - ./src:/var/www/html
        working_dir: /var/www/html
```

## npm

```docker
    npm:
        image: node:current-alpine
        volumes:
            - ./src:/var/www/html
        entrypoint: ['npm']
        working_dir: /var/www/html
```

## Artisan, la commande de laravel

```docker
    artisan:
        build:
            context: .
            dockerfile: php.dockerfile
        volumes:
            - ./src:/var/www/html
        depends_on:
            - mysql
        entrypoint: ['php', '/var/www/html/artisan']
```

## Enfin, adminer

```docker
    adminer:
        image: adminer
        restart: always
        ports:
            - 8080:8080
        depends_on:
            - mysql
            - php
```