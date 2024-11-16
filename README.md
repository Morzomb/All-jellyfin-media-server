# **All-jellyfin-media-server**

<div style="text-align: center">
    <img src="image/Isyrr.png" style="margin: 15px 10px;">
</div>


Welcome to the All-jellyfin-media-server Repository! This repository contains everything you need to create your own Jellyfin media server with Sonarr, Radarr, Jellyseerr, Prowlarr, Jackett, qBittorrent, and Gluetun (VPN) in a Docker Compose setup. We'll refer to the compilation of all containers as **Isyrr** to keep it simple.

![](https://img.shields.io/github/stars/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/forks/Morzomb/All-jellyfin-media-server.svg)
![](https://img.shields.io/github/release/Morzomb/All-jellyfin-media-server.svg) 
![](https://img.shields.io/github/issues/Morzomb/All-jellyfin-media-server.svg)
[![GitHub last commit](https://img.shields.io/github/last-commit/Morzomb/All-jellyfin-media-server.svg)](https://github.com/Morzomb/All-jellyfin-media-server/commits/master)
![GitHub repo size](https://img.shields.io/github/repo-size/Morzomb/All-jellyfin-media-server)
![visitors](https://visitor-badge.laobi.icu/badge?page_id=Morzomb.All-jellyfin-media-server.id)

> [!NOTE] 
> **Acceder au repository en [Français](README-fr.md)**

## **Table of contents :**

- [**All-jellyfin-media-server**](#all-jellyfin-media-server)
  - [**Table of contents :**](#table-of-contents-)
  - [**What is Isyrr for?**](#what-is-isyrr-for)
    - [**Jellyfin**](#jellyfin)
    - [**Jellyseerr**](#jellyseerr)
    - [**Sonarr**](#sonarr)
    - [**Radarr**](#radarr)
    - [**Jackett**](#jackett)
    - [**Flaresolverr**](#flaresolverr)
    - [**Prowlarr**](#prowlarr)
    - [**qBittorrent**](#qbittorrent)
    - [**Gluetun (VPN)**](#gluetun-vpn)
- [**Prerequisites**](#prerequisites)
  - [**Docker**](#docker)
    - [**Using Docker Compose :**](#using-docker-compose-)
  - [**NVIDIA**](#nvidia)
    - [**First Method**](#first-method)
  - [**Final Verification**](#final-verification)
  - [**Second Method**](#second-method)
- [**VPN**](#vpn)
  - [**NORD**](#nord)
  - [**PROTON**](#proton)
  - [**Troubleshoot VPN**](#troubleshoot-vpn)
- [**Installation**](#installation)
  - [**1. Basic Installation**](#1-basic-installation)
  - [**2. Installation with NVIDIA Only**](#2-installation-with-nvidia-only)
  - [**3. Installation with NVIDIA and VPN**](#3-installation-with-nvidia-and-vpn)
- [**Accessing Applications**](#accessing-applications)
- [**Configuration Guide for Web Interfaces Only**](#configuration-guide-for-web-interfaces-only)
  - [**qBittorrent**](#qbittorrent-1)
    - [**Category Configuration**](#category-configuration)
  - [**Radarr**](#radarr-1)
    - [**Media Management**](#media-management)
    - [**Download Clients**](#download-clients)
    - [**Indexer Jackett (Optional)**](#indexer-jackett-optional)
  - [**Sonarr**](#sonarr-1)
    - [**Media Management**](#media-management-1)
    - [**Download Clients**](#download-clients-1)
    - [**Indexer Jackett (Optional)**](#indexer-jackett-optional-1)
  - [**Prowlarr**](#prowlarr-1)
    - [**Configure Torrent Indexers**](#configure-torrent-indexers)
    - [**Configure FlareSolverr**](#configure-flaresolverr)
    - [**Configure Radarr**](#configure-radarr)
    - [**Configure Sonarr**](#configure-sonarr)
  - [**Jellyfin**](#jellyfin-1)
    - [**Initial Setup**](#initial-setup)
    - [**Adding Users to Jellyfin**](#adding-users-to-jellyfin)
  - [**Jellyseerr**](#jellyseerr-1)
    - [**Sign In / Configuration**](#sign-in--configuration)
    - [**Integrating with Radarr**](#integrating-with-radarr)
    - [**Integrating with Sonarr**](#integrating-with-sonarr)
- [**Updating Applications**](#updating-applications)
- [**Disclaimer**](#disclaimer)

## **What is Isyrr for?**

This repository allows you to create your own Jellyfin media server with all the necessary tools to manage your movies, TV shows, music, and eBooks. It also includes tools to automate the downloading of new content and to protect your privacy using a VPN.

Isyrr uses Docker and Docker Compose to deploy the services. Docker Compose files can be found in the directories with-vpn and without-vpn.

> [!IMPORTANT]  
> To use Docker Compose, make sure Docker is installed on your system.

---

### **Jellyfin**

[Jellyfin](https://jellyfin.org/) is an open-source media server software that allows you to stream your movies, TV shows, music, and eBooks to all your devices. It is compatible with many types of media files and supports streaming to numerous devices.

<div style="text-align: center">
    <img src="https://jellyfin.org/images/logo.svg" width="300" height="100"  style="margin: 15px 10px;">
</div>

### **Jellyseerr**

[Jellyseerr](https://github.com/Fallenbagel/jellyseerr) is an open-source application that allows you to automate the management of your Jellyfin media server. It works by monitoring your Jellyfin library and automatically searching for and downloading new content based on your preferences. Jellyseerr supports integration with various other tools, such as Sonarr and Radarr, to provide a seamless experience for managing your media collection.

<div style="text-align: center"> 
    <img src="https://raw.githubusercontent.com/Fallenbagel/jellyseerr/develop/public/logo_full.svg" width="300" height="100" style="margin: 15px 10px;"> 
</div>

### **Sonarr**

[Sonarr](https://sonarr.tv/) is TV show management software that allows you to search, download, and manage your favorite TV shows automatically. It works with many types of trackers and torrent clients and supports automatic subtitle downloading.


<div style="text-align: center">
    <img src="image/sonarr/sonarr.png" width="300" height="100" style="margin: 15px 10px;">
</div>

### **Radarr**

[Radarr](https://radarr.video/) is movie management software that allows you to search, download, and manage your favorite movies automatically. It works with many types of trackers and torrent clients and supports automatic subtitle downloading.

<div style="text-align: center">
    <img src="https://warlord0blog.files.wordpress.com/2022/01/radarr_logo-1.png" width="300" height="100" style="margin: 15px 10px;">
</div>

### **Jackett**

[Jackett](https://github.com/Jackett/Jackett) is a proxy software for torrent trackers that allows you to search for torrent files on many trackers from one place. It works with many types of torrent clients and supports authentication and advanced searching.

<div style="text-align: center">
    <img src="https://avatars.githubusercontent.com/u/15383019?s=280&v=4" width="100" height="100" style="margin: 15px 10px;">
</div>

### **Flaresolverr**

[Flaresolverr](https://github.com/FlareSolverr/FlareSolverr) is open-source software that allows you to bypass streaming restrictions on video-sharing sites. It works by resolving streaming links and bypassing geographical blocks and playback restrictions.

<div style="text-align: center">
    <img src="https://avatars.githubusercontent.com/u/75936191?v=4" width="200" height="200" style="margin: 15px 10px;">
</div>

### **Prowlarr**

[Prowlarr](https://github.com/Prowlarr/Prowlarr) is download management software that allows you to search for and automatically download files from many types of sources, including torrent trackers, newsgroups, and direct download sites.

<div style="text-align: center">
    <img src="https://prowlarr.com/logo/128.png" width="100" height="100" style="margin: 15px 10px;">
</div>

### **qBittorrent**

[qBittorrent](https://www.qbittorrent.org/) is open-source BitTorrent client software that allows you to download torrent files. It is lightweight, easy to use, and supports many advanced features such as built-in torrent search, encryption, torrent creation, and support for private trackers.

<div style="text-align: center">
    <img src="https://a.fsdn.com/allura/p/qbittorrent/icon?1518743661?&w=90" width="100" height="100" style="margin: 15px 10px;">
</div>

### **Gluetun (VPN)**

[Gluetun](https://github.com/qdm12/gluetun) is open-source VPN client software that allows you to connect to VPN servers. It is easy to use and supports many advanced features such as port forwarding, DNS leak protection, and support for multiple VPN protocols.

<div style="text-align: center">
  <img src="https://raw.githubusercontent.com/qdm12/gluetun/master/title.svg" width="300" height="200" style="margin: 15px 10px;">
</div>

<div style="text-align: center">
    <img src="https://m.media-amazon.com/images/I/51gvJaXQh4L.png" width="200" height="200" style="margin-right: 10px;">
    <img src="https://m.media-amazon.com/images/I/31o0QB0R0sL.png" width="200" height="200" style="margin-left: 10px;">
</div>

---

# **Prerequisites**

> [!NOTE]  
> This service requires a machine with at least 4 CPU cores and 8 GB of RAM. It is also highly recommended to have an NVIDIA GPU for optimal performance.

Première chose à faire mettre à jour votre systèmes :

```bash
sudo apt update && sudo apt upgrade
```

## **Docker**

To install Docker on your system, use the following commands:

Download the script with this command:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
```

Then run the script with this command:
```bash
sh get-docker.sh
```

> [!TIP]
> I recommend giving Docker administrative rights to your user:
> ```bash
> usermod -aG docker <user>
> ```
> After this command, disconnect and reconnect.


### **Using Docker Compose :**

To use Docker Compose with this repository, you first need to choose whether you want to use the version with VPN or without VPN. Then, navigate to the corresponding directory (with-vpn or without-vpn) and run the following command :

```bash
docker-compose up -d
```
To shut down the stack :

```bash
docker-compose down
```

**[`^        back to top        ^`](#table-of-contents)**

## **NVIDIA**

> [!WARNING]  
> Please be aware that due to the recent updates to Debian 12 and Proxmox, NVIDIA drivers have become unstable. Therefore, there are two methods for installing the drivers.

For my server, it has an NVIDIA GeForce 1060 graphics card. The installed OS is Proxmox 8.1.10, based on Debian 12. If you need to check compatibility, refer to the [NVIDIA support matrix](https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new).

### **First Method**

Go to the [NVIDIA website](https://www.nvidia.com/en-us/drivers/) and select your graphics card. Here is an example:

<div style="text-align: center">
    <img src="image/nvidia/nv1.png" style="margin: 15px 10px;">
</div>

---

<div style="text-align: center">
    <img src="image/nvidia/nv2.png" style="margin: 15px 10px;">
</div>

Copy the download link for the driver, you should get a link that looks like this:

```text
https://us.download.nvidia.com/XFree86/Linux-x86_64/550.127.05/NVIDIA-Linux-x86_64-550.127.05.run
```

1. System Update and Preparation

Update and upgrade your system to ensure all packages are up to date.

```bash
apt update
apt upgrade
```

2. Download and Prepare the NVIDIA Driver

Download the required NVIDIA driver.

```bash
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/550.127.05/NVIDIA-Linux-x86_64-550.127.05.run
chmod u+x NVIDIA-Linux-x86_64-550.127.05.run
```

3. Install the NVIDIA Container Toolkit Keys and Repository

Add the GPG key and configure the repository for NVIDIA container tools.

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

4. Update Repositories and Install Required Packages

Update the repositories and install the necessary packages for compilation.

```bash
apt update
apt install pve-headers gcc make
```

5. Install the NVIDIA Driver

Install the downloaded NVIDIA driver using the kernel source path.

```bash
./NVIDIA-Linux-x86_64-550.127.05.run --kernel-source-path /usr/src/linux-headers-6.8.12-3-pve/
```

6. Install and Configure NVIDIA Container Toolkit

Install the NVIDIA Container Toolkit and configure it for Docker.

```bash
apt install nvidia-container-toolkit
nvidia-ctk runtime configure --runtime=docker
```

7. Configure Docker Daemon

Edit the Docker configuration file to set up the runtime and data path.

```bash
nano /etc/docker/daemon.json
```

Add the following content :

```json
{
    "data-root": "/<YOUR_PATH>/docker",
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    }
}
```

8. Reboot

Your environment is now set up to run Docker containers with NVIDIA GPU support.


## **Final Verification**

Ensure the GPU is properly detected :

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

**[`^        back to top        ^`](#table-of-contents)**

## **Second Method**

> [!WARNING]  
> This method is deprecated as it can cause significant conflicts if you frequently update your server.

1. Your `/etc/apt/sources.list` should look like this :
```bash
deb http://ftp.debian.org/debian bookworm main contrib
deb http://ftp.debian.org/debian bookworm-updates main contrib

# Proxmox VE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# security updates
deb http://security.debian.org/debian-security bookworm-security main contrib

# Debian Bookworm
### Add this line
deb http://deb.debian.org/debian/ bookworm main contrib non-free non-free-firmware
```

And : 

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

2. Update repositories :
```bash
apt update
```
3. Install updates :
```bash
apt upgrade
```
4. Install NVIDIA drivers :

Only for Proxmox environment :

```bash
apt install pve-headers
```
Then :

```bash
apt install libnvidia-cfg1 nvidia-kernel-source nvidia-kernel-common nvidia-driver nvidia-container-toolkit

nvidia-ctk runtime configure --runtime=docker
```

5. Configure Docker Daemon

Edit the Docker configuration file to set up the runtime and data path.

```bash
nano /etc/docker/daemon.json
```

Add the following content:

```json
{
    "data-root": "/<YOUR_PATH>/docker",
    "runtimes": {
        "nvidia": {
            "args": [],
            "path": "nvidia-container-runtime"
        }
    }
}
```

6. Reboot

7. Then enter **nvidia-smi** which should display :

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

There might be errors during installation; it's preferable to use nvidia-patch :

```bash
git clone https://github.com/keylase/nvidia-patch.git

cd nvidia-patch
./patch.sh
```

> [!CAUTION]  
> If you need to restart the installation, here’s how to uninstall the NVIDIA drivers:
> 
> ```bash
> apt remove nvidia-driver
> apt purge *nvidia*
> apt autoremove
> apt clean
> apt search nvidia-driver
> apt autoremove glx-alternative-nvidia libegl-nvidia0 libgl1-nvidia-glvnd-glx libgles-nvidia1 libgles-nvidia2 libglx-nvidia0 nvidia-alternative nvidia-detect nvidia-driver nvidia-driver-bin nvidia-driver-libs nvidia-kernel-dkms nvidia-kernel-source nvidia-open-kernel-dkms nvidia-open-kernel-source xserver-xorg-video-nvidia
> ```
> If any residual files remain, search for them using `apt search nvidia-driver`.

**[`^        back to top        ^`](#table-of-contents)**

# **VPN**

Now we will see how to set up the VPN. Personally, I will use ProtonVPN and NordVPN, but you can find a number of other VPN providers as well [HERE](https://github.com/qdm12/gluetun-wiki/tree/main/setup/providers).

## **NORD**

First, you need to connect to the Nord VPN website.

1. Go to Nord VPN services :

<div style="text-align: center">
    <img src="image/vpn/vpn1.png" style="margin: 15px 10px;">
</div>

2. Select manual configuration of NordVPN :

<div style="text-align: center">
    <img src="image/vpn/vpn2.png" style="margin: 15px 10px;">
</div>

3. You can now take your login and password for the gluetun container :

<div style="text-align: center">
    <img src="image/vpn/vpn3.png" style="margin: 15px 10px;">
</div>

---

## **PROTON**

Go to [Protont VPN](https://account.protonvpn.com/downloads) website.

1. Go to Download :

<div style="text-align: center">
    <img src="image/vpn/pro1.png" style="margin: 15px 10px;">
</div>

2. Configure your VPN manually with an OS name to use, and make sure to enable NAT-PMP. Finally, select the desired country :

<div style="text-align: center">
    <img src="image/vpn/pro2.png" style="margin: 15px 10px;">
</div>

3. You can now gather your information for the Gluetun container setup :

<div style="text-align: center">
    <img src="image/vpn/pro3.png" style="margin: 15px 10px;">
</div>

> [!CAUTION]  
> Make sure you have either downloaded the file or copied its content into a text file, as some information will no longer be available after you click "Close".

## **Troubleshoot VPN** 

Once the Docker is launched, you can test your VPN with the following command :

```bash
docker exec qbittorrent curl -s https://api.ipify.org/
# Result
94.101.115.63
```

On my side, it shows me an IP address in Belgium :

<div style="text-align: center">
    <img src="image/vpn/vpn4.png" style="margin: 15px 10px;">
</div>

**[`^        back to top        ^`](#table-of-contents)**

---

# **Installation**

First, clone the repository :

```bash
git clone https://github.com/Morzomb/All-jellyfin-media-server.git
cd All-jellyfin-media-server/
```

For the installation, I have only created three versions of the `docker-compose` file.

Before proceeding, navigate to the `.env` file located in the `compose_files/` directory and complete it with the required information. This file must always be at the root of the `docker-compose` file you are going to launch.

```yaml
# BASE
COMMON_PATH=/YOUR_PATH/Isyrr
TZ=Europe/Paris

# Uncomment the lines below to enable the corresponding VPN configuration

# NORD VPN
# OPENVPN_USER=username  # Your username for NordVPN
# OPENVPN_PASSWORD=password  # Your password for NordVPN
# SERVER_REGIONS=Belgium  # Choose the server region (Belgium here)

# PROTON VPN 
# ENDPOINT_IP=PEER_ENDPOINT_IP  # The endpoint IP address of the VPN server
# WIREGUARD_ADDR=Interface_Address  # The WireGuard interface address
# ENDPOINT_PORT=51820  # Default port is 51820, but confirm if different
# DNS_ADDRESS=Interface_DNS  # DNS address for ProtonVPN
# PUBLIC_KEY=PEER_PublicKey  # The public key of the other peer
# PRIVATE_KEY=Interface_PrivateKey  # Your private key
```

> [!WARNING]  
> Make sure you uncomment and configure the settings according to the VPN service you're using. This step is essential for establishing a proper VPN connection.

## **1. Basic Installation**

Standard installation without a `VPN` or `NVIDIA`:

To start the installation, execute :

```bash
cd compose_files/
docker compose -f docker-compose.yaml up -d
```
[Go to the file here](compose_files/docker-compose.yaml)

## **2. Installation with NVIDIA Only**

Standard installation with `NVIDIA` but without a `VPN`:

To start the installation, execute :

```bash
cd compose_files/
docker compose -f docker-compose-nvidia.yaml up -d
```
[Go to the file here](compose_files/docker-compose-nvidia.yaml)

## **3. Installation with NVIDIA and VPN**

> [!WARNING]  
> If you use this method, fill in the `.env` file located in `compose_files/VPN`.

Standard installation with both `VPN` and `NVIDIA`:

To start the installation, execute :

```bash
cd compose_files/VPN/
docker compose -f docker-compose-<YOUR_VPN>-vpn.yaml up -d
```
[Go to the file here](compose_files/VPN/)

**[`^        back to top        ^`](#table-of-contents)**

# **Accessing Applications**

Once the applications are deployed, you can access them using the following addresses :

> [!IMPORTANT]  
> Replace `localhost` with the IP address of your machine or remote server if needed.


* Jellyfin : http://localhost:8096
* Sonarr : http://localhost:8989
* Radarr : http://localhost:7878
* Jackett : http://localhost:9117
* Prowlarr : http://localhost:9696
* qBittorrent : http://localhost:8080

Gluetun (Nord VPN) will be automatically configured to be used with the applications.

# **Configuration Guide for Web Interfaces Only**

> [!IMPORTANT]  
> All links containing the container name can be replaced with either the server IP or `localhost`. Also, replace `/COMMON_PATH/` with the path you configured in the `.env` file.


## **qBittorrent**

1. Open the WebUI by clicking on the application icon in the **DOCKER** tab and selecting **WebUI**.
2. Log in with the default credentials:
   - **Username**: `admin`
   - **Password**: `adminadmin`
   
<div style="text-align: center">
    <img src="image/qBittorrent/qbit1.png" style="margin: 15px 10px;">
</div>

   *Note: The default credentials may have changed, please check the documentation for updates on this.*

1. Once logged in, click the gear icon to go to **Options**.
2. Under the **Downloads** tab, configure the backup settings as follows:
   - **Default Torrent Management Mode**: `Automatic` (required for category-based save paths to work)
   - **When Torrent Category changed**: `Relocate torrent`
   - **When Default Save Path changed**: `Relocate affected torrents`
   - **When Category Save Path changed**: `Relocate affected torrents`
   - **Default Save Path**: `/downloads` 
3. Click **SAVE**.

<div style="text-align: center">
    <img src="image/qBittorrent/qbit2.png" style="margin: 15px 10px;">
</div>

### **Category Configuration**

1. In the WebUI, expand **CATEGORIES** in the left menu. Right-click on **All** and select **Add category...**.
2. In the **New Category** window, configure as follows:
   - **Category**: `radarr` (this corresponds to the category you will later configure in Radarr)
   - **Save path**: `/downloads/radarr`
3. Click **Add**.
4. Right-click on **All** again, select **Add category...**.
5. Configure as follows:
   - **Category**: `sonarr` (this should match the category configured later in Sonarr, by default `sonarr-tv`, but this guide uses `sonarr`)
   - **Save path**: `/downloads/sonarr`
6. Click **Add**.

<div style="text-align: center">
    <img src="image/qBittorrent/qbit3.png" style="margin: 15px 10px;">
</div>

<div style="text-align: center">
    <img src="image/qBittorrent/qbit4.png" style="margin: 15px 10px;">
    <img src="image/qBittorrent/qbit5.png" style="margin: 15px 10px;">
</div>

**[`^        back to top        ^`](#table-of-contents)**

---

## **Radarr**

### **Media Management**

1. Open the WebUI and go to **Settings** > **Media Management**.
2. Click **Add Root Folder**, add the path `/COMMON_PATH/radarr/movies`, and click **OK**.
3. Click **Show Advanced** at the top, scroll down to **Importing**, and make sure **Use Hardlinks instead of Copy** is enabled.

<div style="text-align: center">
    <img src="image/radarr/rad3.png" style="margin: 15px 10px;">
</div>

### **Download Clients**

1. In the WebUI, go to **Settings** > **Download Clients**.
2. Click **+** under **Download Clients**, then select **qBittorrent** from the **Add Download Client** window.
3. Fill in the fields as follows:
   - **Name**: `qBittorrent` (or another name of your choice)
   - **Host**: `qbittorrent`
   - **Username**: `admin`
   - **Password**: `adminadmin` (change it if you've modified it in qBittorrent)
   - **Category**: `radarr` (this should match the category set in qBittorrent)
4. Click **Test**. If you see a checkmark, it means the connection is working; if not, there is an error.
5. Click **Save**.

<div style="text-align: center">
    <img src="image/radarr/rad5.png" style="margin: 15px 10px;">
</div>

### **Indexer Jackett (Optional)**

1. In the WebUI, go to **Settings** > **Indexers**.
2. Click **+** under **Add Indexer**, then select **Torznab**.
3. Fill in the fields as follows:
   - **Name**: `Torznab` (or another name of your choice)
   - **URL**: `http://Jackett:9117/api/v2.0/indexers/YOUR_INDEXERS/results/torznab/`
   - **ApiKey**: Find the API key in the home menu at the top right.
4. Click **Test**. If you see a checkmark, it means the connection is working; if not, there is an error.
5. Click **Save**.

<div style="text-align: center">
    <img src="image/sonarr/son3.png" style="margin: 15px 10px;">
</div>

**[`^        back to top        ^`](#table-of-contents)**

---

## **Sonarr**

### **Media Management**

1. Open the WebUI and go to **Settings** > **Media Management**.
2. Click **Add Root Folder**, add the path `/COMMON_PATH/sonarr/tv`, and click **OK**.
3. Click **Show Advanced**, scroll down to **Importing**, and enable **Use Hardlinks instead of Copy**.

<div style="text-align: center">
    <img src="image/sonarr/son1.png" style="margin: 15px 10px;">
</div>

### **Download Clients**

1. In the WebUI, go to **Settings** > **Download Clients**.
2. Click **+** under **Download Clients**, then select **qBittorrent**.
3. Fill in the fields as follows:
   - **Name**: `qBittorrent` (or another name of your choice)
   - **Host**: `qbittorrent`
   - **Username**: `admin`
   - **Password**: `adminadmin` (change it if you've modified it in qBittorrent)
   - **Category**: `sonarr` (this should match the category set in qBittorrent)
4. Click **Test**. If you see a checkmark, it means the connection is working.
5. Click **Save**.

<div style="text-align: center">
    <img src="image/sonarr/son2.png" style="margin: 15px 10px;">
</div>

### **Indexer Jackett (Optional)**

1. In the WebUI, go to **Settings** > **Indexers**.
2. Click **+** under **Add Indexer**, then select **Torznab**.
3. Fill in the fields as follows:
   - **Name**: `Torznab` (or another name of your choice)
   - **URL**: `http://Jackett:9117/api/v2.0/indexers/YOUR_INDEXERS/results/torznab/`
   - **ApiKey**: Find the API key in the home menu at the top right.
4. Click **Test**. If you see a checkmark, it means the connection is working; if not, there is an error.
5. Click **Save**.

<div style="text-align: center">
    <img src="image/sonarr/son3.png" style="margin: 15px 10px;">
</div>

**[`^        back to top        ^`](#table-of-contents)**

---

## **Prowlarr**

### **Configure Torrent Indexers**

1. Open the WebUI and go to **Indexers** > **Add New Indexer**.
2. Select **1337x** (or another tracker of your choice).
   - You can modify the settings as per your preference, but the default values generally work well.
   - Sorting by **Seeders** can be useful for faster downloads.
3. Click **Test**. If you see a checkmark, the connection is functional; otherwise, there's an error.
4. Click **Save**.

### **Configure FlareSolverr**

1. Go to **Settings** and click **+** under **Indexer**.
2. Select **FlareSolverr** and fill in the information as follows:
   - **Name**: `FlareSolverr`
   - **Tags**: `flaresolverr`
   - **Host**: `http://flaresolverr:8191/`
3. Click **Test** to check the connection.
4. Click **Save**.

<div style="text-align: center">
    <img src="image/prowlarr/pro1.png" style="margin: 15px 10px;">
</div>

### **Configure Radarr**

1. Go to **Settings** and click **Apps**.
2. Select **Radarr** and fill in the information as follows:
   - **Sync Level**: `Full Sync`
   - **Prowlarr Server**: `http://prowlarr:9696`
   - **Radarr Server**: `http://radarr:7878`
   - **ApiKey**: Find the API key in the Radarr interface under **Settings** > **General** > **API Key**.
3. Click **Test** to check the connection.
4. Click **Save**.

<div style="text-align: center">
    <img src="image/prowlarr/pro2.png" style="margin: 15px 10px;">
</div>

### **Configure Sonarr**

1. Go to **Settings** and click **Apps**.
2. Select **Sonarr** and fill in the information as follows:
   - **Sync Level**: `Full Sync`
   - **Prowlarr Server**: `http://prowlarr:9696`
   - **Sonarr Server**: `http://sonarr:8989`
   - **ApiKey**: Find the API key in the Sonarr interface under **Settings** > **General** > **API Key**.
3. Click **Test** to check the connection.
4. Click **Save**.

<div style="text-align: center">
    <img src="image/prowlarr/pro3.png" style="margin: 15px 10px;">
</div>

**[`^        back to top        ^`](#table-of-contents)**

---

## **Jellyfin**

### **Initial Setup**

1. Open the Web UI by going to the **DOCKER** tab, click the app logo for Jellyfin, and select **WebUI**.
2. Select a preferred display language (or use the default English). Click **Next** ➝.
3. Create an administrator account, fill out the credentials as desired, and click **Next** ➝.
4. Click **Add Media Library** and fill in the following:
   - **Content type**: Movies
   - **Folders**: `/COMMON_PATH/radarr/movies`
   - Configure the rest as you see fit; the default settings are typically fine.
5. Click **OK**.
6. Click **Add Media Library** again and fill in the following:
   - **Content type**: Shows
   - **Folders**: `/COMMON_PATH/sonarr/tv`
   - Configure the rest as you see fit; the default settings are typically fine.
7. Click **OK**.
8. Click **Next** ➝.
9. Configure the **Preferred Metadata Language** (or use the default), and click **Next** ➝.
10. In **Configure Remote Access**, leave **Allow Remote Connections to this Server** checked and **Enable Automatic Port Mapping** unchecked.
11. Click **Next** ➝, then click **Finish**.
12. Sign in with your administrator account.

Once you sign in, if you already have media in your `/COMMON_PATH/*` folders, it should start appearing in Jellyfin. If not, the content will populate as the folders are filled.

### **Adding Users to Jellyfin**

If you want other users to access your Jellyfin server, you can create additional user accounts. This step is optional if you're the only user.

1. Open the left menu by clicking on the three horizontal lines (hamburger menu) in the upper left corner.
2. Select **Users** and click the **+** button on the left to add a new user.
3. Fill in the following details for the new user:
   - **Name**: `<username>`
   - **Password**: `<password>`
   - Under **Library Access**, check the boxes for the libraries (Movies, TV shows, etc.) that you want the user to have access to.
4. Click **Save** to create the user.
5. Repeat this process for all users you wish to add to the server.

**[`^        back to top        ^`](#table-of-contents)**

---

## **Jellyseerr**

### **Sign In / Configuration**

1. Open the WebUI and in the **Welcome to Jellyseerr** screen, select **Use your Jellyfin account**.
2. Fill in the information as follows:
   - **Jellyfin URL**: `http://jellyfin:8096/`
   - **Email Address**: `<your email address>`
   - **Username**: `<your Jellyfin username>`
   - **Password**: `<your Jellyfin password>`
3. Select **Sign In**.
4. Go to **Sync Libraries** under **Jellyfin Libraries**, select your Jellyfin libraries, then click **Continue**.

### **Integrating with Radarr**

1. Go to **Radarr Settings**, then click **Add Radarr Server**.
2. Fill in the information as follows:
   - **Default Server**: Check this box
   - **Server Name**: `Radarr`
   - **Name or IP Address**: `http://radarr`
   - **Port**: `7878`
   - **API Key**: Find the API key in the Radarr interface under **Settings** > **General** > **API Key**.
3. Click **Test** to check the connection.
4. Click **Save Changes**.

### **Integrating with Sonarr**

1. Go to **Sonarr Settings**, then click **Add Sonarr Server**.
2. Fill in the information as follows:
   - **Default Server**: Check this box
   - **Server Name**: `Sonarr`
   - **Name or IP Address**: `http://sonarr`
   - **Port**: `8989`
   - **API Key**: Find the API key in the Sonarr interface under **Settings** > **General** > **API Key**.
3. Click **Test** to check the connection.
4. Click **Save Changes**.

**[`^        back to top        ^`](#table-of-contents)**

---

# **Updating Applications**

To update the applications, you need to stop the running containers and remove the existing Docker images. You can use the following commands to perform these operations:

```bash
docker-compose down
docker image prune -a
```

Then, you can run `docker-compose up -d` to restart the containers with the latest versions of the applications.

**[`^        back to top        ^`](#table-of-contents)**

# **Disclaimer**

This code is provided for informational purposes only and should not be used for illegal activities. I am not responsible for the actions performed by users of this code. This code is for informational purposes, and if people wish to use it, they should consult the laws of their countries.
