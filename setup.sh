#!/bin/bash

# ======================================================================
# ISYRR - AUTOMATED MEDIA SERVER SOLUTION
# Final version with improved interface (English)
# ======================================================================

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
REPO="https://raw.githubusercontent.com/Morzomb/All-jellyfin-media-server/Lab"
REPO_BASE="$REPO/auto"
COMPOSE_DL_DIR="$DIR/compose_downloads"
ENV_FILE="$DIR/.env"
CONFIG_FILE="$DIR/.isyrr_config"

# ANSI Colors
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Default Harvest variables
J_USER="odin"
J_PASS="odin"
BASE_URL="http://localhost:8096"
APP_NAME="isyrr_script"

# ======================================================================
# DISPLAY FUNCTIONS
# ======================================================================

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
    local cols=80
    if command -v tput >/dev/null 2>&1; then
        cols=$(tput cols 2>/dev/null || echo 80)
    fi
    cols=${cols:-80}

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

function show_info() { echo -e "${BLUE}[*]${NC} $1"; }
function show_success() { echo -e "${GREEN}[+]${NC} $1"; }
function show_warn() { echo -e "${YELLOW}[!]${NC} $1"; }
function show_error() { echo -e "${RED}[-]${NC} $1"; exit 1; }

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
    echo -e "${BOLD}${CYAN}       AUTOMATED MEDIA SERVER SOLUTION${NC}"
    echo -e "${BOLD}${CYAN}          Jellyfin + Arr Suite Solution${NC}"
    separator_full
    echo ""
}

# Build docker compose command dynamically
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

# ======================================================================
# SYSTEM DETECTION
# ======================================================================

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$PRETTY_NAME
else
    OS_NAME=$(uname -s)
fi

LOCAL_IP=$(hostname -I | awk '{print $1}')
[ -z "$LOCAL_IP" ] && LOCAL_IP="127.0.0.1"

# ======================================================================
# MAIN DISPLAY
# ======================================================================

show_banner
echo -e "${CYAN}System:${NC} $OS_NAME"
echo -e "${CYAN}IP:${NC} $LOCAL_IP"
echo ""

# ======================================================================
# 1. STATEFUL MANAGEMENT
# ======================================================================

box_header "CHECK INSTALLATION"

SKIP_ENV_SETUP=false

if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    show_success "Existing configuration detected"
    echo ""
    echo -e "${CYAN}Your previous installation:${NC}"
    echo -e "  Pack type: ${YELLOW}$PACK_TYPE${NC}"
    echo -e "  VPN: ${YELLOW}$VPN_PROVIDER${NC}"
    echo -e "  Homepage: ${YELLOW}$INSTALL_HOMEPAGE${NC}"
    echo -e "  Bazarr: ${YELLOW}$INSTALL_BAZARR${NC}"
    echo ""
    
    generate_docker_command
    SAVED_CMD="$CMD_ARGS"

    while true; do
        echo -e "${BOLD}What do you want to do?${NC}"
        echo ""
        echo -e "  ${CYAN}1 Update${NC}"
        echo -e "     Pull latest images and restart services"
        echo -e "     Keeps your current configuration"
        echo ""
        echo -e "  ${RED}2 Uninstall${NC}"
        echo -e "     Stop and remove all services"
        echo -e "     Option to remove persistent data"
        echo ""
        echo -e "  ${GREEN}3 Modify / Add services${NC}"
        echo -e "     Relaunch the full configuration"
        echo -e "     Change packs or services"
        echo ""
        echo -e "  ${YELLOW}4 Quit${NC}"
        echo ""
        read -p "Your choice [1-4]: " action_choice
        
        case $action_choice in
            1)
                show_info "Performing update..."
                show_info "Pulling latest images..."
                docker compose --env-file "$ENV_FILE" $SAVED_CMD pull
                show_info "Restarting services..."
                docker compose --env-file "$ENV_FILE" $SAVED_CMD up -d --remove-orphans
                show_success "Update complete"
                exit 0 ;;
            2)
                show_warn "WARNING: This action is irreversible"
                read -p "Confirm uninstall? (y/n): " confirm_del
                if [[ "$confirm_del" =~ ^[yY] ]]; then
                    show_info "Stopping services..."
                    docker compose --env-file "$ENV_FILE" $SAVED_CMD down
                    show_info "Removing configuration files..."
                    rm "$CONFIG_FILE"
                    sudo rm -Rf data/ compose_downloads/ .env
                    
                    read -p "Also remove volumes (persistent data)? (y/n): " del_vol
                    if [[ "$del_vol" =~ ^[yY] ]]; then
                       show_info "Removing Docker volumes..."
                       docker volume prune -f
                    fi
                    show_success "Uninstall complete"
                else
                    show_warn "Uninstall cancelled"
                fi
                exit 0 ;;
            3)
                show_info "Edit mode enabled"
                show_info "Temporarily stopping services..."
                docker compose --env-file "$ENV_FILE" $SAVED_CMD down
                show_success "Services stopped"
                SKIP_ENV_SETUP=true
                break ;;
            4)
                show_info "Exiting script"
                exit 0 ;;
            *) show_error "Invalid choice" ;;
        esac
    done
fi

# ======================================================================
# 2. STACK SELECTION
# ======================================================================

box_header "SELECT MEDIA STACK"

echo -e "${GREEN}[1] STANDARD OFFER${NC}"
echo -e "    Full install without VPN"
echo -e "    Services: Jellyfin, Radarr, Sonarr, Prowlarr, Jackett, qBittorrent"
echo -e "    Ideal for local use"
echo ""

echo -e "${YELLOW}[2] SECURED OFFER${NC}"
echo -e "    All services + VPN tunnel for qBittorrent"
echo -e "    Choice: NordVPN (OpenVPN) or ProtonVPN (WireGuard)"
echo -e "    Protect your torrent traffic"
echo ""

echo -e "${RED}[3] ULTIMATE OFFER${NC}"
echo -e "    Secured pack + Nvidia GPU support"
echo -e "    Optimized 4K transcoding"
echo -e "    For high performance servers"
echo ""

while true; do
    read -p "Choose your offer [1-3]: " PACK_TYPE
    case $PACK_TYPE in
        1|2|3) break ;;
        *) show_error "Error: enter 1, 2 or 3" ;;
    esac
done

VPN_PROVIDER="none"
INSTALL_VPN=false

if [ "$PACK_TYPE" == "1" ]; then
    INSTALL_VPN=false
    show_success "Standard pack selected"
elif [ "$PACK_TYPE" == "2" ] || [ "$PACK_TYPE" == "3" ]; then
    INSTALL_VPN=true
    while true; do
        echo ""
        echo -e "${BOLD}Choose your VPN provider:${NC}"
        echo ""
        echo -e "  ${CYAN}1${NC} NordVPN (OpenVPN)"
        echo -e "     Compatible with most routers"
        echo -e "     Requires: User + Password"
        echo ""
        echo -e "  ${CYAN}2${NC} ProtonVPN (WireGuard)"
        echo -e "     Faster and modern"
        echo -e "     Requires: Endpoint IP + Keys"
        echo ""
        read -p "Your choice [1-2]: " vpn_choice
        
        if [ "$vpn_choice" == "1" ]; then 
            VPN_PROVIDER="nord"
            show_success "NordVPN selected"
            break
        elif [ "$vpn_choice" == "2" ]; then
            VPN_PROVIDER="proton"
            show_success "ProtonVPN selected"
            break
        else
            show_error "Invalid choice"
        fi
    done
fi

# ======================================================================
# 2.5 ADDITIONAL SERVICES
# ======================================================================

box_section "Additional Services"

echo -e "${BOLD}Homepage Dashboard:${NC}"
echo -e "  Unified web interface for your services"
echo -e "  Widgets, bookmarks and realtime info"
echo ""
while true; do
    read -p "Install Homepage Dashboard ? (y/n): " hp_choice
    case $hp_choice in
        [yY]*) INSTALL_HOMEPAGE=true; show_success "Homepage enabled"; break ;;
        [nN]*) INSTALL_HOMEPAGE=false; show_warn "Homepage disabled"; break ;;
        *) show_error "Answer y or n" ;;
    esac
done

echo ""
echo -e "${BOLD}Bazarr - Subtitles manager:${NC}"
echo -e "  Auto-downloads subtitles"
echo -e "  Integrates with Sonarr and Radarr"
echo -e "  Multi-language support"
echo ""
while true; do
    read -p "Install Bazarr (subtitles) ? (y/n): " baz_choice
    case $baz_choice in
        [yY]*) INSTALL_BAZARR=true; show_success "Bazarr enabled"; break ;;
        [nN]*) INSTALL_BAZARR=false; show_warn "Bazarr disabled"; break ;;
        *) show_error "Answer y or n" ;;
    esac
done

# ======================================================================
# 3. ENV VARIABLES CONFIG
# ======================================================================

if [ "$SKIP_ENV_SETUP" = true ] && [ -f "$ENV_FILE" ]; then
    box_section "Environment Variables"
    show_info "Updating server IP..."
    show_info "Keeping existing .env (modification)"
    sed -i "s|^SERVER_IP=.*|SERVER_IP=$LOCAL_IP|g" "$ENV_FILE"
    show_success "Server IP updated: $LOCAL_IP"

    if [ "$INSTALL_VPN" == "true" ]; then
        FORCE_VPN_CONFIG=true 
    fi
else
    FORCE_VPN_CONFIG=true
    box_section "Environment Variables Configuration"

    show_info "Required parameters"
    echo ""
    echo -e "${BOLD}Installation path:${NC}"
    echo -e "  Directory where all services and data will be stored"
    read -p "Path [/home/$USER/data]: " COMMON_PATH
    COMMON_PATH=${COMMON_PATH:-/home/$USER/data}
    show_success "Path: $COMMON_PATH"

    echo ""
    echo -e "${BOLD}Timezone:${NC}"
    echo -e "  Used by Jellyfin and *Arr services"
    echo -e "  Examples: Europe/Paris, Europe/London, America/New_York"
    read -p "Timezone [Europe/Paris]: " USER_TZ
    USER_TZ=${USER_TZ:-Europe/Paris}
    show_success "Timezone: $USER_TZ"

    show_info "Downloading base .env..."
    curl -sL "$REPO_BASE/.env.example" -o .env

    show_info "Injecting variables..."
    sed -i "s|^PUID=.*|PUID=$(id -u)|g" .env
    sed -i "s|^PGID=.*|PGID=$(id -g)|g" .env
    sed -i "s|^TZ=.*|TZ=$USER_TZ|g" .env
    sed -i "s|^COMMON_PATH=.*|COMMON_PATH=$COMMON_PATH|g" .env
    sed -i "s|^SERVER_IP=.*|SERVER_IP=$LOCAL_IP|g" .env
    show_success "Configuration injected"
fi

# VPN configuration
if [ "$INSTALL_VPN" == "true" ] && [ "$FORCE_VPN_CONFIG" = true ]; then
    box_section "VPN Configuration ($VPN_PROVIDER)"
    
    echo -e "${BOLD}Credentials:${NC}"
    echo -e "  These values must be retrieved from your VPN account"
    echo ""
    
    read -p "Enter VPN credentials now ? (y/n): " vpn_now
    case $vpn_now in
        [yY]*)
            if [ "$VPN_PROVIDER" == "nord" ]; then
                show_info "NordVPN - Service Credentials (not login)"
                sed -i "s/^# OPENVPN_USER=/OPENVPN_USER=/g" .env
                sed -i "s/^# OPENVPN_PASSWORD=/OPENVPN_PASSWORD=/g" .env
                sed -i "s/^# SERVER_REGIONS=/SERVER_REGIONS=/g" .env
                
                read -p "NordVPN User (Service Credential): " v_user
                read -p "NordVPN Password: " v_pass
                read -p "Region (eg: Belgium, France, Germany): " v_reg
                
                sed -i "s|^OPENVPN_USER=.*|OPENVPN_USER=$v_user|g" .env
                sed -i "s|^OPENVPN_PASSWORD=.*|OPENVPN_PASSWORD=$v_pass|g" .env
                sed -i "s|^SERVER_REGIONS=.*|SERVER_REGIONS=$v_reg|g" .env
            elif [ "$VPN_PROVIDER" == "proton" ]; then
                show_info "ProtonVPN - WireGuard Configuration"
                show_info "Get these values from your Proton account"
                sed -i "s/^# ENDPOINT_IP=/ENDPOINT_IP=/g" .env
                sed -i "s/^# PUBLIC_KEY=/PUBLIC_KEY=/g" .env
                sed -i "s/^# PRIVATE_KEY=/PRIVATE_KEY=/g" .env
                
                read -p "Endpoint IP (eg: 185.x.x.x): " v_eip
                read -p "Public Key: " v_pub
                read -p "Private Key: " v_priv
                
                sed -i "s|^ENDPOINT_IP=.*|ENDPOINT_IP=$v_eip|g" .env
                sed -i "s|^PUBLIC_KEY=.*|PUBLIC_KEY=$v_pub|g" .env
                sed -i "s|^PRIVATE_KEY=.*|PRIVATE_KEY=$v_priv|g" .env
            fi
            show_success "VPN credentials configured"
            ;;
        [nN]*)
            show_warn "VPN configuration skipped"
            show_info "You will need to edit .env manually before starting"
            show_info "File: $DIR/.env"
            ;;
    esac
fi

# Homepage configuration
if [ "$INSTALL_HOMEPAGE" == "true" ]; then
    box_section "Homepage Configuration"
    echo -e "${BOLD}Homepage settings:${NC}"
    echo -e "  Interface reachable from your network"
    echo -e "  IP address for widgets and direct access"
    echo ""
    sed -i "s/^#SERVER_IP=.*/SERVER_IP=$LOCAL_IP/g" .env
    show_success "Server IP configured: $LOCAL_IP"
    show_info "You will be able to access Homepage at:" 
    echo -e "  ${CYAN}http://${LOCAL_IP}:3000${NC}"
fi

# ======================================================================
# 3.5 PRECONFIG DEPLOY
# ======================================================================

if [ "$INSTALL_HOMEPAGE" == "true" ]; then
    box_section "Preconfigurations"
    
    TARGET_DATA=$(grep COMMON_PATH "$ENV_FILE" | cut -d '=' -f2)
    [ -z "$TARGET_DATA" ] && TARGET_DATA="$COMMON_PATH"
    
    DEST_HOMEPAGE="$TARGET_DATA/configs/homepage"
    HOMEPAGE_CONFIG_BASE="$REPO_BASE/../config/homepage"

    show_info "Downloading Homepage configuration..."
    
    mkdir -p "$DEST_HOMEPAGE/config"
    mkdir -p "$DEST_HOMEPAGE/images"
    
    curl -sL "$HOMEPAGE_CONFIG_BASE/config/bookmarks.yaml" -o "$DEST_HOMEPAGE/config/bookmarks.yaml" 2>/dev/null
    curl -sL "$HOMEPAGE_CONFIG_BASE/config/services.yaml" -o "$DEST_HOMEPAGE/config/services.yaml" 2>/dev/null
    curl -sL "$HOMEPAGE_CONFIG_BASE/config/widgets.yaml" -o "$DEST_HOMEPAGE/config/widgets.yaml" 2>/dev/null
    
    show_success "Homepage deployed to $DEST_HOMEPAGE"
fi

# ======================================================================
# 4. SAVE & DEPLOY
# ======================================================================

box_section "Finalization"

cat > "$CONFIG_FILE" <<EOF
PACK_TYPE="$PACK_TYPE"
VPN_PROVIDER="$VPN_PROVIDER"
INSTALL_HOMEPAGE="$INSTALL_HOMEPAGE"
INSTALL_BAZARR="$INSTALL_BAZARR"
EOF
show_success "Configuration saved"

generate_docker_command

CURRENT_PATH=$(grep COMMON_PATH "$ENV_FILE" | cut -d '=' -f2)
[ -z "$CURRENT_PATH" ] && CURRENT_PATH="/home/$USER/data"

mkdir -p "$CURRENT_PATH/configs/"{qbittorrent,prowlarr,jackett,sonarr,radarr,jellyfin,jellyseerr,gluetun}
mkdir -p "$CURRENT_PATH/qbittorrent/downloads"
mkdir -p "$CURRENT_PATH/sonarr/tv"
mkdir -p "$CURRENT_PATH/radarr/movies"
[ "$INSTALL_HOMEPAGE" == "true" ] && mkdir -p "$CURRENT_PATH/configs/homepage"
[ "$INSTALL_BAZARR" == "true" ] && mkdir -p "$CURRENT_PATH/configs/bazarr"

show_success "Directories created"

separator_full
echo -e "${BOLD}${GREEN}  READY TO START${NC}"
separator_full

while true; do
    read -p "Start services now? (y/n): " final
    case $final in
        [yY]*)
            show_info "Applying configuration..."
            separator_full
            docker compose --env-file "$ENV_FILE" $CMD_ARGS up -d --remove-orphans
            
            if [ "$PACK_TYPE" == "3" ]; then
                separator_full
                show_warn "NVIDIA ACCELERATION REMINDER"
                echo "Check that you have:"
                echo "  - Nvidia drivers installed"
                echo "  - Nvidia Container Toolkit configured"
                separator_full
            fi

            show_success "Installation complete"
            separator_full
            break ;;
        [nN]*)
            show_info "Cancelled. To start later run:" 
            echo -e "${CYAN}docker compose --env-file .env $CMD_ARGS up -d${NC}"
            separator_full
            break ;;
        *) show_error "Answer y or n" ;;
    esac
done

# ======================================================================
# 5. POST-INSTALL & AUTO CONFIG
# ======================================================================

read -p "Run automatic configuration now? (y/n): " harvest_choice
case $harvest_choice in
    [yY]*) DO_HARVEST=true ;;
    *) DO_HARVEST=false ;;
esac

if [ "$DO_HARVEST" == "true" ]; then
    separator_full
    box_header "AUTOMATIC CONFIGURATION"
    show_info "Integrated API harvest module..."
    show_info "Waiting for initialization (120s)..."
    echo ""
    
    for i in {1..120}; do
        echo -ne "${CYAN}Initialization: [$i/120s]${NC}\r"
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
            echo -e "${RED}[ERROR $1]${NC}"
            exit 1
        fi
    }

    moissonner() {
        local name=$1; local path=$2; local type=$3
        echo -e "\n${CYAN}[*] Scan: $name${NC}"
        if [ -f "$path" ]; then
            if [ "$type" == "xml" ]; then
                KEY=$(grep -oP '(?<=<ApiKey>).*?(?=</ApiKey>)' "$path" 2>/dev/null)
            else
                KEY=$(grep -oP '"(apiKey|APIKey)":\s*"\K[^"]+' "$path" 2>/dev/null)
            fi
            if [ -n "$KEY" ]; then
                echo -e "    ${GREEN}[+] Key found${NC}: ${YELLOW}${KEY:0:8}...${NC}"
                VAR_NAME="$(echo $name | tr '[:lower:]' '[:upper:]')_KEY"
                sed -i "/$VAR_NAME=/d" "$CONFIG_FILE"
                echo "$VAR_NAME=\"$KEY\"" >> "$CONFIG_FILE"
                export "$VAR_NAME=$KEY"
                if [ "$INSTALL_HOMEPAGE" == "true" ] && [ -f "$HOMEPAGE_SERVICES" ]; then
                    sed -i "/$name:/,/key:/ s/key: .*/key: $KEY/" "$HOMEPAGE_SERVICES"
                fi
            fi
        else 
            echo -e "    ${RED}[-] File missing${NC}: $path"
        fi
    }

    configure_jelly() {
        local NAME=$1; local TYPE=$2; local PATH_FOLDER=$3
        EXIST_LIB=$(curl -s -H "X-Emby-Token: $JELLYFIN_KEY" "$BASE_URL/Library/VirtualFolders")
        if [[ "$EXIST_LIB" == *"$NAME"* ]]; then 
            echo -e "    ${YELLOW}[*] Library '$NAME'${NC}: already exists"
        else 
            echo -ne "    Creating '$NAME'... "
            curl -s -X POST "$BASE_URL/Library/VirtualFolders?name=$NAME&collectionType=$TYPE&refreshLibrary=false" -H "X-Emby-Token: $JELLYFIN_KEY" > /dev/null
            echo -e "${GREEN}[OK]${NC}"
        fi

        if [[ "$EXIST_LIB" == *"$PATH_FOLDER"* ]]; then 
            echo -e "    ${YELLOW}[*] Path${NC}: already linked"
        else 
            echo -ne "    Linking path... "
            curl -s -X POST "$BASE_URL/Library/VirtualFolders/Paths?refreshLibrary=true" -H "X-Emby-Token: $JELLYFIN_KEY" -H "Content-Type: application/json" -d "{\"Name\":\"$NAME\",\"PathInfo\":{\"Path\":\"$PATH_FOLDER\"}}" > /dev/null
            echo -e "${GREEN}[OK]${NC}"
        fi
    }

    box_section "Initialization and Harvest"

    echo -e "\n${CYAN}[*] Jellyfin${NC}"
    WIZARD_DONE=$(grep "WIZARD_DONE=" "$CONFIG_FILE" | cut -d '=' -f2 | tr -d '"')

    if [ "$WIZARD_DONE" == "true" ]; then
        echo -e "    ${YELLOW}[*]${NC} Wizard already completed"
    else
        show_info "Checking Jellyfin container and HTTP access..."
        READY=false
        for i in {1..5}; do
            if command -v docker >/dev/null 2>&1; then
                STATUS=$(docker ps --filter "name=jellyfin" --format '{{.Status}}' 2>/dev/null | head -n1)
                if [[ "$STATUS" == *"Up"* ]]; then
                    READY=true
                    break
                fi
            fi

            CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 "$BASE_URL" || echo "000")
            if [[ "$CODE" =~ ^2|^3 ]]; then
                READY=true
                break
            fi

            [ $i -lt 5 ] && sleep 2
        done

        if [ "$READY" != true ]; then
            show_warn "Jellyfin unavailable; Wizard will be skipped for now"
        else
            echo -e "    ${CYAN}[*]${NC} Launching Wizard..."
            read -p "    Server name [Isyrr]: " SERVER_NAME
            SERVER_NAME=${SERVER_NAME:-Isyrr}
            
            read -p "    Admin [$J_USER]: " J_USER_IN
            J_USER=${J_USER_IN:-$J_USER}
            read -s -p "    Password: " J_PASS_IN
            echo -e ""
            J_PASS=${J_PASS_IN:-$J_PASS}

            echo -n "    [1/6] Config... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/Configuration" -H "Content-Type: application/json" -d "{\"ServerName\":\"$SERVER_NAME\",\"UICulture\":\"en-US\",\"MetadataCountryCode\":\"US\"}")
            check_http "$CODE"

            echo -n "    [2/6] Initialization... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$BASE_URL/Startup/User")
            check_http "$CODE"

            echo -n "    [3/6] Admin... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/User" -H "Content-Type: application/json" -d "{\"Name\":\"$J_USER\",\"Password\":\"$J_PASS\"}")
            check_http "$CODE"

            echo -n "    [4/6] Settings... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/Configuration" -H "Content-Type: application/json" -d "{\"UICulture\":\"en-US\",\"MetadataCountryCode\":\"US\"}")
            check_http "$CODE"

            echo -n "    [5/6] Remote access... "
            CODE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE_URL/Startup/RemoteAccess" -H "Content-Type: application/json" -d '{"EnableRemoteAccess":true,"EnableAutomaticPortMapping":false}')
            check_http "$CODE"

            echo -n "    [6/6] Finalize... "
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
            show_info "Creating a new key..."
            curl -s -o /dev/null -X POST "$BASE_URL/Auth/Keys?app=$APP_NAME" -H "X-Emby-Token: $SESSION_TOKEN"
            LIST_KEYS=$(curl -s -X GET "$BASE_URL/Auth/Keys" -H "X-Emby-Token: $SESSION_TOKEN")
            FINAL_KEY=$(echo "$LIST_KEYS" | sed 's/},{/\n/g' | grep "$APP_NAME" | grep -oP '"AccessToken":"\K[^"]+' | head -n 1)
        fi
        if [ ! -z "$FINAL_KEY" ]; then
            echo -e "    ${GREEN}[+]${NC} API Key obtained"
            sed -i "/JELLYFIN_KEY=/d" "$CONFIG_FILE"
            echo "JELLYFIN_KEY=\"$FINAL_KEY\"" >> "$CONFIG_FILE"
            export JELLYFIN_KEY="$FINAL_KEY"
            if [ "$INSTALL_HOMEPAGE" == "true" ] && [ -f "$HOMEPAGE_SERVICES" ]; then
                sed -i "/Jellyfin:/,/key:/ s|key: .*|key: $FINAL_KEY|" "$HOMEPAGE_SERVICES"
            fi
        fi
    else
        echo -e "    ${RED}[-]${NC} Authentication failed"
    fi

    echo -e "\n${CYAN}[*] Harvesting Services${NC}"
    QBIT_PASS=$(docker logs qbittorrent 2>&1 | grep "temporary password" | awk '{print $NF}' | tail -n 1)
    if [ -z "$QBIT_PASS" ]; then
        echo -e "    ${YELLOW}[!]${NC} qBittorrent password not found"
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

    box_section "Service Configuration"

    sudo mkdir -p "$DATA_PATH/qbittorrent/downloads/radarr"
    sudo mkdir -p "$DATA_PATH/qbittorrent/downloads/sonarr"
    sudo chmod -R 777 "$DATA_PATH/qbittorrent/downloads/"

    COOKIE=$(curl -s -i --max-time 5 -X POST "http://localhost:8080/api/v2/auth/login" -d "username=admin&password=$QBIT_TEMP_PASS")
    SID=$(echo "$COOKIE" | grep -oP 'SID=\K[^;]+')

    if [ -z "$SID" ]; then 
        echo -e "${RED}[-]${NC} Unable to connect to qBittorrent"
        if [[ "$PACK_TYPE" == "2" || "$PACK_TYPE" == "3" ]]; then
            show_warn "Pack $PACK_TYPE: Check VPN configuration"
        fi
    else
        echo -e "${GREEN}[+]${NC} qBittorrent authenticated"
        curl -s -X POST "http://localhost:8080/api/v2/app/setPreferences" -H "Cookie: SID=$SID" --data-urlencode 'json={"torrent_changed_tmm_enabled":true, "save_path":"/downloads"}'
        for CAT in "radarr" "sonarr"; do
            EXIST_CAT=$(curl -s -X GET "http://localhost:8080/api/v2/torrents/categories" -H "Cookie: SID=$SID")
            if [[ "$EXIST_CAT" == *"$CAT"* ]]; then
                echo -e "    Category '$CAT': ${YELLOW}exists${NC}"
            else
                curl -s -X POST "http://localhost:8080/api/v2/torrents/createCategory" -H "Cookie: SID=$SID" --data-urlencode "category=$CAT" --data-urlencode "savePath=/downloads/$CAT"
                echo -e "    Category '$CAT': ${GREEN}created${NC}"
            fi
        done
    fi

    RADARR_URL="http://localhost:7878/api/v3"
    if [ -z "$RADARR_KEY" ]; then 
        echo -e "    ${YELLOW}[*] Radarr${NC}: key missing"
    else
        EXIST_R_ROOT=$(curl -s "$RADARR_URL/rootfolder?apiKey=$RADARR_KEY")
        if [[ "$EXIST_R_ROOT" == *"$DATA_PATH"* ]]; then 
            echo -e "    ${GREEN}[+] Radarr${NC}: already configured"
        else 
            curl -s -X POST "$RADARR_URL/rootfolder?apiKey=$RADARR_KEY" -H "Content-Type: application/json" -d "{\"path\": \"$DATA_PATH/radarr/movies\", \"accessible\": true}" > /dev/null
            echo -e "    ${GREEN}[+] Radarr${NC}: configured"
        fi
        
        EXIST_R_QBIT=$(curl -s "$RADARR_URL/downloadclient?apiKey=$RADARR_KEY")
        if [[ "$EXIST_R_QBIT" == *"qBittorrent"* ]]; then 
            echo -e "    ${GREEN}[+] Radarr${NC}: qBit linked"
        else 
            curl -s -X POST "$RADARR_URL/downloadclient?apiKey=$RADARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"qBittorrent\",\"enable\":true,\"implementation\":\"Qbittorrent\",\"configContract\":\"QbittorrentSettings\",\"protocol\":\"torrent\",\"priority\":1,\"fields\":[{\"name\":\"host\",\"value\":\"qbittorrent\"},{\"name\":\"port\",\"value\":8080},{\"name\":\"username\",\"value\":\"admin\"},{\"name\":\"password\",\"value\":\"$QBIT_TEMP_PASS\"},{\"name\":\"category\",\"value\":\"radarr\"}]}" > /dev/null
            echo -e "    ${GREEN}[+] Radarr${NC}: qBit linked"
        fi
    fi

    SONARR_URL="http://localhost:8989/api/v3"
    if [ -z "$SONARR_KEY" ]; then 
        echo -e "    ${YELLOW}[*] Sonarr${NC}: key missing"
    else
        EXIST_S_ROOT=$(curl -s "$SONARR_URL/rootfolder?apiKey=$SONARR_KEY")
        if [[ "$EXIST_S_ROOT" == *"$DATA_PATH"* ]]; then 
            echo -e "    ${GREEN}[+] Sonarr${NC}: already configured"
        else 
            curl -s -X POST "$SONARR_URL/rootfolder?apiKey=$SONARR_KEY" -H "Content-Type: application/json" -d "{\"path\": \"$DATA_PATH/sonarr/tv\", \"accessible\": true}" > /dev/null
            echo -e "    ${GREEN}[+] Sonarr${NC}: configured"
        fi
        
        EXIST_S_QBIT=$(curl -s "$SONARR_URL/downloadclient?apiKey=$SONARR_KEY")
        if [[ "$EXIST_S_QBIT" == *"qBittorrent"* ]]; then 
            echo -e "    ${GREEN}[+] Sonarr${NC}: qBit linked"
        else 
            curl -s -X POST "$SONARR_URL/downloadclient?apiKey=$SONARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"qBittorrent\",\"enable\":true,\"implementation\":\"Qbittorrent\",\"configContract\":\"QbittorrentSettings\",\"protocol\":\"torrent\",\"priority\":1,\"fields\":[{\"name\":\"host\",\"value\":\"qbittorrent\"},{\"name\":\"port\",\"value\":8080},{\"name\":\"username\",\"value\":\"admin\"},{\"name\":\"password\",\"value\":\"$QBIT_TEMP_PASS\"},{\"name\":\"category\",\"value\":\"sonarr\"}]}" > /dev/null
            echo -e "    ${GREEN}[+] Sonarr${NC}: qBit linked"
        fi
        curl -s -X PUT "$SONARR_URL/config/mediamanagement?apiKey=$SONARR_KEY" -H "Content-Type: application/json" -d "{\"copyAndDeleteImport\": false}" > /dev/null
    fi

    PROWLARR_URL="http://localhost:9696/api/v1"
    if [ -z "$PROWLARR_KEY" ]; then 
        echo -e "    ${YELLOW}[*] Prowlarr${NC}: key missing"
    else
        EXIST_FLARE=$(curl -s "$PROWLARR_URL/indexerproxy?apiKey=$PROWLARR_KEY")
        if [[ "$EXIST_FLARE" == *"FlareSolverr"* ]]; then 
            echo -e "    ${GREEN}[+] Prowlarr${NC}: FlareSolverr ok"
        else 
            curl -s -X POST "$PROWLARR_URL/indexerproxy?apiKey=$PROWLARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"FlareSolverr\",\"implementation\":\"FlareSolverr\",\"configContract\":\"FlareSolverrSettings\",\"tags\":[\"flaresolverr\"],\"fields\":[{\"name\":\"host\",\"value\":\"http://flaresolverr:8191/\"}]}" > /dev/null
            echo -e "    ${GREEN}[+] Prowlarr${NC}: FlareSolverr linked"
        fi
        
        EXIST_APPS=$(curl -s "$PROWLARR_URL/applications?apiKey=$PROWLARR_KEY")
        for APP in "Radarr" "Sonarr"; do
            if [[ "$EXIST_APPS" == *"$APP"* ]]; then 
                echo -e "    ${GREEN}[+] Prowlarr${NC}: $APP linked"
            else 
                PORT=$([[ "$APP" == "Radarr" ]] && echo "7878" || echo "8989")
                KEY_VAR=$(echo "${APP^^}_KEY")
                curl -s -X POST "$PROWLARR_URL/applications?apiKey=$PROWLARR_KEY" -H "Content-Type: application/json" -d "{\"name\":\"$APP\",\"syncLevel\":\"fullSync\",\"implementation\":\"$APP\",\"configContract\":\"${APP}Settings\",\"fields\":[{\"name\":\"prowlarrUrl\",\"value\":\"http://prowlarr:9696\"},{\"name\":\"baseUrl\",\"value\":\"http://${APP,,}:$PORT\"},{\"name\":\"apiKey\",\"value\":\"${!KEY_VAR}\"}]}" > /dev/null
                echo -e "    ${GREEN}[+] Prowlarr${NC}: $APP linked"
            fi
        done
    fi

    echo -e "\n${CYAN}[*] Jellyfin Libraries${NC}"
    if [ -z "$JELLYFIN_KEY" ]; then 
        echo -e "    ${YELLOW}[*]${NC} Key missing"
    else
        configure_jelly "Movies" "movies" "$DATA_PATH/radarr/movies"
        configure_jelly "Shows" "tvshows" "$DATA_PATH/sonarr/tv"
    fi

    if [[ "$INSTALL_BAZARR" == "true" ]]; then
        box_section "Optional Services"

        BAZARR_CONFIG="$DATA_PATH/configs/bazarr/config/config.yaml"
        
        if [ -f "$BAZARR_CONFIG" ]; then
            BAZARR_KEY=$(grep 'apikey:' "$BAZARR_CONFIG" | awk '{print $2}' | tr -d '"' | tr -d "'" | tr -d '\r' | head -n 1 | xargs)
        fi

        if [ -z "$BAZARR_KEY" ]; then
            echo -e "    ${RED}[-]${NC} Bazarr API Key not found"
        else
            echo -e "    ${GREEN}[+]${NC} Bazarr API Key: ${YELLOW}${BAZARR_KEY:0:8}...${NC}"
            sed -i "/BAZARR_KEY=/d" "$CONFIG_FILE"
            echo "BAZARR_KEY=\"$BAZARR_KEY\"" >> "$CONFIG_FILE"

            URL_BAZARR="http://127.0.0.1:6767/api/system/settings"
            OPTS_B="-s --max-time 10 -H X-API-KEY:$BAZARR_KEY"

            echo -e "    Configuring API..."

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=general" -F "settings-general-use_sonarr=true" -F "settings-general-use_radarr=true" > /dev/null

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=sonarr" -F "settings-sonarr-ip=sonarr" -F "settings-sonarr-port=8989" -F "settings-sonarr-apikey=$SONARR_KEY" -F "settings-sonarr-baseurl=/" > /dev/null
            check_status "Link Sonarr"

            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=radarr" -F "settings-radarr-ip=radarr" -F "settings-radarr-port=7878" -F "settings-radarr-apikey=$RADARR_KEY" -F "settings-radarr-baseurl=/" > /dev/null
            check_status "Link Radarr"

            PROFIL_EN='[{"profileId":1,"name":"english","tag":"english","items":[{"id":1,"language":"en","audio_exclude":"False","audio_only_include":"False","hi":"False","forced":"False"}],"cutoff":65535,"mustContain":[],"mustNotContain":[],"originalFormat":false}]'
            curl $OPTS_B -X POST "$URL_BAZARR" -F "section=languages" -F "languages-enabled=en" -F "languages-profiles=$PROFIL_EN" -F "settings-general-serie_default_enabled=true" -F "settings-general-serie_default_profile=1" -F "settings-general-movie_default_enabled=true" -F "settings-general-movie_default_profile=1" > /dev/null
            check_status "English Profile"

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
                    echo -e "    ${GREEN}[+]${NC} Homepage: Bazarr added"
                fi
            fi
        fi
    fi

    echo ""
    separator_full
    echo -e "${BOLD}${GREEN}  CONFIGURATION COMPLETE${NC}"
    separator_full
fi

separator_full
echo -e "${BOLD}${GREEN}  ISYRR INSTALLATION COMPLETE${NC}"
separator_full
echo ""
echo -e "${BOLD}Access to services:${NC}"
echo -e "  ${CYAN}Jellyfin${NC}......... http://${LOCAL_IP}:8096"
echo -e "  ${CYAN}Jellyseerr${NC}....... http://${LOCAL_IP}:5055"
echo -e "  ${CYAN}Sonarr${NC}........... http://${LOCAL_IP}:8989"
echo -e "  ${CYAN}Radarr${NC}........... http://${LOCAL_IP}:7878"
echo -e "  ${CYAN}Prowlarr${NC}......... http://${LOCAL_IP}:9696"
echo -e "  ${CYAN}Jackett${NC}.......... http://${LOCAL_IP}:9117"
if [ "$INSTALL_VPN" == "true" ] || [ "$PACK_TYPE" == "2" ] || [ "$PACK_TYPE" == "3" ]; then
   echo -e "  ${CYAN}qBittorrent${NC}...... http://${LOCAL_IP}:8080 (VPN Secured)"
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
