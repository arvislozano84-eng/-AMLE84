#!/bin/bash

# --- COLORES ---
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARILLO='\033[1;33m'
ROJO='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- CONFIGURACIÓN ---
URL_SCRIPT="https://raw.githubusercontent.com/arvislozano84-eng/-AMLE84/refs/heads/main/Setup.sh"
DB_USUARIOS="lista_usuarios.db"

# --- VERIFICACIÓN INICIAL ---
if [ ! -f "$DB_USUARIOS" ] || [ ! -s "$DB_USUARIOS" ]; then
    echo "admin|1234" > "$DB_USUARIOS"
fi

# --- FUNCIÓN DE LOGIN ---
login_sistema() {
    clear
    echo -e "${AZUL}╔════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}   ${AMARILLO}🔐 ACCESO RESTRINGIDO - @amle84${NC}      ${AZUL}║${NC}"
    echo -e "${AZUL}╚════════════════════════════════════════╝${NC}"
    
    echo -n -e "👤 ${CYAN}Usuario:${NC} "
    read user_login
    echo -n -e "🔑 ${CYAN}Contraseña:${NC} "
    read -s pass_login
    echo ""

    if grep -q "^$user_login|$pass_login$" "$DB_USUARIOS"; then
        echo -e "\n${VERDE}✅ Acceso concedido.${NC}"
        sleep 1
        menu_principal
    else
        echo -e "\n${ROJO}❌ Datos incorrectos.${NC}"
        sleep 2
        exit
    fi
}

# --- GESTIÓN DE USUARIOS (KEYS) ---
control_usuarios() {
    clear
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}       ${VERDE}👤 GESTIÓN DE USUARIOS - @amle84${NC}        ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e " ${VERDE}[1]${NC} ${AMARILLO}➡${NC} GENERAR NUEVO USUARIO/KEY"
    echo -e " ${VERDE}[2]${NC} ${AMARILLO}➡${NC} VER LISTA DE KEYS ACTIVAS"
    echo -e " ${VERDE}[3]${NC} ${AMARILLO}➡${NC} ELIMINAR USUARIO/KEY"
    echo -e " ${VERDE}[0]${NC} ${AMARILLO}➡${NC} VOLVER AL MENÚ"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Seleccione una opción: "
    read opt_user

    case $opt_user in
        1)
            echo -e "\n${CYAN}--- REGISTRO DE NUEVA KEY ---${NC}"
            echo -n "📝 Nombre del cliente: "; read new_name
            echo -n "🔑 Asigne una Contraseña/Key: "; read new_pass
            echo "$new_name|$new_pass" >> "$DB_USUARIOS"
            echo -e "${VERDE}✅ Key generada con éxito.${NC}"
            sleep 2; control_usuarios ;;
        2)
            echo -e "\n${CYAN}📋 LISTA DE CREDENCIALES:${NC}"
            echo -e "${AMARILLO}--------------------------------------------${NC}"
            if [ -s "$DB_USUARIOS" ]; then
                awk -F'|' '{printf " ID: %02d | Usuario: %-10s | Key: %-10s\n", NR, $1, $2}' "$DB_USUARIOS"
            else
                echo -e "${ROJO}No hay usuarios registrados.${NC}"
            fi
            echo -e "${AMARILLO}--------------------------------------------${NC}"
            echo -e "Presiona Enter para volver..."; read; control_usuarios ;;
        3)
            echo -e "\n${ROJO}--- ELIMINAR USUARIO ---${NC}"
            cat -n "$DB_USUARIOS"
            echo -n "ID a borrar: "; read num
            sed -i "${num}d" "$DB_USUARIOS"
            echo -e "${VERDE}✅ Eliminado.${NC}"
            sleep 2; control_usuarios ;;
        0) menu_principal ;;
        *) control_usuarios ;;
    esac
}

# --- HERRAMIENTAS DE INSTALACIÓN ---
instalar_basicos() {
    clear
    echo -e "${AMARILLO}🛠️ Instalando paquetes básicos...${NC}"
    apt update && apt upgrade -y
    apt install git php python python2 wget curl ruby nodejs nano -y
    echo -e "${VERDE}✅ Paquetes instalados.${NC}"
    sleep 2; menu_principal
}

# --- FUNCIÓN UPDATE ---
actualizar_sistema() {
    clear
    echo -e "${AMARILLO}⏳ Buscando actualizaciones en GitHub...${NC}"
    wget -q -O Setup.sh "$URL_SCRIPT"
    if [ $? -eq 0 ]; then
        chmod +x Setup.sh
        echo -e "${VERDE}✅ Actualizado. Reiniciando...${NC}"
        sleep 2; exec ./Setup.sh
    else
        echo -e "${ROJO}❌ Error al conectar.${NC}"
        sleep 2; menu_principal
    fi
}

# --- MENÚ PRINCIPAL ---
menu_principal() {
    clear
    echo -e "${AZUL}    ____  ___    _   __________ ${NC}"
    echo -e "${AZUL}   / __ \/   |  / | / / ____/ / ${NC}"
    echo -e "${AZUL}  / /_/ / /| | /  |/ / __/ / /  ${NC}"
    echo -e "${AZUL} / ____/ ___ |/ /|  / /___/ /___${NC}"
    echo -e "${AZUL}/_/   /_/  |_/_/ |_/_____/_____/${NC} ${AMARILLO}v2.0${NC}"
    echo -e "${CYAN}      Developer: @amle84${NC}"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -e " ${VERDE}[01]${NC} ➡ GESTIÓN DE USUARIOS / KEYS"
    echo -e " ${VERDE}[02]${NC} ➡ INSTALAR REQUISITOS (GIT, PYTHON, ETC)"
    echo -e " ${VERDE}[03]${NC} ➡ INSTALAR SQLMAP"
    echo -e " ${VERDE}[04]${NC} ➡ INSTALAR NMAP"
    echo -e " ${VERDE}[05]${NC} ➡ ACTUALIZAR SISTEMA"
    echo -e " ${VERDE}[00]${NC} ➡ SALIR"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Seleccione una opción: "
    read opcion

    case $opcion in
        1|01) control_usuarios ;;
        2|02) instalar_basicos ;;
        3|03) apt install sqlmap -y; sleep 2; menu_principal ;;
        4|04) apt install nmap -y; sleep 2; menu_principal ;;
        5|05) actualizar_sistema ;;
        0|00) clear; exit ;;
        *) menu_principal ;;
    esac
}

# Ejecución
login_sistema
