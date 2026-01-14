#!/bin/bash

# ==============================================================================
# CONFIGURATION & STYLE
# ==============================================================================
REPO_BASE="https://raw.githubusercontent.com/Morzomb/All-jellyfin-media-server/Main/compose_files"

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

function show_line() { printf "${BLUE}%80s${NC}\n" | tr " " "="; }
function show_header() { echo -e "\n${BOLD}${CYAN}>>> $1${NC}"; }
function show_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
function show_success() { echo -e "${GREEN}[OK]${NC} $1"; }
function show_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
function show_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ==============================================================================
# DÉTECTION SYSTÈME & IP
# ==============================================================================
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$PRETTY_NAME
else
    OS_NAME=$(uname -s)
fi

LOCAL_IP=$(hostname -I | awk '{print $1}')
[ -z "$LOCAL_IP" ] && LOCAL_IP="127.0.0.1"

# ==============================================================================
# BANNIÈRE ISYRR
# ==============================================================================
clear
show_line
echo -e "${BOLD}${BLUE}"
echo "  _____  _______     _______  _____  "
echo " |_   _|/ ____\ \   / /  __ \|  __ \ "
echo "   | | | (___  \ \_/ /| |__) | |__) |"
echo "   | |  \___ \  \   / |  _  /|  _  / "
echo "  _| |_ ____) |  | |  | | \ \| | \ \ "
echo " |_____|_____/   |_|  |_|  \_\_|  \_\\"
echo -e "${NC}"
echo -e "${BOLD}       SOLUTION DE SERVEUR MÉDIA AUTOMATISÉE${NC}"
echo -e "           Propulsé par le projet Isyrr"
show_line
echo -e "${BOLD}Système détecté :${NC} ${CYAN}$OS_NAME${NC}"
echo -e "${BOLD}Adresse IP       :${NC} ${CYAN}$LOCAL_IP${NC}"
show_line

# ==============================================================================
# 1. GESTION DES INSTANCES EXISTANTES
# ==============================================================================
show_header "GESTION DES CONTENEURS EXISTANTS"
EXISTING=$(docker ps -a --filter "name=jellyfin|radarr|sonarr|qbittorrent|prowlarr|gluetun" -q)

if [ ! -z "$EXISTING" ]; then
    show_warn "Des instances Isyrr ont été détectées sur ce serveur."
    while true; do
        echo -e "\nQue souhaitez-vous faire ?"
        echo -e "  1) ${BOLD}Mettre à jour${NC} (Arrêt, purge images, relance)"
        echo -e "  2) ${RED}${BOLD}Supprimer complètement${NC} (Tout effacer et quitter)"
        echo -e "  3) Quitter sans modification"
        read -p "Votre choix [1-3] : " clean_choice
        case $clean_choice in
            1)
                show_info "Mise à jour lancée..."
                docker compose down --rmi all 2>/dev/null
                show_success "Anciennes images purgées."
                break ;;
            2)
                show_info "Suppression totale..."
                docker compose down -v 2>/dev/null
                show_success "Système nettoyé."
                exit 0 ;;
            3) exit 0 ;;
            *) echo -e "${RED}Choix invalide, veuillez taper 1, 2 ou 3.${NC}" ;;
        esac
    done
fi

# ==============================================================================
# 2. SÉLECTION DE L'OFFRE ISYRR (TEXTES COMPLETS + BOUCLE)
# ==============================================================================
show_header "SÉLECTION DE VOTRE OFFRE ISYRR"

echo -e "  ${GREEN}${BOLD}[1] OFFRE STANDARD${NC}"
echo -e "      ${CYAN}Description :${NC} Installation de la suite complète (Jellyfin, Arr, qBittorrent)"
echo -e "      ${CYAN}Avantage    :${NC} Sans protection VPN (recommandé pour usage local uniquement)"
echo -e "      ${CYAN}Hardware    :${NC} Pas d'accélération GPU Nvidia\n"

echo -e "  ${YELLOW}${BOLD}[2] OFFRE SÉCURISÉE${NC}"
echo -e "      ${CYAN}Description :${NC} Ajoute un tunnel VPN (Gluetun) pour qBittorrent"
echo -e "      ${CYAN}Avantage    :${NC} Choix entre NordVPN (OpenVPN) ou ProtonVPN (WireGuard)"
echo -e "      ${CYAN}Hardware    :${NC} Pas d'accélération GPU Nvidia\n"

echo -e "  ${RED}${BOLD}[3] OFFRE ULTIME${NC}"
echo -e "      ${CYAN}Description :${NC} Suite complète avec protection VPN"
echo -e "      ${CYAN}Avantage    :${NC} Active le support GPU Nvidia pour un transcodage 4K fluide\n"

while true; do
    read -p "Quel pack souhaitez-vous installer ? [1-3] : " OFFER_CHOICE
    case $OFFER_CHOICE in
        1|2|3) break ;;
        *) echo -e "${RED}Erreur : Veuillez choisir un nombre entre 1 et 3.${NC}" ;;
    esac
done

VPN_PROVIDER="none"
case $OFFER_CHOICE in
    1) TARGET_YAML="$REPO_BASE/docker-compose.yaml" ;;
    2|3)
        while true; do
            echo -e "\n${BOLD}Choisissez votre fournisseur VPN :${NC}"
            echo -e "  1) NordVPN (OpenVPN)"
            echo -e "  2) ProtonVPN (WireGuard)"
            read -p "Votre choix [1-2] : " vpn_choice
            if [ "$vpn_choice" == "1" ]; then 
                VPN_PROVIDER="nord"
                [ "$OFFER_CHOICE" == "3" ] && TARGET_YAML="$REPO_BASE/VPN-Nvidia/docker-compose-nord-vpn.yaml" || TARGET_YAML="$REPO_BASE/VPN-Only/docker-compose-nord-vpn.yaml"
                break
            elif [ "$vpn_choice" == "2" ]; then
                VPN_PROVIDER="proton"
                [ "$OFFER_CHOICE" == "3" ] && TARGET_YAML="$REPO_BASE/VPN-Nvidia/docker-compose-proton-vpn.yaml" || TARGET_YAML="$REPO_BASE/VPN-Only/docker-compose-proton-vpn.yaml"
                break
            else
                echo -e "${RED}Choix invalide.${NC}"
            fi
        done
        ;;
esac

# ==============================================================================
# 3. CONFIGURATION DES VARIABLES (.ENV)
# ==============================================================================
show_header "CONFIGURATION DES VARIABLES (.ENV)"

show_info "Paramètres de base"
echo -e "${BOLD}Chemin d'installation (Défaut: /home/$USER/data) :${NC}"
read -p "> " COMMON_PATH
COMMON_PATH=${COMMON_PATH:-/home/$USER/data}

echo -e "${BOLD}Fuseau horaire (Défaut: Europe/Paris) :${NC}"
read -p "> " USER_TZ
USER_TZ=${USER_TZ:-Europe/Paris}

curl -sL "$REPO_BASE/.env" -o .env
sed -i "s|^PUID=.*|PUID=$(id -u)|g" .env
sed -i "s|^PGID=.*|PGID=$(id -g)|g" .env
sed -i "s|^TZ=.*|TZ=$USER_TZ|g" .env
sed -i "s|^COMMON_PATH=.*|COMMON_PATH=$COMMON_PATH|g" .env

if [ "$VPN_PROVIDER" != "none" ]; then
    show_header "CONFIGURATION DU VPN ($VPN_PROVIDER)"
    while true; do
        read -p "Souhaitez-vous renseigner vos variables VPN maintenant ? (y/n) : " vpn_now
        case $vpn_now in
            [yY]*)
                if [ "$VPN_PROVIDER" == "nord" ]; then
                    sed -i "s/^# OPENVPN_USER=/OPENVPN_USER=/g" .env
                    sed -i "s/^# OPENVPN_PASSWORD=/OPENVPN_PASSWORD=/g" .env
                    sed -i "s/^# SERVER_REGIONS=/SERVER_REGIONS=/g" .env
                    read -p "NordVPN User : " v_user
                    read -p "NordVPN Pass : " v_pass
                    read -p "Région (ex: Belgium) : " v_reg
                    sed -i "s|^OPENVPN_USER=.*|OPENVPN_USER=$v_user|g" .env
                    sed -i "s|^OPENVPN_PASSWORD=.*|OPENVPN_PASSWORD=$v_pass|g" .env
                    sed -i "s|^SERVER_REGIONS=.*|SERVER_REGIONS=$v_reg|g" .env
                else
                    sed -i "s/^# ENDPOINT_IP=/ENDPOINT_IP=/g" .env
                    sed -i "s/^# WIREGUARD_ADDR=/WIREGUARD_ADDR=/g" .env
                    sed -i "s/^# ENDPOINT_PORT=/ENDPOINT_PORT=/g" .env
                    sed -i "s/^# DNS_ADDRESS=/DNS_ADDRESS=/g" .env
                    sed -i "s/^# PUBLIC_KEY=/PUBLIC_KEY=/g" .env
                    sed -i "s/^# PRIVATE_KEY=/PRIVATE_KEY=/g" .env
                    read -p "Endpoint IP : " v_eip
                    read -p "WireGuard Addr : " v_wga
                    read -p "Public Key : " v_pub
                    read -p "Private Key : " v_priv
                    sed -i "s|^ENDPOINT_IP=.*|ENDPOINT_IP=$v_eip|g" .env
                    sed -i "s|^WIREGUARD_ADDR=.*|WIREGUARD_ADDR=$v_wga|g" .env
                    sed -i "s|^PUBLIC_KEY=.*|PUBLIC_KEY=$v_pub|g" .env
                    sed -i "s|^PRIVATE_KEY=.*|PRIVATE_KEY=$v_priv|g" .env
                fi
                show_success "Variables VPN injectées."
                break ;;
            [nN]*)
                show_warn "Variables VPN laissées vides."
                break ;;
            *) echo -e "${RED}Répondez par y (oui) ou n (non).${NC}" ;;
        esac
    done
fi

# ==============================================================================
# 4. DÉPLOIEMENT FINAL (TEXTES ET URLs COMPLETS)
# ==============================================================================
show_header "DÉPLOIEMENT FINAL"
mkdir -p "$COMMON_PATH/configs/"{qbittorrent,prowlarr,jackett,sonarr,radarr,jellyfin,jellyseerr,gluetun}
mkdir -p "$COMMON_PATH/qbittorrent/downloads"
mkdir -p "$COMMON_PATH/sonarr/tv"
mkdir -p "$COMMON_PATH/radarr/movies"

show_info "Téléchargement du pack Isyrr..."
curl -sL "$TARGET_YAML" -o docker-compose.yml

show_line
echo -e "${GREEN}${BOLD}L'INSTALLATION DE ISYRR EST PRÊTE !${NC}"
echo -e "Adresse IP locale : ${CYAN}${LOCAL_IP}${NC}"
show_line

while true; do
    read -p "Démarrer Isyrr maintenant ? (y/n) : " final
    case $final in
        [yY]*)
            show_info "Lancement des conteneurs Isyrr..."
            show_line
            docker compose up -d

            if [ "$OFFER_CHOICE" == "3" ]; then
                echo ""
                show_line
                show_warn "RAPPEL ACCÉLÉRATION NVIDIA"
                echo -e "Si vous voyez une erreur 'nvidia' ci-dessus, assurez-vous d'avoir :"
                echo -e "1. Les drivers Nvidia installés sur l'hôte."
                echo -e "2. Le 'Nvidia Container Toolkit' configuré."
                echo -e "\nDocumentation d'aide :"
                echo -e "${BOLD}${CYAN}👉 https://github.com/Morzomb/All-jellyfin-media-server#nvidia-setup${NC}"
                show_line
                echo ""
            fi

            show_success "Processus terminé !"
            show_header "VOS SERVICES ISYRR SONT EN LIGNE"
            echo -e "  - Jellyfin    : http://${LOCAL_IP}:8096"
            echo -e "  - Jellyseerr  : http://${LOCAL_IP}:5055"
            echo -e "  - Sonarr      : http://${LOCAL_IP}:8989"
            echo -e "  - Radarr      : http://${LOCAL_IP}:7878"
            echo -e "  - Prowlarr    : http://${LOCAL_IP}:9696"
            echo -e "  - Jackett     : http://${LOCAL_IP}:9117"
            echo -e "  - qBittorrent : http://${LOCAL_IP}:8080"
            show_line
            break ;;
        [nN]*)
            show_info "Installation terminée. Lancez 'docker compose up -d' plus tard."
            break ;;
        *) echo -e "${RED}Veuillez répondre par y ou n.${NC}" ;;
    esac
done