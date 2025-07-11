#!/bin/bash

GREEN="\e[1;32m"
BLUE="\e[1;34m"
RED="\e[1;31m"
WHITE="\e[1;37m"
NC="\e[0m"

function title() {
    clear
    echo -e "${GREEN}[*] Instalador de Stivion WiFi Spammer para Kali Linux"
    echo -e "${WHITE}    Uso exclusivo educativo - https://github.com/125K\n${NC}"
}

function check_kali() {
    if ! grep -iq "kali" /etc/os-release; then
        echo -e "${RED}[✘] Este sistema no parece ser Kali Linux. Abortando.${NC}"
        exit 1
    fi
}

function add_repos() {
    echo -e "${BLUE}[*] Verificando repositorios en /etc/apt/sources.list...${NC}"
    if ! grep -q "kali-rolling" /etc/apt/sources.list; then
        echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" | sudo tee -a /etc/apt/sources.list
        echo -e "${GREEN}[+] Añadido repo kali-rolling${NC}"
    else
        echo -e "${GREEN}[✓] Repo kali-rolling ya presente${NC}"
    fi

    if ! grep -q "kali-bleeding-edge" /etc/apt/sources.list; then
        echo "deb http://repo.kali.org/kali kali-bleeding-edge main" | sudo tee -a /etc/apt/sources.list
        echo -e "${GREEN}[+] Añadido repo kali-bleeding-edge${NC}"
    else
        echo -e "${GREEN}[✓] Repo kali-bleeding-edge ya presente${NC}"
    fi
}

function install_packages() {
    echo -e "${BLUE}[*] Actualizando repositorios e instalando paquetes...${NC}"
    sudo apt-get update
    sudo apt-get install -y mdk3 macchanger pwgen
}

function download_keyring() {
    if [ ! -f "kali-archive-keyring_2018.1_all.deb" ]; then
        echo -e "${BLUE}[*] Descargando paquete kali-archive-keyring...${NC}"
        wget https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2018.1_all.deb
    else
        echo -e "${GREEN}[✓] Paquete kali-archive-keyring ya descargado${NC}"
    fi
}

function install_keyring() {
    echo -e "${BLUE}[*] Instalando kali-archive-keyring...${NC}"
    sudo apt install ./kali-archive-keyring_2018.1_all.deb -y
}

# --- Main ---
title
check_kali
download_keyring
install_keyring
add_repos
install_packages

echo -e "\n${GREEN}[✓] ¡Todo instalado correctamente!${NC}"
echo -e "${WHITE}[*] Creado por Stivion para fines educativos.${NC}"
