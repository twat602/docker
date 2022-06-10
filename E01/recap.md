# Recap

`docker images` pour obtenir la liste des images disponibles localement

`docker run NOMIMAGE` Créer un conteneur et l'exécuter

`docker run --rm NOMIMAGE` Créer un conteneur et l'exécuter et de l'effacer quand on a terminé.

`docker run --name nomCustom NOMIMAGE` Créer un conteneur dont on choisit le nom.

`docker rm IDCONTENEUR` Efface un conteneur.

`docker rmi NOMIMAGE` Efface une image.

`docker ps` Lister les conteneurs en cours d'exécution.

`docker ps -a` Lister tous les conteneurs (actifs ou pas).

`docker run --rm ubuntu:latest cat /etc/os-release` Permet de dire au conteneur d'exécuter une commande. Créé un conteneur, exécuté la commande cat et supprimé le conteneur.

`docker rmi -f ubuntu:latest` permet de forcer la suppression d'une image qui aurait un conteneur dépendant.

`docker start CONTAINER` démarre un conteneur.

`docker stop CONTAINER` Stop un conteneur.

`docker rm $(docker ps -aq)` permet d'effacer tous les conteneurs non actifs.

`docker rm -f $(docker ps -aq)` le flag `f` permet d'effacer tous les conteneurs.

`docker system prune` Efface tout ce qui ne serta à rien, les conteneurs inactifs, les images sans nom et sans repo (dangling) et les réseaux inutilisés.

`docker system prune -a` Tout remettre à zéro. Efface toutes les images et les conteneurs.

`docker build .` Si un fichier Dockerfile existe dans le répertoire courant, on lance une build.

`docker build --no-cache .` On reconstruit tout!

`docker build --no-cache . -t json-server:v0.1` le flag `t` pour nommer une image et le `:v0.1` pour lui donner une version.

`docker run --rm -p 8000:3000 json-server:v0.1` Le flag `p` sert à exécuter un conteneur en bindant les ports de l'hôte et du conteneur. Le premier port est celui de l'hôte, le second celui du conteneur. Il faudra donc aller sur `http://localhost:8000`.

`docker login -u votrepseudohub` la commande vous demandera un mot de passe, ce mot de pase c'est le token que vous avez créer.

`docker tag local-image:tagname new-repo:tagname` On tag une image pour l'envoyer sur dockerhub

`docker push new-repo:tagname` On push notre image sur dockerhub.
