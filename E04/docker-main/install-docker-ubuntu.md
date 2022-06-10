# Docker

---

Récap des commandes à faire pour installer et utiliser docker, d'après les liens suivants.

<https://docs.docker.com/engine/install/ubuntu/>

<https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user>

```bash
sudo apt-get update

sudo apt-get install \
 ca-certificates \
 curl \
 gnupg \
 lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo groupadd docker
sudo gpasswd -a $USER docker
```

REBOOT

`docker run hello-world`


Installer docker desktop sur `ubuntu 22.04`:
On télécharge ici: <https://docs.docker.com/desktop/release-notes/>

`sudo apt-get install ./docker-desktop-4.8.2-amd64.deb` Attention au `./`