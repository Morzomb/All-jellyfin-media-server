# All-jellyfin-media-server

<div style="text-align: center">
    <img src="image/Isyrr.png">
</div>

Bienvenue sur le Repository All-jellyfin-media-server ! Ce Repository contient tout ce dont vous avez besoin pour créer votre propre serveur multimédia Jellyfin avec Sonarr, Radarr, jellyseerr, Prowlarr, Jackett, qBittorrent et Gluetun (Nord VPN) dans un docker compose. Nous allons appeler la compilation de tous les conteneurs **Isyrr** pour que ca soit plus simple.

![](https://img.shields.io/github/stars/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/forks/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/tag/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/release/Morzomb/All-jellyfin-media-server.svg) 
![](https://img.shields.io/github/issues/Morzomb/All-jellyfin-media-server.svg)
[![GitHub last commit](https://img.shields.io/github/last-commit/Morzomb/All-jellyfin-media-server.svg)](https://github.com/Morzomb/All-jellyfin-media-server/commits/master)
![GitHub repo size](https://img.shields.io/github/repo-size/Morzomb/All-jellyfin-media-server)
![visitors](https://visitor-badge.laobi.icu/badge?page_id=Morzomb.All-jellyfin-media-server.id)


**Acceder au repository en [Anglais](https://github.com/Morzomb/All-jellyfin-media-server/tree/Main)**

## Table de matière :

- [À quoi sert ce Isyrr ?](#à-quoi-sert-isyrr)
  - [Jellyfin](#jellyfin)
  - [Jellyseerr](#jellyseerr)
  - [Sonarr](#sonarr)
  - [Radarr](#radarr)
  - [Jackett](#jackett)
  - [Flaresolverr](#flaresolverr)
  - [QBittorrent](#qbittorrent)
  - [Gluetun avec Nord VPN](#gluetun-nordvpn)
- [Prérequis](#prérequis)
  - [Utilisation de Docker](#docker)
  - [NVidia](#nvidia)
- [Installation](#installation)
  - [Installation Classic](#basic-installation)
  - [Installation avec NVidia](#installation-avec-uniquement-nvidia)
  - [Installation avec VPN](#installation-avec-uniquement-le-vpn)
  - [Installation avec NVidia & VPN](#installation-avec-nvidia--vpn)
- [Disclaimer](#Disclaimer)
- [Creer une issues](https://github.com/Morzomb/All-jellyfin-media-server/issues)

## À quoi sert Isyrr ?

Ce Repository vous permet de créer votre propre serveur multimédia Jellyfin avec tous les outils nécessaires pour gérer vos films, séries TV, musiques et livres électroniques. Il comprend également des outils pour automatiser le téléchargement de nouveaux contenus et pour protéger votre vie privée en utilisant un VPN.

Isyrr utilise Docker et Docker Compose pour déployer les services. Les fichiers Docker Compose se trouvent dans les répertoires with-vpn et without-vpn.

Pour utiliser Docker Compose, assurez-vous que Docker est installé sur votre système.

---

### Jellyfin 

[Jellyfin](https://jellyfin.org/) est un logiciel de serveur multimédia open source qui vous permet de diffuser vos films, séries TV, musiques et livres électroniques sur tous vos appareils. Il est compatible avec de nombreux types de fichiers multimédias et prend en charge la diffusion en continu sur de nombreux appareils.

<div style="text-align: center">
    <img src="https://jellyfin.org/images/logo.svg" width="300" height="100">
</div>

### Jellyseerr

Jellyseerr is an open-source application that allows you to automate the management of your Jellyfin media server. It works by monitoring your Jellyfin library and automatically searching for and downloading new content based on your preferences. Jellyseerr supports integration with various other tools, such as Sonarr and Radarr, to provide a seamless experience for managing your media collection.

<div style="text-align: center"> 
    <img src="https://raw.githubusercontent.com/Fallenbagel/jellyseerr/develop/public/logo_full.svg" width="300" height="100"> 
</div>

### Sonarr :

[Sonarr](https://sonarr.tv/) est un logiciel de gestion de séries TV qui vous permet de rechercher, télécharger et gérer automatiquement vos séries TV préférées. Il fonctionne avec de nombreux types de trackers et de clients torrent et prend en charge la recherche automatique de sous-titres.


<div style="text-align: center">
    <img src="image/sonarr-banner2.png" width="300" height="100">
</div>

### Radarr :

[Radarr](https://radarr.video/) est un logiciel de gestion de films qui vous permet de rechercher, télécharger et gérer automatiquement vos films préférés. Il fonctionne avec de nombreux types de trackers et de clients torrent et prend en charge la recherche automatique de sous-titres.

<div style="text-align: center">
    <img src="https://warlord0blog.files.wordpress.com/2022/01/radarr_logo-1.png" width="300" height="100">
</div>

### Jackett :

[Jackett](https://github.com/Jackett/Jackett) est un logiciel de proxy pour les trackers torrent qui vous permet de rechercher des fichiers torrent sur de nombreux trackers à partir d'un seul endroit. Il fonctionne avec de nombreux types de clients torrent et prend en charge l'authentification et la recherche avancée.

<div style="text-align: center">
    <img src="https://avatars.githubusercontent.com/u/15383019?s=280&v=4" width="100" height="100">
</div>

### Flaresolverr

[Flaresolverr](https://github.com/FlareSolverr/FlareSolverr) est un logiciel open source qui vous permet de contourner les restrictions de streaming sur les sites de partage de vidéos. Il fonctionne en résolvant les liens de streaming et en contournant les blocages géographiques et les restrictions de lecture.

<div style="text-align: center">
    <img src="https://avatars.githubusercontent.com/u/75936191?v=4" width="200" height="200">
</div>

### Prowlarr :

[Prowlarr](https://github.com/Prowlarr/Prowlarr) est un logiciel de gestion de téléchargements qui vous permet de rechercher et de télécharger automatiquement des fichiers à partir de nombreux types de sources, y compris les trackers torrent, les newsgroups et les sites de téléchargement direct.

<div style="text-align: center">
    <img src="https://prowlarr.com/logo/128.png" width="100" height="100">
</div>

### qBittorrent

[qBittorrent](https://www.qbittorrent.org/) est un client BitTorrent open source qui vous permet de télécharger des fichiers torrent. Il est léger, facile à utiliser et prend en charge de nombreuses fonctionnalités avancées telles que la recherche intégrée de torrents, le chiffrement, la création de torrents et la prise en charge de trackers privés.

<div style="text-align: center">
    <img src="https://a.fsdn.com/allura/p/qbittorrent/icon?1518743661?&w=90" width="100" height="100">
</div>

### Gluetun (NordVPN)

[Gluetun](https://github.com/qdm12/gluetun) est un client VPN open source qui vous permet de vous connecter aux serveurs NordVPN. Il est facile à utiliser et prend en charge de nombreuses fonctionnalités avancées telles que la redirection de port, la protection contre les fuites DNS et la prise en charge de plusieurs protocoles VPN.

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

Pour utiliser Docker Compose avec ce référentiel, vous devez d'abord choisir si vous souhaitez utiliser la version avec VPN ou sans VPN. Ensuite, accédez au répertoire correspondant (with-vpn ou without-vpn) et exécutez la commande suivante :

```bash
docker-compose up -d
```
Pour éteindre la stack :

```bash
docker-compose down
```

## NVIDIA

Pour ma part mon serveur dispose d'un carte Graphique Nvidia GForce 1060. L'os installer est un promox 8.1.10 basée sur debian 12.

1. Your `/etc/apt/sources.list` should look like this:

```bash
deb http://ftp.debian.org/debian bookworm main contrib
deb http://ftp.debian.org/debian bookworm-updates main contrib

# Proxmox VE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# security updates
deb http://security.debian.org/debian-security bookworm-security main contrib

# Debian Bookworm
# Ajouter cette ligne 
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
```

2. Mise à jour des dépots :
```bash
apt update
```
3. Installation des mises à jours :
```bash
apt upgrade
```
4. Installation des drivers NVidia : 

Seulement pour un environement promox :

```bash
apt install pve-headers
```
Ensuite :
```bash
apt install libnvidia-cfg1 nvidia-kernel-source nvidia-kernel-common nvidia-driver 
```

6. Reboot

7. Ensuite entrer **nvidia-smi** qui devrai afficher :

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

Il peut y avoir des erreurs lors de l'installation il est préférable d'utiliser  nvidia-patch :

```bash
git clone https://github.com/keylase/nvidia-patch.git

cd nvidia-patch
./patch.sh
```

# Installation

Tout d'abords il faut clonner le repository  :

```bash
git clone -b fr https://github.com/Morzomb/All-jellyfin-media-server.git
cd All-jellyfin-media-server/
```

## Basic Installation :

Installation classic sans `VPN` et sans `NVidia` :

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

## Installation avec uniquement NVidia :

Installation classic sans `VPN` mais avec `NVidia` :

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

## Installation avec uniquement le VPN :

Installation classic avec `VPN` mais sans `NVidia` :

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

## Installation avec NVidia & VPN :

Installation classic avec `VPN` mais avec `NVidia` :

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

# Disclaimer

Ce code est fourni à des fins informatives uniquement et ne doit pas être utilisé à des fins illégales. Je ne suis pas responsable des actions effectuées par les utilisateurs de ce code. Ce code a pour but informatif et si les personnes souhaitent l'utiliser, elles doivent se renseigner auprès des lois de leurs pays.
