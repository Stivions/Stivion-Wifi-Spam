#!/bin/bash

# ========= COLORES =========
NO_COLOR="\e[0m"
WHITE="\e[1;37m"
BLUE="\e[1;34m"
GREEN="\e[1;32m"
RED="\e[1;31m"
# ============================

# ========= CREDITOS =========
function title() {
    clear
    echo -e "${GREEN}    _       ___ _______    _____"
    echo "   | |     / (_) ____(_)  / ___/____  ____ _____ ___"
    echo "   | | /| / / / /_  / /   \\__ \\/ __ \\/ __ \`/ __ \`__ \\"
    echo "   | |/ |/ / / __/ / /   ___/ / /_/ / /_/ / / / / / /"
    echo "   |__/|__/_/_/   /_/   /____/ .___/\\__,_/_/ /_/ /_/"
    echo "                            /_/                      "
    echo -e "${WHITE}        Creado por Stivion | Solo para fines educativos"
    echo
}
# ============================

# ========= LIMPIEZA =========
function cleanup() {
    clear
    ifconfig "$ADAPTER" down > /dev/null 2>&1
    macchanger -p "$ADAPTER" > /dev/null 2>&1
    iwconfig "$ADAPTER" mode managed > /dev/null 2>&1
    ifconfig "$ADAPTER" up > /dev/null 2>&1
    nmcli device connect "$ADAPTER" > /dev/null 2>&1
    rm -f RANDOM_wordlist.txt
    title
    echo -e "${RED}   Gracias por usar esta herramienta de Stivion."
    echo -e "${WHITE}   Visita el GitHub: https://github.com/125K"
    exit
}
trap cleanup SIGINT
# ============================

# ========= INICIO =========
title
echo -e "${GREEN}   Interfaces de red disponibles:${WHITE}"
ifconfig | grep -oE '^[^ ]+'
echo
echo -ne "${BLUE}   Ingresa tu interfaz WiFi > ${WHITE}"
read -r ADAPTER

title
echo -e "${BLUE}   Selecciona una opción:${WHITE}"
echo -e "   1. Usar lista predeterminada (1000 SSIDs)"
echo -e "   2. Crear y usar lista personalizada"
echo -e "   3. Usar una lista existente"
echo -e "   4. Generar SSIDs aleatorios"
echo
echo -ne "${BLUE}   > ${WHITE}"
read -r OPTION
clear

case $OPTION in
    1)
        nmcli device disconnect "$ADAPTER" > /dev/null 2>&1
        title
        echo -e "${GREEN}   Iniciando spam... CTRL+C para detener\n"
        sleep 1
        ifconfig "$ADAPTER" down
        macchanger -r "$ADAPTER"
        iwconfig "$ADAPTER" mode monitor
        ifconfig "$ADAPTER" up
        mdk3 "$ADAPTER" b -f SSID_List.txt -a -s 1000
        ;;
    2)
        nmcli device disconnect "$ADAPTER" > /dev/null 2>&1
        title
        echo -ne "${BLUE}   Ingresa palabra base (máx. 12 caracteres) > ${WHITE}"
        read -r WORD
        echo -ne "${BLUE}   ¿Cuántos SSIDs quieres generar? > ${WHITE}"
        read -r N
        FILENAME="${WORD}_wordlist.txt"
        for ((i=1; i<=N; i++)); do
            echo "$WORD $i" >> "$FILENAME"
        done
        title
        echo -e "${GREEN}   Iniciando spam... CTRL+C para detener\n"
        sleep 1
        ifconfig "$ADAPTER" down
        macchanger -r "$ADAPTER"
        iwconfig "$ADAPTER" mode monitor
        ifconfig "$ADAPTER" up
        mdk3 "$ADAPTER" b -f "$FILENAME" -a -s "$N"
        ;;
    3)
        nmcli device disconnect "$ADAPTER" > /dev/null 2>&1
        title
        echo -ne "${BLUE}   Ingresa el nombre del archivo de lista > ${WHITE}"
        read -r LISTNAME
        LINES=$(wc -l < "$LISTNAME")
        title
        echo -e "${GREEN}   Iniciando spam... CTRL+C para detener\n"
        sleep 1
        ifconfig "$ADAPTER" down
        macchanger -r "$ADAPTER"
        iwconfig "$ADAPTER" mode monitor
        ifconfig "$ADAPTER" up
        mdk3 "$ADAPTER" b -f "$LISTNAME" -a -s "$LINES"
        ;;
    4)
        nmcli device disconnect "$ADAPTER" > /dev/null 2>&1
        title
        echo -ne "${BLUE}   ¿Cuántos SSIDs aleatorios quieres? > ${WHITE}"
        read -r N
        for ((i=1; i<=N; i++)); do
            pwgen 14 1 >> RANDOM_wordlist.txt
        done
        title
        echo -e "${GREEN}   Iniciando spam... CTRL+C para detener\n"
        sleep 1
        ifconfig "$ADAPTER" down
        macchanger -r "$ADAPTER"
        iwconfig "$ADAPTER" mode monitor
        ifconfig "$ADAPTER" up
        mdk3 "$ADAPTER" b -f RANDOM_wordlist.txt -a -s "$N"
        ;;
    *)
        echo -e "${RED}   Opción inválida. Cerrando..."
        exit 1
        ;;
esac
cleanup
# ============================  