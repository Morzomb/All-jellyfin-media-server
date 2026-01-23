#!/bin/bash

# Chemins
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ENV_FILE="$DIR/.env"
DATA_PATH=$(grep COMMON_PATH "$ENV_FILE" | cut -d '=' -f2)
HOMEPAGE_SERVICES="$DATA_PATH/configs/homepage/config/services.yaml"

# Couleurs
G='\033[0;32m'
Y='\033[1;33m'
R='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}==================================================${NC}"
echo -e "${CYAN}       DEBUG MODE : MOISSONNEUR D'API             ${NC}"
echo -e "${CYAN}==================================================${NC}"

# 1. VERIFICATION DE LA CIBLE
echo -e "\n${Y}[1/3] Vérification du fichier cible :${NC}"
if [ -f "$HOMEPAGE_SERVICES" ]; then
    echo -e "${G}[OK]${NC} Cible trouvée : $HOMEPAGE_SERVICES"
    # Nettoyage automatique des caractères Windows
    sed -i 's/\r$//' "$HOMEPAGE_SERVICES"
else
    echo -e "${R}[ERREUR]${NC} Le fichier $HOMEPAGE_SERVICES n'existe pas."
    exit 1
fi

# 2. FONCTION DE MOISSON VERBEUSE
moissonner() {
    local name=$1
    local path=$2
    local type=$3 # xml ou json

    echo -e "\n${CYAN}--- Analyse du service : $name ---${NC}"
    
    if [ -f "$path" ]; then
        echo -e "${G}[FOUND]${NC} Fichier config : $path"
        
        # Extraction
        if [ "$type" == "xml" ]; then
            KEY=$(grep -oP '(?<=<ApiKey>).*?(?=</ApiKey>)' "$path" 2>/dev/null)
        else
            KEY=$(grep -oP '"(apiKey|APIKey)":\s*"\K[^\"]+' "$path" 2>/dev/null)
        fi

        if [ -z "$KEY" ]; then
            echo -e "${R}[ECHEC]${NC} Clé API non trouvée dans le fichier."
        else
            echo -e "${G}[CLE TROUVÉE]${NC} Clé : ${Y}$KEY${NC}"
            
            # Injection avec vérification
            echo -e "[INFO] Tentative d'injection pour $name..."
            # On cherche le nom du service, et on remplace sur la ligne 'key:' la plus proche
            sed -i "/$name:/,/key:/ s/API_Key_HERE/$KEY/" "$HOMEPAGE_SERVICES"
            
            # Vérification si le mot API_Key_HERE a disparu pour ce bloc
            CHECK=$(grep -A 5 "$name:" "$HOMEPAGE_SERVICES" | grep "API_Key_HERE")
            if [ -z "$CHECK" ]; then
                echo -e "${G}[SUCCÈS]${NC} Remplacement effectué dans services.yaml."
            else
                echo -e "${R}[ERREUR]${NC} Le texte 'API_Key_HERE' est toujours présent pour $name."
                echo -e "         Vérifiez l'orthographe du nom du service dans services.yaml."
            fi
        fi
    else
        echo -e "${R}[SKIP]${NC} Le fichier de config est absent : $path"
    fi
}

# 3. EXECUTION
moissonner "Radarr" "$DATA_PATH/configs/radarr/config.xml" "xml"
moissonner "Sonarr" "$DATA_PATH/configs/sonarr/config.xml" "xml"
moissonner "Prowlarr" "$DATA_PATH/configs/prowlarr/config.xml" "xml"
moissonner "Jellyseerr" "$DATA_PATH/configs/jellyseerr/settings.json" "json"
moissonner "Jackett" "$DATA_PATH/configs/jackett/Jackett/ServerConfig.json" "json"

echo -e "\n${CYAN}==================================================${NC}"
