# Docker : Commandes de base

`docker images` pour obtenir la liste des images disponibles sur localement (notre ordi)

`docker run nomImage` pour créér un container et l'exécuter

`docker run --rm nomImage` pour créér un container, et l'exécuter et l'effacer quand on a terminé.

`docker run --name hello-docker NOMIMAGE` le flag `name` pour donner un nom à notre conteneur.

`docker ps` pour obtenir les containers en fonctionnement

`docker ps -a` pour obtenir tous les containers créés

`docker rmi <IMAGEID>` pour effacer une image

`docker run --rm ubuntu:latest` qui ne nous dit rien de plus :/

`docker run --rm ubuntu:latest cat /etc/-os-release` pour exécuter une commande

`docker run -d --rm ubuntu:latest cat /etc/-os-release` le flag `-d` pour exécuter les conteneur dans le background

`docker run --rm -di ubuntu:latest /bin/bash` : on exécute un conteneur dasn le background, avec le flag `-i`, il est toujours allumé.

`docker exec -it NOMDEVOTRECONTENUR bash`, le flag `i` nous connecte à la machine, le flag `t` va permettre d'exécuter des commandes `bash`

`docker stop NOMCONTAINER` pour stopper un conteneur.

`docker start CONTAINERNAME` pour redémarrer un conteneur.

`docker rm CONTAINERID` pour effacer un conteneur

`docker ps -aq` pour récupérer les ids des conteneurs existant (actifs ou non)

`docker rm $(docker ps -aq)` pour effacer tous le conteneurs non actifs

`docker rm -f $(docker ps -aq)` obliterate :) (effacer tous les containers, actifs ou non), le flag `-f` pour force

`docker system prune` pour effacer tout ce qui sert à rien (ça fait un reset)

`docker system prune -a` Explosion général

### Un image avec json-server

Voir le Dockerfile

`docker build . --no-cache -t jsonserver` Contruire une image avec un tagname jsonserver et sans le cache, pour avoir une image fraiche

`docker build . --no-cache -f file.dockerfile -t jsonserver`

`docker run --rm -p 3000:3000 jsonserver` Pour exécuter notre image, en exposant le port 3000 du conteneur au port 3000 de la machine hote. Le premier 3000 est le port de l'hote. Essayez de changer le port pour vous souvenir que le premier port est celui de notre machine hôte et le second celui du conteneur.

Un lien intérésant vers digital ocean <https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes>

Slides :
<https://docs.google.com/presentation/d/15SOfOF77NG-ryXcf2e9gsgcc0qoImb0bl2tJewnhHlg/edit#slide=id.g5d5f55ffe4_1_0>
