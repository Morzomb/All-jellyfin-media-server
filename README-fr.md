# All-jellyfin-media-server

<div style="text-align: center">
    <img src="image/Isyrr.png">
</div>

Bienvenue dans le référentiel All-jellyfin-media-server ! Ce référentiel contient tout ce dont vous avez besoin pour créer votre propre serveur multimédia Jellyfin avec Sonarr, Radarr, Jellyseerr, Prowlarr, Jackett, qBittorrent et Gluetun (VPN) dans une configuration Docker Compose. Nous désignerons la compilation de tous les conteneurs sous le nom **Isyrr** pour simplifier.

![](https://img.shields.io/github/stars/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/forks/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/tag/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/release/Morzomb/All-jellyfin-media-server.svg) 
![](https://img.shields.io/github/issues/Morzomb/All-jellyfin-media-server.svg)
[![GitHub last commit](https://img.shields.io/github/last-commit/Morzomb/All-jellyfin-media-server.svg)](https://github.com/Morzomb/All-jellyfin-media-server/commits/master)
![GitHub repo size](https://img.shields.io/github/repo-size/Morzomb/All-jellyfin-media-server)
![visitors](https://visitor-badge.laobi.icu/badge?page_id=Morzomb.All-jellyfin-media-server.id)


**Access repository in [English](https://github.com/Morzomb/All-jellyfin-media-server)**

## Table de matière :

- [À quoi sert Isyrr ?](#a-quoi-sert-isyrr)
  - [Jellyfin](#jellyfin)
  - [Jellyseerr](#jellyseerr)
  - [Sonarr](#sonarr)
  - [Radarr](#radarr)
  - [Jackett](#jackett)
  - [Flaresolverr](#flaresolverr)
  - [QBittorrent](#qbittorrent)
  - [Gluetun (VPN)](#gluetun-vpn)
- [Prérequis](#prérequis)
  - [Docker](#docker)
  - [NVidia](#nvidia)
  - [VPN](#vpn)
    - [Test du VPN](#troubleshoot-vpn)
- [Installation](#installation)
  - [Basic Installation](#installation-de-base)
  - [Installation avec NVidia](#installation-avec-nvidia-uniquement)
  - [Installation avec VPN](#installation-avec-vpn-uniquement)
  - [Installation avec NVidia & VPN](#installation-avec-nvidia-et-vpn)
- [Acces aux applications](#acces-aux-applications)
  - [Mise a jour des applications](#mise-a-jour-des-applications)
- [Disclaimer](#Disclaimer)
- [Creer une issues](https://github.com/Morzomb/All-jellyfin-media-server/issues)

## A quoi sert Isyrr ?

Ce référentiel vous permet de créer votre propre serveur multimédia Jellyfin avec tous les outils nécessaires pour gérer vos films, séries TV, musique et livres électroniques. Il inclut également des outils pour automatiser le téléchargement de nouveaux contenus et protéger votre vie privée en utilisant un VPN.

Isyrr utilise Docker et Docker Compose pour déployer les services. Les fichiers Docker Compose peuvent être trouvés dans les répertoires avec-vpn et sans-vpn.

Pour utiliser Docker Compose, assurez-vous d'avoir Docker installé sur votre système.

---

### Jellyfin 

[Jellyfin](https://jellyfin.org/) est un logiciel serveur multimédia open-source qui vous permet de diffuser vos films, séries TV, musique et livres électroniques sur tous vos appareils. Il est compatible avec de nombreux types de fichiers multimédias et prend en charge la diffusion vers de nombreux appareils.

<div style="text-align: center">
    <img src="https://jellyfin.org/images/logo.svg" width="300" height="100">
</div>

### Jellyseerr

[Jellyseerr](https://github.com/Fallenbagel/jellyseerr) est une application open-source qui vous permet d'automatiser la gestion de votre serveur multimédia Jellyfin. Il fonctionne en surveillant votre bibliothèque Jellyfin et en recherchant et téléchargeant automatiquement de nouveaux contenus en fonction de vos préférences. Jellyseerr prend en charge l'intégration avec divers autres outils, tels que Sonarr et Radarr, pour offrir une expérience fluide de gestion de votre collection multimédia.

<div style="text-align: center"> 
    <img src="https://raw.githubusercontent.com/Fallenbagel/jellyseerr/develop/public/logo_full.svg" width="300" height="100"> 
</div>

### Sonarr :

[Sonarr](https://sonarr.tv/) est un logiciel de gestion de séries TV qui vous permet de rechercher, télécharger et gérer vos séries TV préférées automatiquement. Il fonctionne avec de nombreux types de trackers et clients torrent et prend en charge le téléchargement automatique de sous-titres.


<div style="text-align: center">
    <img src="image/sonarr-banner2.png" width="300" height="100">
</div>

### Radarr :

[Radarr](https://radarr.video/) est un logiciel de gestion de films qui vous permet de rechercher, télécharger et gérer vos films préférés automatiquement. Il fonctionne avec de nombreux types de trackers et clients torrent et prend en charge le téléchargement automatique de sous-titres.

<div style="text-align: center">
    <img src="https://warlord0blog.files.wordpress.com/2022/01/radarr_logo-1.png" width="300" height="100">
</div>

### Jackett :

[Jackett](https://github.com/Jackett/Jackett) est un logiciel proxy pour les trackers torrent qui vous permet de rechercher des fichiers torrent sur de nombreux trackers depuis un seul endroit. Il fonctionne avec de nombreux types de clients torrent et prend en charge l'authentification et la recherche avancée.

<div style="text-align: center">
    <img src="https://avatars.githubusercontent.com/u/15383019?s=280&v=4" width="100" height="100">
</div>

### Flaresolverr

[Flaresolverr](https://github.com/FlareSolverr/FlareSolverr) est un logiciel open-source qui vous permet de contourner les restrictions de diffusion sur les sites de partage vidéo. Il fonctionne en résolvant les liens de diffusion et en contournant les blocages géographiques et les restrictions de lecture.

<div style="text-align: center">
    <img src="https://avatars.githubusercontent.com/u/75936191?v=4" width="200" height="200">
</div>

### Prowlarr :

[Prowlarr](https://github.com/Prowlarr/Prowlarr) est un logiciel de gestion de téléchargement qui vous permet de rechercher et de télécharger automatiquement des fichiers à partir de nombreux types de sources, y compris les trackers torrent, les groupes de discussion et les sites de téléchargement direct.

<div style="text-align: center">
    <img src="https://prowlarr.com/logo/128.png" width="100" height="100">
</div>

### qBittorrent

[qBittorrent](https://www.qbittorrent.org/) est un logiciel client BitTorrent open-source qui vous permet de télécharger des fichiers torrent. Il est léger, facile à utiliser et prend en charge de nombreuses fonctionnalités avancées telles que la recherche de torrent intégrée, le chiffrement, la création de torrent et la prise en charge des trackers privés.

<div style="text-align: center">
    <img src="https://a.fsdn.com/allura/p/qbittorrent/icon?1518743661?&w=90" width="100" height="100">
</div>

### Gluetun (VPN)

[Gluetun](https://github.com/qdm12/gluetun) est un logiciel client VPN open-source qui vous permet de vous connecter aux serveurs VPN. Il est facile à utiliser et prend en charge de nombreuses fonctionnalités avancées telles que le transfert de port, la protection contre les fuites DNS et la prise en charge de plusieurs protocoles VPN.

<div style="text-align: center">
  <img src="https://raw.githubusercontent.com/qdm12/gluetun/master/title.svg" width="300" height="200"> <img src="https://m.media-amazon.com/images/I/31o0QB0R0sL.png" width="200" height="200">
</div>

---

# Prérequis

## Docker

Pour installer Docker sur votre système, vous pouvez utiliser le script suivant :
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

### Utilisation de Docker Compose

Pour utiliser Docker Compose avec ce référentiel, vous devez d'abord choisir si vous souhaitez utiliser la version avec VPN ou sans VPN. Ensuite, accédez au répertoire correspondant (avec-vpn ou sans-vpn) et exécutez la commande suivante :

```bash
docker-compose up -d
```
Pour arrêter la stack :

```bash
docker-compose down
```

## NVIDIA

Pour mon serveur, il dispose d'une carte graphique NVIDIA GeForce 1060. Le système d'exploitation installé est Proxmox 8.1.10 basé sur Debian 12. Pour voir si votre carte est [compatible.](https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new)

1. Votre `/etc/apt/sources.list` devrais resembler à ca :

```bash
deb http://ftp.debian.org/debian bookworm main contrib
deb http://ftp.debian.org/debian bookworm-updates main contrib

# Proxmox VE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# security updates
deb http://security.debian.org/debian-security bookworm-security main contrib

# Debian Bookworm
### Ajoutez cette ligne
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
```

Et : 

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

2. Mettez à jour les dépôts :

```bash
apt update
```

3. Installez les mises à jour :

```bash
apt upgrade
```

4. Installez les pilotes NVIDIA :

Uniquement pour l'environnement Proxmox :

```bash
apt install pve-headers
```
Ensuite :

```bash
apt install libnvidia-cfg1 nvidia-kernel-source nvidia-kernel-common nvidia-driver nvidia-container-toolkit

nvidia-ctk runtime configure --runtime=docker
```

5. Redémarrez la machine

6. Ensuite, entrez **nvidia-smi** qui devrait afficher :

```
root@pve:~#nvidia-smi
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 525.147.05   Driver Version: 525.147.05   CUDA Version: 12.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  On   | 00000000:01:00.0 Off |                  N/A |
| N/A   47C    P8     9W /  78W |      1MiB /  3072MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

Il peut y avoir des erreurs pendant l'installation ; il est préférable d'utiliser nvidia-patch :

```bash
git clone https://github.com/keylase/nvidia-patch.git

cd nvidia-patch
./patch.sh
```

## VPN 

Maintenant, nous allons voir comment configurer le VPN. Personnellement, j'utiliserai NordVPN, mais vous pouvez trouver la configuration pour de nombreux autres fournisseurs [VPN ICI](https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers).

Tout d'abord, vous devez vous connecter au site Web de Nord VPN. 

1. Go to Nord VPN services :

<div style="text-align: center">
    <img src="image/vpn1.png">
</div>

2. Sélectionnez la configuration manuelle de NordVPN :

<div style="text-align: center">
    <img src="image/vpn2.png">
</div>

3. Vous trouverez les logins et mots de passe pour le conteneurs gluetun :

<div style="text-align: center">
    <img src="image/vpn3.png">
</div>

### Troubleshoot VPN 

Une fois le Docker lancé, vous pourrez tester votre VPN avec la commande suivante :

```bash
docker exec qbittorrent curl -s https://api.ipify.org/
# Résultat
94.101.115.63
```

De mon côté, il m'affiche une adresse IP en Belgique :

<div style="text-align: center">
    <img src="image/vpn4.png">
</div>

---

# Installation

Tout d'abord, clonez le référentiel :

```bash
git clone -b fr https://github.com/Morzomb/All-jellyfin-media-server.git
cd All-jellyfin-media-server/
```

## Installation de base :

Installation classique sans `VPN` et sans `NVidia` :

```yaml
---
version: "3.3"
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - WEBUI_PORT=8080
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - DOCKER_MODS=ghcr.io/gabe565/linuxserver-mod-vuetorrent
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/qbittorrent:/config
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    environment:
      - LOG_LEVEL=${LOG_LEVEL:-info}
      - LOG_HTML=${LOG_HTML:-false}
      - CAPTCHA_SOLVER=${CAPTCHA_SOLVER:-none}
      - TZ=${TZ}
    ports:
      - 8191:8191
    restart: unless-stopped
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
  jackett:
    image: lscr.io/linuxserver/jackett:latest
    container_name: jackett
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/jackett:/config
    ports:
      - 9117:9117
    restart: unless-stopped
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/sonarr:/config
      - ${COMMON_PATH}/sonarr/tv:/tv
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/radarr:/config
      - ${COMMON_PATH}/radarr/movies:/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - 8096:8096
      - 8920:8920
      - 7359:7359/udp
      - 1900:1900/udp
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/jellyfin:/config
      - ${COMMON_PATH}/jellyfin/cache:/cache
      - ${COMMON_PATH}/sonarr/tv:/data/tvshows
      - ${COMMON_PATH}/radarr/movies:/data/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/data/media_downloads
    restart: unless-stopped
  jellyseerr:
    image: fallenbagel/jellyseerr:latest
    container_name: jellyseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=${TZ}
    ports:
      - 5055:5055
    volumes:
      - ${COMMON_PATH}/configs/jellyseerr:/app/config
    restart: unless-stopped
```

Pour lancer l'installation, exécutez simplement :

```bash
docker compose -f docker-compose.yaml up -d
```

## Installation avec NVidia uniquement :

Installation classique sans `VPN` mais avec `NVidia` :

```yaml
---
version: "3.3"
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - WEBUI_PORT=8080
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - DOCKER_MODS=ghcr.io/gabe565/linuxserver-mod-vuetorrent
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/qbittorrent:/config
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    environment:
      - LOG_LEVEL=${LOG_LEVEL:-info}
      - LOG_HTML=${LOG_HTML:-false}
      - CAPTCHA_SOLVER=${CAPTCHA_SOLVER:-none}
      - TZ=${TZ}
    ports:
      - 8191:8191
    restart: unless-stopped
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
  jackett:
    image: lscr.io/linuxserver/jackett:latest
    container_name: jackett
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/jackett:/config
    ports:
      - 9117:9117
    restart: unless-stopped
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/sonarr:/config
      - ${COMMON_PATH}/sonarr/tv:/tv
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/radarr:/config
      - ${COMMON_PATH}/radarr/movies:/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - 8096:8096
      - 8920:8920
      - 7359:7359/udp
      - 1900:1900/udp
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/jellyfin:/config
      - ${COMMON_PATH}/jellyfin/cache:/cache
      - ${COMMON_PATH}/sonarr/tv:/data/tvshows
      - ${COMMON_PATH}/radarr/movies:/data/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/data/media_downloads
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities:
                - gpu
  jellyseerr:
    image: fallenbagel/jellyseerr:latest
    container_name: jellyseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=${TZ}
    ports:
      - 5055:5055
    volumes:
      - ${COMMON_PATH}/configs/jellyseerr:/app/config
    restart: unless-stopped
```

Pour lancer l'installation, exécutez simplement :

```bash
docker compose -f docker-compose-nvidia.yaml up -d
```

## Installation avec VPN uniquement :

Installation classique avec `VPN` mais sans `NVidia` :

```yaml
---
version: "3.3"
services:
  nordvpn:
    container_name: GlueTun-VPN
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    ports:
      - 8080:8080
      - 51420:51420
      - 51420:51420/udp
    environment:
      - VPN_SERVICE_PROVIDER=nordvpn
      - OPENVPN_USER=${OPENVPN_USER}
      - OPENVPN_PASSWORD=${OPENVPN_PASSWORD}
      - SERVER_REGIONS=Belgium
      - VPN_TYPE=openvpn
    restart: always
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    network_mode: service:nordvpn
    container_name: qbittorrent
    depends_on:
      - nordvpn
    environment:
      - WEBUI_PORT=8080
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - DOCKER_MODS=ghcr.io/gabe565/linuxserver-mod-vuetorrent
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/qbittorrent:/config
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    restart: unless-stopped
  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    environment:
      - LOG_LEVEL=${LOG_LEVEL:-info}
      - LOG_HTML=${LOG_HTML:-false}
      - CAPTCHA_SOLVER=${CAPTCHA_SOLVER:-none}
      - TZ=${TZ}
    ports:
      - 8191:8191
    restart: unless-stopped
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
  jackett:
    image: lscr.io/linuxserver/jackett:latest
    container_name: jackett
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/jackett:/config
    ports:
      - 9117:9117
    restart: unless-stopped
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/sonarr:/config
      - ${COMMON_PATH}/sonarr/tv:/tv
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/radarr:/config
      - ${COMMON_PATH}/radarr/movies:/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - 8096:8096
      - 8920:8920
      - 7359:7359/udp
      - 1900:1900/udp
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/jellyfin:/config
      - ${COMMON_PATH}/jellyfin/cache:/cache
      - ${COMMON_PATH}/sonarr/tv:/data/tvshows
      - ${COMMON_PATH}/radarr/movies:/data/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/data/media_downloads
    restart: unless-stopped
  jellyseerr:
    image: fallenbagel/jellyseerr:latest
    container_name: jellyseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=${TZ}
    ports:
      - 5055:5055
    volumes:
      - ${COMMON_PATH}/configs/jellyseerr:/app/config
    restart: unless-stopped
```

Pour lancer l'installation, exécutez simplement :

```bash
docker compose -f docker-compose-vpn.yaml up -d
```

## Installation avec NVidia et VPN :

Installation classique avec `VPN` et `NVidia` :

```yaml
---
version: "3.3"
services:
  nordvpn:
    container_name: GlueTun-VPN
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    ports:
      - 8080:8080
      - 51420:51420
      - 51420:51420/udp
    environment:
      - VPN_SERVICE_PROVIDER=nordvpn
      - OPENVPN_USER=${OPENVPN_USER}
      - OPENVPN_PASSWORD=${OPENVPN_PASSWORD}
      - SERVER_REGIONS=Belgium
      - VPN_TYPE=openvpn
    restart: always
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    network_mode: service:nordvpn
    container_name: qbittorrent
    depends_on:
      - nordvpn
    environment:
      - WEBUI_PORT=8080
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - DOCKER_MODS=ghcr.io/gabe565/linuxserver-mod-vuetorrent
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/qbittorrent:/config
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    restart: unless-stopped
  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    environment:
      - LOG_LEVEL=${LOG_LEVEL:-info}
      - LOG_HTML=${LOG_HTML:-false}
      - CAPTCHA_SOLVER=${CAPTCHA_SOLVER:-none}
      - TZ=${TZ}
    ports:
      - 8191:8191
    restart: unless-stopped
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
  jackett:
    image: lscr.io/linuxserver/jackett:latest
    container_name: jackett
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}/configs/jackett:/config
    ports:
      - 9117:9117
    restart: unless-stopped
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/sonarr:/config
      - ${COMMON_PATH}/sonarr/tv:/tv
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/radarr:/config
      - ${COMMON_PATH}/radarr/movies:/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=0
      - PGID=0
      - TZ=${TZ}
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - 8096:8096
      - 8920:8920
      - 7359:7359/udp
      - 1900:1900/udp
    volumes:
      - ${COMMON_PATH}:${COMMON_PATH}
      - ${COMMON_PATH}/configs/jellyfin:/config
      - ${COMMON_PATH}/jellyfin/cache:/cache
      - ${COMMON_PATH}/sonarr/tv:/data/tvshows
      - ${COMMON_PATH}/radarr/movies:/data/movies
      - ${COMMON_PATH}/qbittorrent/downloads:/data/media_downloads
    restart: unless-stopped
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities:
                - gpu
  jellyseerr:
    image: fallenbagel/jellyseerr:latest
    container_name: jellyseerr
    environment:
      - LOG_LEVEL=debug
      - TZ=${TZ}
    ports:
      - 5055:5055
    volumes:
      - ${COMMON_PATH}/configs/jellyseerr:/app/config
    restart: unless-stopped
```

Pour lancer l'installation, exécutez simplement :

```bash
docker compose -f docker-compose-nvidia-vpn.yaml up -d
```

# Acces aux applications

Une fois les applications déployées, vous pouvez y accéder en utilisant les adresses suivantes :

* Jellyfin : http://localhost:8096
* Sonarr : http://localhost:8989
* Radarr : http://localhost:7878
* Jackett : http://localhost:9117
* Prowlarr : http://localhost:9696
* qBittorrent : http://localhost:8080

Gluetun (Nord VPN) sera automatiquement configuré pour être utilisé avec les applications.

## Mise a jour des applications

Pour mettre à jour les applications, vous devez arrêter les conteneurs en cours d'exécution et supprimer les images Docker existantes. Vous pouvez utiliser les commandes suivantes pour effectuer ces opérations :

```bash
docker-compose down
docker image prune -a
```

Ensuite, vous pouvez exécuter `docker-compose up -d` pour redémarrer les conteneurs avec les dernières versions des applications.

# Clause de non-responsabilité

Ce code est fourni à des fins d'information seulement et ne doit pas être utilisé à des fins illégales. Je ne suis pas responsable des actions effectuées par les utilisateurs de ce code. Ce code est à des fins d'information, et si les gens souhaitent l'utiliser, ils devraient consulter les lois de leurs pays.