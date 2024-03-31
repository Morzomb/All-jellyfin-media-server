# All-jellyfin-media-server

Bienvenue sur le référentiel All-jellyfin-media-server ! Ce référentiel contient tout ce dont vous avez besoin pour créer votre propre serveur multimédia Jellyfin avec Sonarr, Radarr, Jackett, Prowlarr, qBittorrent et Gluetun (Nord VPN) dans un docker compose.

![](https://img.shields.io/github/stars/Morzomb/All-jellyfin-media-server.svg) ![](https://img.shields.io/github/forks/Morzomb/All-jellyfin-media-server.svg) ![](https://img.shields.io/github/tag/Morzomb/All-jellyfin-media-server.svg) ![](https://img.shields.io/github/release/Morzomb/All-jellyfin-media-server.svg) ![](https://img.shields.io/github/issues/Morzomb/All-jellyfin-media-server.svg)


## À quoi sert ce référentiel ?

Ce référentiel vous permet de créer votre propre serveur multimédia Jellyfin avec tous les outils nécessaires pour gérer vos films, séries TV, musiques et livres électroniques. Il comprend également des outils pour automatiser le téléchargement de nouveaux contenus et pour protéger votre vie privée en utilisant un VPN.

---

### Docker

Ce référentiel utilise Docker et Docker Compose pour déployer les services. Les fichiers Docker Compose se trouvent dans les répertoires with-vpn et without-vpn.

Pour utiliser Docker Compose, assurez-vous que Docker est installé sur votre système.

[Installer Docker & Docker-compose]()

### Jellyfin 

[Jellyfin](https://jellyfin.org/) est un logiciel de serveur multimédia open source qui vous permet de diffuser vos films, séries TV, musiques et livres électroniques sur tous vos appareils. Il est compatible avec de nombreux types de fichiers multimédias et prend en charge la diffusion en continu sur de nombreux appareils.

<div style="text-align: center">
    <img src="https://jellyfin.org/images/logo.svg" width="300" height="100">
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

## Disclaimer

Ce code est fourni à des fins informatives uniquement et ne doit pas être utilisé à des fins illégales. Je ne suis pas responsable des actions effectuées par les utilisateurs de ce code. Ce code a pour but informatif et si les personnes souhaitent l'utiliser, elles doivent se renseigner auprès des lois de leurs pays.
