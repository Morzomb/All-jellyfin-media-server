#!/bin/bash

# ==============================================================================
# ISYRR - SOLUTION DE SERVEUR MÉDIA AUTOMATISÉE
# Version Finale avec Interface Améliorée
# ==============================================================================

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO="https://raw.githubusercontent.com/Morzomb/All-jellyfin-media-server/Lab"
REPO_BASE="$REPO/auto"
COMPOSE_DL_DIR="$DIR/compose_downloads"
ENV_FILE="$DIR/.env"
CONFIG_FILE="$DIR/.isyrr_config"

# Couleurs ANSI
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Variables par défaut pour Harvest
J_USER="odin"
J_PASS="odin"
BASE_URL="http://localhost:8096"
APP_NAME="isyrr_script"

# ==============================================================================
# FONCTIONS D'AFFICHAGE AMÉLIORÉES
# ==============================================================================

function separator_full() {
    printf "${BLUE}%.0s${NC}" {1..80}
    printf "\n"
}

function separator_dash() {
    printf "${CYAN}%.0s-${NC}" {1..40}
    printf "\n"
}

function box_header() {
    local text="$1"
    # calculer la largeur du terminal si possible
    local cols=80
    if command -v tput >/dev/null 2>&1; then
        cols=$(tput cols 2>/dev/null || echo 80)
    fi
    cols=${cols:-80}

    # padding autour du texte et bornes
    local pad=4
    local text_len=${#text}
    local inner=$((text_len + pad * 2))
    local max_inner=$((cols - 4))
    if [ $inner -gt $max_inner ]; then
        inner=$max_inner
    fi
    if [ $inner -lt 20 ]; then
        inner=20
    fi

    local left=$(( (inner - text_len) / 2 ))
    local right=$(( inner - text_len - left ))

    # construire bordures
    local top="+"
    top+=$(printf '%0.s-' $(seq 1 $inner))
    top+="+"

    echo ""
    echo -e "${BOLD}${CYAN}$top${NC}"
    printf -v middle "|%*s%s%*s|" "$left" "" "$text" "$right" ""
    echo -e "${BOLD}${CYAN}$middle${NC}"
    echo -e "${BOLD}${CYAN}$top${NC}"
}

function box_section() {
    local text="$1"
    echo -e ""
    echo -e "${BOLD}${MAGENTA}[*] $text${NC}"
    separator_dash
}

function show_info() {
    echo -e "${BLUE}[*]${NC} $1"
}

function show_success() {
    echo -e "${GREEN}[+]${NC} $1"
}

function show_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

function show_error() {
    echo -e "${RED}[-]${NC} $1"
    exit 1
}

function check_status() {
    if [ $? -eq 0 ]; then
        echo -e "    ${GREEN}[OK]${NC} $1"
    else
        echo -e "    ${RED}[FAIL]${NC} $1"
    fi
}

function show_banner() {
    clear
    separator_full
    echo -e "${BOLD}${CYAN}"
    echo "   _____  _______     _______  _____  "
    echo "  |_   _|/ ____\ \   / /  __ \|  __ \ "
    echo "    | | | (___  \ \_/ /| |__) | |__) |"
    echo "    | |  \___ \  \   / |  _  /|  _  / "
    echo "   _| |_ ____) |  | |  | | \ \| | \ \ "
    echo "  |_____|_____/   |_|  |_|  \_\_|  \_\ "
    echo -e "${NC}"
    echo -e "${BOLD}${CYAN}       SOLUTION DE SERVEUR MEDIA AUTOMATISEE${NC}"
    echo -e "${BOLD}${CYAN}          Jellyfin + Arr Suite Solution${NC}"
    separator_full
    echo ""
}

# Fonction de reconstruction dynamique de la commande Docker
function generate_docker_command() {
    mkdir -p "$COMPOSE_DL_DIR"
    curl -sL "$REPO_BASE/docker-compose.yml" -o "$COMPOSE_DL_DIR/docker-compose.yml"
    CMD_ARGS="-p isyrr -f $COMPOSE_DL_DIR/docker-compose.yml"

    if [ "$PACK_TYPE" == "1" ]; then
        curl -sL "$REPO_BASE/templates/vpn/qbit-no-vpn.yml" -o "$COMPOSE_DL_DIR/qbit-no-vpn.yml"
        CMD_ARGS="$CMD_ARGS -f $COMPOSE_DL_DIR/qbit-no-vpn.yml"
    elif [ "$PACK_TYPE" == "2" ] || [ "$PACK_TYPE" == "3" ]; then
        if [ "$VPN_PROVIDER" == "proton" ]; then
            curl -sL "$REPO_BASE/templates/vpn/proton-vpn.yml" -o "$COMPOSE_DL_DIR/proton-vpn.yml"
            CMD_ARGS="$CMD_ARGS -f $COMPOSE_DL_DIR/proton-vpn.yml"
        elif [ "$VPN_PROVIDER" == "nord" ]; then
            curl -sL "$REPO_BASE/templates/vpn/nord-vpn.yml" -o "$COMPOSE_DL_DIR/nord-vpn.yml"
            CMD_ARGS="$CMD_ARGS -f $COMPOSE_DL_DIR/nord-vpn.yml"
        fi
    fi

    if [ "$PACK_TYPE" == "3" ]; then
        curl -sL "$REPO_BASE/templates/nvidia.yml" -o "$COMPOSE_DL_DIR/nvidia.yml"
        CMD_ARGS="$CMD_ARGS -f $COMPOSE_DL_DIR/nvidia.yml"
    fi

    if [ "$INSTALL_HOMEPAGE" == "true" ]; then
        curl -sL "$REPO_BASE/templates/services/homepage.yml" -o "$COMPOSE_DL_DIR/homepage.yml"
        CMD_ARGS="$CMD_ARGS -f $COMPOSE_DL_DIR/homepage.yml"
    fi
    if [ "$INSTALL_BAZARR" == "true" ]; then
        curl -sL "$REPO_BASE/templates/services/bazarr.yml" -o "$COMPOSE_DL_DIR/bazarr.yml"
        CMD_ARGS="$CMD_ARGS -f $COMPOSE_DL_DIR/bazarr.yml"
    fi
}

# ==============================================================================
# DÉTECTION SYSTÈME
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
# AFFICHAGE PRINCIPAL
# ==============================================================================

show_banner
echo -e "${CYAN}Systeme:${NC} $OS_NAME"
echo -e "${CYAN}IP:${NC} $LOCAL_IP"
echo ""

# ==============================================================================
# 1. GESTION INTELLIGENTE (STATEFUL)
# ==============================================================================

box_header "VERIFICATION DE L'INSTALLATION"

SKIP_ENV_SETUP=false

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    show_success "Configuration existante deteclee"
    echo ""
    echo -e "${CYAN}Votre installation precedente:${NC}"
    echo -e "  Pack type: ${YELLOW}$PACK_TYPE${NC}"
    echo -e "  VPN: ${YELLOW}$VPN_PROVIDER${NC}"
    echo -e "  Homepage: ${YELLOW}$INSTALL_HOMEPAGE${NC}"
    echo -e "  Bazarr: ${YELLOW}$INSTALL_BAZARR${NC}"
    echo ""
    
    generate_docker_command
    SAVED_CMD="$CMD_ARGS"

    while true; do
        echo -e "${BOLD}Que souhaitez-vous faire ?${NC}"
        echo ""
        echo -e "  ${CYAN}1 Mettre a jour${NC}"
        echo -e "     Redemarrage des services avec les dernieres images"
        echo -e "     Conserve votre configuration actuelle"
        echo ""
        echo -e "  ${RED}2 Desinstaller${NC}"
        echo -e "     Arret complet et suppression de tous les services"
        echo -e "     Option pour supprimer aussi les donnees"
        echo ""
        echo -e "  ${GREEN}3 Modifier / Ajouter des services${NC}"
        echo -e "     Relance de la configuration complete"
        echo -e "     Permet de changer les packs ou services"
        echo ""
        echo -e "  ${YELLOW}4 Quitter${NC}"
        echo ""
        read -p "Votre choix [1-4]: " action_choice
        
        case $action_choice in
            1)
                show_info "Mise a jour en cours..."
                show_info "Telechargement des dernieres images..."
                docker compose --env-file "$ENV_FILE" $SAVED_CMD pull
                show_info "Redemarrage des services..."
                docker compose --env-file "$ENV_FILE" $SAVED_CMD up -d --remove-orphans
                show_success "Mise a jour completee"
                exit 0 ;;
            2)
                show_warn "ATTENTION: Cette action est irreversible"
                read -p "Confirmez la desinstallation ? (y/n): " confirm_del
                if [[ "$confirm_del" =~ ^[yY] ]]; then
                    show_info "Arrêt des services..."
                    docker compose --env-file "$ENV_FILE" $SAVED_CMD down
                    show_info "Suppression des fichiers de configuration..."
                    rm "$CONFIG_FILE"
                    sudo rm -Rf data/ compose_downloads/ .env
                    
                    read -p "Supprimer aussi les volumes (donnees persistantes) ? (y/n): " del_vol
                    if [[ "$del_vol" =~ ^[yY] ]]; then
                       show_info "Suppression des volumes Docker..."
                       docker volume prune -f
                    fi
                    show_success "Desinstallation completee"
                else
                    show_warn "Desinstallation annulee"
                fi
                exit 0 ;;
            3)
                show_info "Mode modification activé"
                show_info "Arrêt temporaire des services..."
                docker compose --env-file "$ENV_FILE" $SAVED_CMD down
                show_success "Services arrêtes"
                SKIP_ENV_SETUP=true
                break ;;
            4) 
                show_info "Sortie du script"
                exit 0 ;;
            *) show_error "Choix invalide" ;;
        esac
    done
fi

# ==============================================================================
# 2. SÉLECTION DE L'ARCHITECTURE
# ==============================================================================

box_header "SELECTION DE LA PILE MEDIA"

echo -e "${GREEN}[1] OFFRE STANDARD${NC}"
echo -e "    Installation complete sans VPN"
echo -e "    Services: Jellyfin, Radarr, Sonarr, Prowlarr, Jackett, qBittorrent"
echo -e "    Ideal pour usage local uniquement"
echo ""

echo -e "${YELLOW}[2] OFFRE SECURISEE${NC}"
echo -e "    Tous les services + tunnel VPN pour qBittorrent"
echo -e "    Choix: NordVPN (OpenVPN) ou ProtonVPN (WireGuard)"
echo -e "    Protection de votre connexion torrent"
echo ""

echo -e "${RED}[3] OFFRE ULTIME${NC}"
echo -e "    Pack Securise + Support GPU Nvidia"
echo -e "    Transcodage video 4K optimise"
echo -e "    Pour serveurs haute performance"
echo ""

while true; do
    read -p "Choisissez votre offre [1-3]: " PACK_TYPE
    case $PACK_TYPE in
        1|2|3) break ;;
        *) show_error "Erreur: entrez 1, 2 ou 3" ;;
    esac
done

VPN_PROVIDER="none"
INSTALL_VPN=false

if [ "$PACK_TYPE" == "1" ]; then
    INSTALL_VPN=false
    show_success "Pack Standard selectionne"
elif [ "$PACK_TYPE" == "2" ] || [ "$PACK_TYPE" == "3" ]; then
    INSTALL_VPN=true
    while true; do
        echo ""
        echo -e "${BOLD}Choisissez votre fournisseur VPN:${NC}"
        echo ""
        echo -e "  ${CYAN}1${NC} NordVPN (OpenVPN)"
        echo -e "     Compatible avec la plupart des routeurs"
        echo -e "     Necessite: User + Password"
        echo ""
        echo -e "  ${CYAN}2${NC} ProtonVPN (WireGuard)"
        echo -e "     Plus rapide et moderne"
        echo -e "     Necessite: Endpoint IP + Public/Private Keys"
        echo ""
        read -p "Votre choix [1-2]: " vpn_choice
        
        if [ "$vpn_choice" == "1" ]; then 
            VPN_PROVIDER="nord"
            show_success "NordVPN selectionne"
            break
        elif [ "$vpn_choice" == "2" ]; then
            VPN_PROVIDER="proton"
            show_success "ProtonVPN selectionne"
            break
        else
            show_error "Choix invalide"
        fi
    done
fi

# ==============================================================================
# 2.5 SERVICES ADDITIONNELS
# ==============================================================================

box_section "Services Additionnels"

echo -e "${BOLD}Homepage Dashboard:${NC}"
echo -e "  Interface web unifiee pour tous vos services"
echo -e "  Widgets, marque-pages et informations en temps reel"
echo ""
while true; do
    read -p "Installer Homepage Dashboard ? (y/n): " hp_choice
    case $hp_choice in
        [yY]*) INSTALL_HOMEPAGE=true; show_success "Homepage activé"; break ;;
        [nN]*) INSTALL_HOMEPAGE=false; show_warn "Homepage desactivé"; break ;;
        *) show_error "Repondez par y ou n" ;;
    esac
done

echo ""
echo -e "${BOLD}Bazarr - Gestion des sous-titres:${NC}"
echo -e "  Telecharge automatiquement les sous-titres"
echo -e "  Integration avec Sonarr et Radarr"
echo -e "  Support multi-langues"
echo ""
while true; do
    read -p "Installer Bazarr (Sous-titres) ? (y/n): " baz_choice
    case $baz_choice in
        [yY]*) INSTALL_BAZARR=true; show_success "Bazarr activé"; break ;;
        [nN]*) INSTALL_BAZARR=false; show_warn "Bazarr desactivé"; break ;;
        *) show_error "Repondez par y ou n" ;;
    esac
done

# ==============================================================================
# 3. CONFIGURATION DES VARIABLES
# ==============================================================================

if [ "$SKIP_ENV_SETUP" = true ] && [ -f "$ENV_FILE" ]; then
    box_section "Variables d'Environnement"
    show_info "Mise a jour de l'adresse IP..."
    show_info "Fichier .env conserve (modification)"
    sed -i "s|^SERVER_IP=.*|SERVER_IP=$LOCAL_IP|g" "$ENV_FILE"
    show_success "IP serveur mise a jour: $LOCAL_IP"

    if [ "$INSTALL_VPN" == "true" ]; then
        FORCE_VPN_CONFIG=true 
    fi
else
    FORCE_VPN_CONFIG=true
    box_section "Configuration des Variables d'Environnement"

    show_info "Parametres obligatoires"
    echo ""
    echo -e "${BOLD}Chemin d'installation:${NC}"
    echo -e "  Repertoire ou seront stockes tous les services et donnees"
    read -p "Chemin [/home/$USER/data]: " COMMON_PATH
    COMMON_PATH=${COMMON_PATH:-/home/$USER/data}
    show_success "Chemin: $COMMON_PATH"

    echo ""
    echo -e "${BOLD}Fuseau horaire:${NC}"
    echo -e "  Utilise par Jellyfin et les services *Arr"
    echo -e "  Exemples: Europe/Paris, Europe/London, America/New_York"
    read -p "Timezone [Europe/Paris]: " USER_TZ
    USER_TZ=${USER_TZ:-Europe/Paris}
    show_success "Timezone: $USER_TZ"

    show_info "Telechargement de la configuration de base..."
    curl -sL "$REPO_BASE/.env.example" -o .env

    show_info "Injection des variables..."
    sed -i "s|^PUID=.*|PUID=$(id -u)|g" .env
    sed -i "s|^PGID=.*|PGID=$(id -g)|g" .env
    sed -i "s|^TZ=.*|TZ=$USER_TZ|g" .env
    sed -i "s|^COMMON_PATH=.*|COMMON_PATH=$COMMON_PATH|g" .env
    sed -i "s|^SERVER_IP=.*|SERVER_IP=$LOCAL_IP|g" .env
    show_success "Configuration injectee"
fi

# Configuration VPN
if [ "$INSTALL_VPN" == "true" ] && [ "$FORCE_VPN_CONFIG" = true ]; then
    box_section "Configuration VPN ($VPN_PROVIDER)"
    
    echo -e "${BOLD}Configuration des identifiants:${NC}"
    echo -e "  Ces informations doivent etre recuperees depuis votre compte VPN"
    echo ""
    
    read -p "Saisir identifiants VPN maintenant ? (y/n): " vpn_now
    case $vpn_now in
        [yY]*)
            if [ "$VPN_PROVIDER" == "nord" ]; then
                show_info "NordVPN - Credentials (Service Credentials, pas login)"
                sed -i "s/^# OPENVPN_USER=/OPENVPN_USER=/g" .env
                sed -i "s/^# OPENVPN_PASSWORD=/OPENVPN_PASSWORD=/g" .env
                sed -i "s/^# SERVER_REGIONS=/SERVER_REGIONS=/g" .env
                
                read -p "NordVPN User (Service Credential): " v_user
                read -p "NordVPN Password: " v_pass
                read -p "Region (ex: Belgium, France, Germany): " v_reg
                
                sed -i "s|^OPENVPN_USER=.*|OPENVPN_USER=$v_user|g" .env
                sed -i "s|^OPENVPN_PASSWORD=.*|OPENVPN_PASSWORD=$v_pass|g" .env
                sed -i "s|^SERVER_REGIONS=.*|SERVER_REGIONS=$v_reg|g" .env
            
            elif [ "$VPN_PROVIDER" == "proton" ]; then
                show_info "ProtonVPN - WireGuard Configuration"
                show_info "Vous pouvez obtenir ces informations depuis votre compte Proton"
                sed -i "s/^# ENDPOINT_IP=/ENDPOINT_IP=/g" .env
                sed -i "s/^# PUBLIC_KEY=/PUBLIC_KEY=/g" .env
                sed -i "s/^# PRIVATE_KEY=/PRIVATE_KEY=/g" .env
                
                read -p "Endpoint IP (ex: 185.x.x.x): " v_eip
                read -p "Public Key: " v_pub
                read -p "Private Key: " v_priv
                
                sed -i "s|^ENDPOINT_IP=.*|ENDPOINT_IP=$v_eip|g" .env
                sed -i "s|^PUBLIC_KEY=.*|PUBLIC_KEY=$v_pub|g" .env
                sed -i "s|^PRIVATE_KEY=.*|PRIVATE_KEY=$v_priv|g" .env
            fi
            show_success "Identifiants VPN configures"
            ;;
        [nN]*)
            show_warn "Configuration VPN omise"
            show_info "Vous devrez editer le fichier .env manuellement avant le demarrage"
            show_info "Fichier: $DIR/.env"
            ;;
    esac
fi

# Configuration Homepage
if [ "$INSTALL_HOMEPAGE" == "true" ]; then
    box_section "Configuration Homepage"
    echo -e "${BOLD}Parametres Homepage:${NC}"
    echo -e "  Interface accessible depuis votre reseau"
    echo -e "  Adresse IP pour les widgets et acces direct"
    echo ""
    sed -i "s/^#SERVER_IP=.*/SERVER_IP=$LOCAL_IP/g" .env
    show_success "IP serveur configuree: $LOCAL_IP"
    show_info "Vous pourrez acceder a Homepage a l'URL:"
    echo -e "  ${CYAN}http://${LOCAL_IP}:3000${NC}"
fi

# ==============================================================================
# 3.5 DÉPLOIEMENT DES PRÉCONFIGURATIONS
# ==============================================================================

if [ "$INSTALL_HOMEPAGE" == "true" ]; then
    box_section "Preconfigurations"
    
    TARGET_DATA=$(grep COMMON_PATH "$ENV_FILE" | cut -d '=' -f2)
    [ -z "$TARGET_DATA" ] && TARGET_DATA="$COMMON_PATH"
    
    DEST_HOMEPAGE="$TARGET_DATA/configs/homepage"
    HOMEPAGE_CONFIG_BASE="$REPO_BASE/../config/homepage"

    show_info "Telechargement de la configuration Homepage..."
    
    mkdir -p "$DEST_HOMEPAGE/config"
    mkdir -p "$DEST_HOMEPAGE/images"
    
    curl -sL "$HOMEPAGE_CONFIG_BASE/config/bookmarks.yaml" -o "$DEST_HOMEPAGE/config/bookmarks.yaml" 2>/dev/null
    curl -sL "$HOMEPAGE_CONFIG_BASE/config/services.yaml" -o "$DEST_HOMEPAGE/config/services.yaml" 2>/dev/null
    curl -sL "$HOMEPAGE_CONFIG_BASE/config/widgets.yaml" -o "$DEST_HOMEPAGE/config/widgets.yaml" 2>/dev/null
    
    show_success "Homepage deploye dans $DEST_HOMEPAGE"
fi

# ==============================================================================
# 4. SAUVEGARDE & DÉPLOIEMENT
# ==============================================================================

box_section "Finalisation"

cat > "$CONFIG_FILE" <<EOF
PACK_TYPE="$PACK_TYPE"
VPN_PROVIDER="$VPN_PROVIDER"
INSTALL_HOMEPAGE="$INSTALL_HOMEPAGE"
INSTALL_BAZARR="$INSTALL_BAZARR"
EOF
show_success "Configuration sauvegardee"

generate_docker_command

CURRENT_PATH=$(grep COMMON_PATH "$ENV_FILE" | cut -d '=' -f2)
[ -z "$CURRENT_PATH" ] && CURRENT_PATH="/home/$USER/data"

mkdir -p "$CURRENT_PATH/configs/"{qbittorrent,prowlarr,jackett,sonarr,radarr,jellyfin,jellyseerr,gluetun}
mkdir -p "$CURRENT_PATH/qbittorrent/downloads"
mkdir -p "$CURRENT_PATH/sonarr/tv"
mkdir -p "$CURRENT_PATH/radarr/movies"
[ "$INSTALL_HOMEPAGE" == "true" ] && mkdir -p "$CURRENT_PATH/configs/homepage"
[ "$INSTALL_BAZARR" == "true" ] && mkdir -p "$CURRENT_PATH/configs/bazarr"

show_success "Dossiers crees"

separator_full
echo -e "${BOLD}${GREEN}  PRET A DEMARRER${NC}"
separator_full

while true; do
    read -p "Lancer les services ? (y/n): " final
    case $final in
        [yY]*)
            show_info "Application de la configuration..."
            separator_full
            
            docker compose --env-file "$ENV_FILE" $CMD_ARGS up -d --remove-orphans
            
            if [ "$PACK_TYPE" == "3" ]; then
                separator_full
                show_warn "RAPPEL ACCELERATION NVIDIA"
                echo "Verifiez que vous avez:"
                echo "  - Les drivers Nvidia installes"
                echo "  - Nvidia Container Toolkit configure"
                separator_full
            fi

            show_success "Installation completee"
            separator_full
            break ;;
        [nN]*)
            show_info "Annule. Pour lancer plus tard:"
            echo -e "${CYAN}docker compose --env-file .env $CMD_ARGS up -d${NC}"
            separator_full
            break ;;
        *) show_error "Repondez par y ou n" ;;
    esac
done

# ==============================================================================
# 5. POST-INSTALLATION & AUTO-CONFIGURATION
# ==============================================================================

read -p "Configurer automatiquement maintenant ? (y/n): " harvest_choice
case $harvest_choice in
    [yY]*) DO_HARVEST=true ;;
    *) DO_HARVEST=false ;;
esac

if [ "$DO_HARVEST" == "true" ]; then
    separator_full
    box_header "CONFIGURATION AUTOMATIQUE"
    show_info "Module de moisson API integre..."
    show_info "Attente de l'initialisation (120s)..."
    echo ""
    
    for i in {1..120}; do
        echo -ne "${CYAN}Initialisation: [$i/120s]${NC}\r"
        sleep 1
    done
    echo -e "\n"
    separator_full

    [ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
    [ -f "$ENV_FILE" ] && source "$ENV_FILE"
    [ ! -f "$CONFIG_FILE" ] && touch "$CONFIG_FILE"

    DATA_PATH=${COMMON_PATH:-/opt/isyrr}
    HOMEPAGE_SERVICES="$DATA_PATH/configs/homepage/config/services.yaml"

    check_http() {
        if [[ "$1" == "200" || "$1" == "204" ]]; then 
            echo -e "${GREEN}[OK]${NC}"
        else 
            echo -e "${RED}[ERREUR $1]${NC}"
            exit 1
        fi
    }

    moissonner() {
        local name=$1; local path=$2; local type=$3
        echo -e "\n${CYAN}[*] Analyse: $name${NC}"
        if [ -f "$path" ]; then
            if [ "$type" == "xml" ]; then
                KEY=$(grep -oP '(?<=<ApiKey>).*?(?=</ApiKey>)' "$path" 2>/dev/null)
            else
                KEY=$(grep -oP '"(apiKey|APIKey)":\s*"\K[^"]+' "$path" 2>/dev/null)
            fi
            if [ -n "$KEY" ]; then
                echo -e "    ${GREEN}[+] Clé trouvée${NC}: ${YELLOW}${KEY:0:8}...${NC}"
                VAR_NAME="$(echo $name | tr '[:lower:]' '[:upper:]')_KEY"
                sed -i "/$VAR_NAME=/d" "$CONFIG_FILE"
                echo "$VAR_NAME=\"$KEY\"" >> "$CONFIG_FILE"
                export "$VAR_NAME=$KEY"
                if [ "$INSTALL_HOMEPAGE" == "true" ] && [ -f "$HOMEPAGE_SERVICES" ]; then
                    sed -i "/$name:/,/key:/ s/key: .*/key: $KEY/" "$HOMEPAGE_SERVICES"
                fi
            fi
        else 
            echo -e "    ${RED}[-] Fichier absent${NC}: $path"
        fi
    }

    configure_jelly() {
        local NAME=$1; local TYPE=$2; local PATH_FOLDER=$3
        EXIST_LIB=$(curl -s -H "X-Emby-Token: $JELLYFIN_KEY" "$BASE_URL/Library/VirtualFolders")
        if [[ "$EXIST_LIB" == *"$NAME"* ]]; then 
            echo -e "    ${YELLOW}[*] Bibliotheque '$NAME'${NC}: deja creee"
        else 
            echo -ne "    Creation de '$NAME'... "
            curl -s -X POST "$BASE_URL/Library/VirtualFolders?name=$NAME&collectionType=$TYPE&refreshLibrary=false" -H "X-Emby-Token: $JELLYFIN_KEY" > /dev/null
            echo -e "${GREEN}[OK]${NC}"
        fi

        if [[ "$EXIST_LIB" == *"$PATH_FOLDER"* ]]; then 
            echo -e "    ${YELLOW}[*] Chemin${NC}: deja lie"
        else 
            echo -ne "    Liaison du chemin... "
            curl -s -X POST "$BASE_URL/Library/VirtualFolders/Paths?refreshLibrary=true" -H "X-Emby-Token: $JELLYFIN_KEY" -H "Content-Type: application/json" -d "{\"Name\":\"$NAME\",\"PathInfo\":{\"Path\":\"$PATH_FOLDER\"}}" > /dev/null
            echo -e "${GREEN}[OK]${NC}"
        fi
    }

    box_section "Initialisation et Moisson"

    echo -e "\n${CYAN}[*] Jellyfin${NC}"
    WIZARD_DONE=$(grep "WIZARD_DONE=" "$CONFIG_FILE" | cut -d '=' -f2 | tr -d '"')

    if [ "$WIZARD_DONE" == "true" ]; then
        echo -e "    ${YELLOW}[*]${NC} Wizard deja complete"
    else
        show_info "Verification du conteneur Jellyfin et acces HTTP..."
        READY=false
        # attente maximum 10s en checks de 2s
        for i in {1..5}; do
            # verifier via docker si present
            if command -v docker >/dev/null 2>&1; then
                STATUS=$(docker ps --filter "name=jellyfin" --format '{{.Status}}' 2>/dev/null | head -n1)
                if [[ "$STATUS" == *"Up"* ]]; then
                    READY=true
                    break
                fi
            fi

            # verifier HTTP local
            CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$BASE_URL" || echo "000")
            if [[ "$CODE" =~ ^2|^3 ]]; then
                READY=true
                break
            fi

            [ $i -lt 5 ] && sleep 2
        done

        if [ "$READY" != true ]; then
            show_warn "Jellyfin indisponible; le Wizard sera ignore pour l'instant"
        else
            echo -e "    ${CYAN}[*]${NC} Lancement du Wizard..."
            read -p "    Nom du serveur [Isyrr]: " SERVER_NAME
            SERVER_NAME=${SERVER_NAME:-Isyrr}
            
            read -p "    Admin [$J_USER]: " J_USER_IN
            J_USER=${J_USER_IN:-$J_USER}
            read -s -p "    Mot de passe: " J_PASS_IN
            echo -e ""
            J_PASS=${J_PASS_IN:-$J_PASS}

            echo -n "    [1/6] Config... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/Configuration" -H "Content-Type: application/json" -d "{\"ServerName\":\"$SERVER_NAME\",\"UICulture\":\"fr-FR\",\"MetadataCountryCode\":\"FR\"}")
            check_http "$CODE"

            echo -n "    [2/6] Initialisation... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$BASE_URL/Startup/User")
            check_http "$CODE"

            echo -n "    [3/6] Admin... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/User" -H "Content-Type: application/json" -d "{\"Name\":\"$J_USER\",\"Password\":\"$J_PASS\"}")
            check_http "$CODE"

            echo -n "    [4/6] Fixation... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/Configuration" -H "Content-Type: application/json" -d "{\"UICulture\":\"fr-FR\",\"MetadataCountryCode\":\"FR\"}")
            check_http "$CODE"

            echo -n "    [5/6] Acces distant... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/RemoteAccess" -H "Content-Type: application/json" -d '{"EnableRemoteAccess":true,"EnableAutomaticPortMapping":false}')
            check_http "$CODE"

            echo -n "    [6/6] Finalisation... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/Complete")
            check_http "$CODE"

            sed -i "/WIZARD_DONE=/d" "$CONFIG_FILE"
            echo "WIZARD_DONE=\"true\"" >> "$CONFIG_FILE"
        fi
    fi

    echo -e "\n${CYAN}[*] Jellyfin API Key${NC}"
    AUTH_DATA="{\"Username\": \"$J_USER\", \"Pw\": \"$J_PASS\"}"
    AUTH_HEADER="MediaBrowser Client=\"Isyrr-Automator\", Device=\"Server\", DeviceId=\"script-$(date +%s)\", Version=\"1.0.0\""
    RESPONSE_AUTH=$(curl -s -X POST "$BASE_URL/Users/AuthenticateByName" -H "Content-Type: application/json" -H "X-Emby-Authorization: $AUTH_HEADER" -d "$AUTH_DATA")
    SESSION_TOKEN=$(echo "$RESPONSE_AUTH" | grep -oP '"AccessToken":"\K[^" ]+')

    if [ ! -z "$SESSION_TOKEN" ]; then
        LIST_KEYS=$(curl -s -X GET "$BASE_URL/Auth/Keys" -H "X-Emby-Token: $SESSION_TOKEN")
        FINAL_KEY=$(echo "$LIST_KEYS" | sed 's/},{/\n/g' | grep "$APP_NAME" | grep -oP '"AccessToken":"\K[^"]+' | head -n 1)
        if [ -z "$FINAL_KEY" ]; then
            show_info "Creation d'une nouvelle clé..."
            curl -s -o /dev/null -X POST "$BASE_URL/Auth/Keys?app=$APP_NAME" -H "X-Emby-Token: $SESSION_TOKEN"
            LIST_KEYS=$(curl -s -X GET "$BASE_URL/Auth/Keys" -H "X-Emby-Token: $SESSION_TOKEN")
            FINAL_KEY=$(echo "$LIST_KEYS" | sed 's/},{/\n/g' | grep "$APP_NAME" | grep -oP '"AccessToken":"\K[^"]+' | head -n 1)
        fi
        if [ ! -z "$FINAL_KEY" ]; then
            echo -e "    ${GREEN}[+]${NC} Clé API obtenue"
            sed -i "/JELLYFIN_KEY=/d" "$CONFIG_FILE"
            echo "JELLYFIN_KEY=\"$FINAL_KEY\"" >> "$CONFIG_FILE"
            export JELLYFIN_KEY="$FINAL_KEY"
            if [ "$INSTALL_HOMEPAGE" == "true" ] && [ -f "$HOMEPAGE_SERVICES" ]; then
                sed -i "/Jellyfin:/,/key:/ s|key: .*|key: $FINAL_KEY|" "$HOMEPAGE_SERVICES"
            fi
        fi
    else
        echo -e "    ${RED}[-]${NC} Authentification echouee"
    fi

    echo -e "\n${CYAN}[*] Moisson des Services${NC}"
    QBIT_PASS=$(docker logs qbittorrent 2>&1 | grep "temporary password" | awk '{print $NF}' | tail -n 1)
    if [ -z "$QBIT_PASS" ]; then
        echo -e "    ${YELLOW}[!]${NC} Mot de passe qBit introuvable"
    else
        echo -e "    ${GREEN}[+]${NC} qBit password found"
        sed -i "/QBIT_TEMP_PASS=/d" "$CONFIG_FILE"
        echo "QBIT_TEMP_PASS=\"$QBIT_PASS\"" >> "$CONFIG_FILE"
        export QBIT_TEMP_PASS="$QBIT_PASS"
        
        if [[ "$PACK_TYPE" == "2" || "$PACK_TYPE" == "3" ]]; then
            QBIT_URL_HOMEPAGE="http://gluetun:8080"
        else
            QBIT_URL_HOMEPAGE="http://qbittorrent:8080"
        fi
        if [ "$INSTALL_HOMEPAGE" == "true" ] && [ -f "$HOMEPAGE_SERVICES" ]; then
            sed -i "/qBittorrent:/,/url:/ s|url: .*|url: $QBIT_URL_HOMEPAGE/|" "$HOMEPAGE_SERVICES"
            sed -i "/qBittorrent:/,/password:/ s/password: .*/password: $QBIT_PASS/" "$HOMEPAGE_SERVICES"
        fi
    fi

    moissonner "Radarr" "$DATA_PATH/configs/radarr/config.xml" "xml"
    moissonner "Sonarr" "$DATA_PATH/configs/sonarr/config.xml" "xml"
    moissonner "Prowlarr" "$DATA_PATH/configs/prowlarr/config.xml" "xml"
    moissonner "Jellyseerr" "$DATA_PATH/configs/jellyseerr/settings.json" "json"
    moissonner "Jackett" "$DATA_PATH/configs/jackett/Jackett/ServerConfig.json" "json"

    box_section "Configuration des Services"

    sudo mkdir -p "$DATA_PATH/qbittorrent/downloads/radarr"
    sudo mkdir -p "$DATA_PATH/qbittorrent/downloads/sonarr"
    sudo chmod -R 777 "$DATA_PATH/qbittorrent/downloads/"

    COOKIE=$(curl -s -i --max-time 5 -X POST "http://localhost:8080/api/v2/auth/login" -d "username=admin&password=$QBIT_TEMP_PASS")
    SID=$(echo "$COOKIE" | grep -oP 'SID=\K[^;]+')

    if [ -z "$SID" ]; then 
        echo -e "${RED}[-]${NC} Impossible de se connecter a qBit"
        if [[ "$PACK_TYPE" == "2" || "$PACK_TYPE" == "3" ]]; then
            show_warn "Pack $PACK_TYPE: Verifiez la config VPN"
        fi
    else
        echo -e "${GREEN}[+]${NC} qBittorrent authentifié"
        curl -s -X POST "http://localhost:8080/api/v2/app/setPreferences" -H "Cookie: SID=$SID" --data-urlencode 'json={"torrent_changed_tmm_enabled":true, "save_path":"/downloads"}'
        for CAT in "radarr" "sonarr"; do
            EXIST_CAT=$(curl -s -X GET "http://localhost:8080/api/v2/torrents/categories" -H "Cookie: SID=$SID")
            if [[ "$EXIST_CAT" == *"$CAT"* ]]; then
                echo -e "    Categorie '$CAT': ${YELLOW}existe${NC}"
            else
                curl -s -X POST "http://localhost:8080/api/v2/torrents/createCategory" -H "Cookie: SID=$SID" --data-urlencode "category=$CAT" --data-urlencode "savePath=/downloads/$CAT"
                echo -e "    Categorie '$CAT': ${GREEN}cree${NC}"
            fi
        done
    fi

    RADARR_URL="http://localhost:7878/api/v3"
    if [ -z "$RADARR_KEY" ]; then 
        echo -e "    ${YELLOW}[*] Radarr${NC}: clé manquante"
    else
        EXIST_R_ROOT=$(curl -s "$RADARR_URL/rootfolder?apiKey=$RADARR_KEY")
        if [[ "$EXIST_R_ROOT" == *"$DATA_PATH"* ]]; then 
            echo -e "    ${GREEN}[+] Radarr${NC}: deja configure"
        else 
            curl -s -X POST "$RADARR_URL/rootfolder?apiKey=$RADARR_KEY" -H "Content-Type: application/json" -d "{\"path\": \"$DATA_PATH/radarr/movies\", \"accessible\": true}" > /dev/null
            echo -e "    ${GREEN}[+] Radarr${NC}: configure"
        fi
        
        EXIST_R_QBIT=$(curl -s "$RADARR_URL/downloadclient?apiKey=$RADARR_KEY")
        if [[ "$EXIST_R_QBIT" == *"qBittorrent"* ]]; then 
            echo -e "    ${GREEN}[+] Radarr${NC}: qBit lie"
        else 
            curl -s -X POST "$RADARR_URL/downloadclient?apiKey=$RADARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"qBittorrent\",\"enable\":true,\"implementation\":\"Qbittorrent\",\"configContract\":\"QbittorrentSettings\",\"protocol\":\"torrent\",\"priority\":1,\"fields\":[{\"name\":\"host\",\"value\":\"qbittorrent\"},{\"name\":\"port\",\"value\":8080},{\"name\":\"username\",\"value\":\"admin\"},{\"name\":\"password\",\"value\":\"$QBIT_TEMP_PASS\"},{\"name\":\"category\",\"value\":\"radarr\"}]}" > /dev/null
            echo -e "    ${GREEN}[+] Radarr${NC}: qBit lie"
        fi
    fi

    SONARR_URL="http://localhost:8989/api/v3"
    if [ -z "$SONARR_KEY" ]; then 
        echo -e "    ${YELLOW}[*] Sonarr${NC}: clé manquante"
    else
        EXIST_S_ROOT=$(curl -s "$SONARR_URL/rootfolder?apiKey=$SONARR_KEY")
        if [[ "$EXIST_S_ROOT" == *"$DATA_PATH"* ]]; then 
            echo -e "    ${GREEN}[+] Sonarr${NC}: deja configure"
        else 
            curl -s -X POST "$SONARR_URL/rootfolder?apiKey=$SONARR_KEY" -H "Content-Type: application/json" -d "{\"path\": \"$DATA_PATH/sonarr/tv\", \"accessible\": true}" > /dev/null
            echo -e "    ${GREEN}[+] Sonarr${NC}: configure"
        fi
        
        EXIST_S_QBIT=$(curl -s "$SONARR_URL/downloadclient?apiKey=$SONARR_KEY")
        if [[ "$EXIST_S_QBIT" == *"qBittorrent"* ]]; then 
            echo -e "    ${GREEN}[+] Sonarr${NC}: qBit lie"
        else 
            curl -s -X POST "$SONARR_URL/downloadclient?apiKey=$SONARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"qBittorrent\",\"enable\":true,\"implementation\":\"Qbittorrent\",\"configContract\":\"QbittorrentSettings\",\"protocol\":\"torrent\",\"priority\":1,\"fields\":[{\"name\":\"host\",\"value\":\"qbittorrent\"},{\"name\":\"port\",\"value\":8080},{\"name\":\"username\",\"value\":\"admin\"},{\"name\":\"password\",\"value\":\"$QBIT_TEMP_PASS\"},{\"name\":\"category\",\"value\":\"sonarr\"}]}" > /dev/null
            echo -e "    ${GREEN}[+] Sonarr${NC}: qBit lie"
        fi
        curl -s -X PUT "$SONARR_URL/config/mediamanagement?apiKey=$SONARR_KEY" -H "Content-Type: application/json" -d "{\"copyAndDeleteImport\": false}" > /dev/null
    fi

    PROWLARR_URL="http://localhost:9696/api/v1"
    if [ -z "$PROWLARR_KEY" ]; then 
        echo -e "    ${YELLOW}[*] Prowlarr${NC}: clé manquante"
    else
        EXIST_FLARE=$(curl -s "$PROWLARR_URL/indexerproxy?apiKey=$PROWLARR_KEY")
        if [[ "$EXIST_FLARE" == *"FlareSolverr"* ]]; then 
            echo -e "    ${GREEN}[+] Prowlarr${NC}: FlareSolverr ok"
        else 
            curl -s -X POST "$PROWLARR_URL/indexerproxy?apiKey=$PROWLARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"FlareSolverr\",\"implementation\":\"FlareSolverr\",\"configContract\":\"FlareSolverrSettings\",\"tags\":[\"flaresolverr\"],\"fields\":[{\"name\":\"host\",\"value\":\"http://flaresolverr:8191/\"}]}" > /dev/null
            echo -e "    ${GREEN}[+] Prowlarr${NC}: FlareSolverr lie"
        fi
        
        EXIST_APPS=$(curl -s "$PROWLARR_URL/applications?apiKey=$PROWLARR_KEY")
        for APP in "Radarr" "Sonarr"; do
            if [[ "$EXIST_APPS" == *"$APP"* ]]; then 
                echo -e "    ${GREEN}[+] Prowlarr${NC}: $APP lie"
            else 
                PORT=$([[ "$APP" == "Radarr" ]] && echo "7878" || echo "8989")
                KEY_VAR=$(echo "${APP^^}_KEY")
                curl -s -X POST "$PROWLARR_URL/applications?apiKey=$PROWLARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"$APP\",\"syncLevel\":\"fullSync\",\"implementation\":\"$APP\",\"configContract\":\"${APP}Settings\",\"fields\":[{\"name\":\"prowlarrUrl\",\"value\":\"http://prowlarr:9696\"},{\"name\":\"baseUrl\",\"value\":\"http://${APP,,}:$PORT\"},{\"name\":\"apiKey\",\"value\":\"${!KEY_VAR}\"}]}" > /dev/null
                echo -e "    ${GREEN}[+] Prowlarr${NC}: $APP lie"
            fi
        done
    fi

    echo -e "\n${CYAN}[*] Jellyfin Bibliotheques${NC}"
    if [ -z "$JELLYFIN_KEY" ]; then 
        echo -e "    ${YELLOW}[*]${NC} Clé manquante"
    else
        configure_jelly "Movies" "movies" "$DATA_PATH/radarr/movies"
        configure_jelly "Shows" "tvshows" "$DATA_PATH/sonarr/tv"
    fi

    if [[ "$INSTALL_BAZARR" == "true" ]]; then
        box_section "Services Optionnels"

        BAZARR_CONFIG="$DATA_PATH/configs/bazarr/config/config.yaml"
        
        if [ -f "$BAZARR_CONFIG" ]; then
            BAZARR_KEY=$(grep 'apikey:' "$BAZARR_CONFIG" | awk '{print $2}' | tr -d '"' | tr -d "'" | tr -d '\r' | head -n 1 | xargs)
        fi

        if [ -z "$BAZARR_KEY" ]; then
            echo -e "    ${RED}[-]${NC} Clé API Bazarr non trouvee"
        else
            echo -e "    ${GREEN}[+]${NC} Bazarr API Key: ${YELLOW}${BAZARR_KEY:0:8}...${NC}"
            sed -i "/BAZARR_KEY=/d" "$CONFIG_FILE"
            echo "BAZARR_KEY=\"$BAZARR_KEY\"" >> "$CONFIG_FILE"

            URL_BAZARR="http://127.0.0.1:6767/api/system/settings"
            OPTS_B="-s --max-time 10 -H X-API-KEY:$BAZARR_KEY"

            echo -e "    Configuration API..."

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=general" -F "settings-general-use_sonarr=true" -F "settings-general-use_radarr=true" > /dev/null

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=sonarr" -F "settings-sonarr-ip=sonarr" -F "settings-sonarr-port=8989" -F "settings-sonarr-apikey=$SONARR_KEY" -F "settings-sonarr-baseurl=/" > /dev/null
            check_status "Liaison Sonarr"

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=radarr" -F "settings-radarr-ip=radarr" -F "settings-radarr-port=7878" -F "settings-radarr-apikey=$RADARR_KEY" -F "settings-radarr-baseurl=/" > /dev/null
            check_status "Liaison Radarr"

            PROFIL_FR='[{"profileId":1,"name":"french","tag":"french","items":[{"id":1,"language":"fr","audio_exclude":"False","audio_only_include":"False","hi":"False","forced":"False"}],"cutoff":65535,"mustContain":[],"mustNotContain":[],"originalFormat":false}]'
            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=languages" -F "languages-enabled=fr" -F "languages-profiles=$PROFIL_FR" -F "settings-general-serie_default_enabled=true" -F "settings-general-serie_default_profile=1" -F "settings-general-movie_default_enabled=true" -F "settings-general-movie_default_profile=1" > /dev/null
            check_status "Profil Francais"

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=providers" -F "settings-general-enabled_providers=tvsubtitles" -F "settings-general-enabled_providers=yifysubtitles" -F "settings-general-enabled_providers=supersubtitles" -F "settings-general-enabled_providers=embeddedsubtitles" -F "settings-general-enabled_providers=animetosho" > /dev/null
            check_status "Providers"

            if [ -f "$HOMEPAGE_SERVICES" ]; then
                if grep -q "container: bazarr" "$HOMEPAGE_SERVICES"; then
                    echo -e "    ${GREEN}[+]${NC} Homepage: Bazarr present"
                else
                    GROUP_NAME="Automation"
                    if ! grep -q -- "- $GROUP_NAME:" "$HOMEPAGE_SERVICES"; then
                        echo -e "\n- $GROUP_NAME:" >> "$HOMEPAGE_SERVICES"
                    fi
                    echo "    - Bazarr:" >> "$HOMEPAGE_SERVICES"
                    echo "        icon: sh-bazarr" >> "$HOMEPAGE_SERVICES"
                    echo "        href: http://{{HOMEPAGE_VAR_SERVER_IP}}:6767" >> "$HOMEPAGE_SERVICES"
                    echo "        description: Subtitle management" >> "$HOMEPAGE_SERVICES"
                    echo "        container: bazarr" >> "$HOMEPAGE_SERVICES"
                    echo "        widget:" >> "$HOMEPAGE_SERVICES"
                    echo "          type: bazarr" >> "$HOMEPAGE_SERVICES"
                    echo "          url: http://bazarr:6767" >> "$HOMEPAGE_SERVICES"
                    echo "          key: $BAZARR_KEY" >> "$HOMEPAGE_SERVICES"
                    echo "          fields: [\"missingEpisodes\", \"missingMovies\"]" >> "$HOMEPAGE_SERVICES"
                    echo -e "    ${GREEN}[+]${NC} Homepage: Bazarr ajoute"
                fi
            fi
        fi
    fi

    echo ""
    separator_full
    echo -e "${BOLD}${GREEN}  CONFIGURATION TERMINEE${NC}"
    separator_full
fi

separator_full
echo -e "${BOLD}${GREEN}  INSTALLATION ISYRR COMPLETEE${NC}"
separator_full
echo ""
echo -e "${BOLD}Acces aux services:${NC}"
echo -e "  ${CYAN}Jellyfin${NC}......... http://${LOCAL_IP}:8096"
echo -e "  ${CYAN}Jellyseerr${NC}....... http://${LOCAL_IP}:5055"
echo -e "  ${CYAN}Sonarr${NC}........... http://${LOCAL_IP}:8989"
echo -e "  ${CYAN}Radarr${NC}........... http://${LOCAL_IP}:7878"
echo -e "  ${CYAN}Prowlarr${NC}......... http://${LOCAL_IP}:9696"
echo -e "  ${CYAN}Jackett${NC}.......... http://${LOCAL_IP}:9117"
if [ "$INSTALL_VPN" == "true" ] || [ "$PACK_TYPE" == "2" ] || [ "$PACK_TYPE" == "3" ]; then
   echo -e "  ${CYAN}qBittorrent${NC}...... http://${LOCAL_IP}:8080 (VPN Securise)"
else
   echo -e "  ${CYAN}qBittorrent${NC}...... http://${LOCAL_IP}:8080"
fi
if [ "$INSTALL_HOMEPAGE" == "true" ]; then
    echo -e "  ${CYAN}Homepage${NC}......... http://${LOCAL_IP}:3000"
fi
if [ "$INSTALL_BAZARR" == "true" ]; then
    echo -e "  ${CYAN}Bazarr${NC}........... http://${LOCAL_IP}:6767"
fi
echo ""
separator_full


