#!/bin/bash

# --- CONFIGURACIÓN ---
# Reemplaza esto con tu link RAW de GitHub cuando lo tengas
URL_KEYS="https://raw.githubusercontent.com/TuUsuario/tu-repo/main/keys.txt"

# COLORES
VERDE='\033[1;32m'
AZUL='\033[1;34m'
CYAN='\033[1;36m'
AMARILLO='\033[1;33m'
ROJO='\033[1;31m'
NC='\033[0m'

# --- 1. VALIDACIÓN DE SEGURIDAD ---
clear
echo -e "${AZUL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  ${VERDE}🛡️  SISTEMA DE SEGURIDAD @amle84${NC}"
echo -e "${AZUL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -n "🔑 INGRESA TU KEY: "
read user_key

# Si la llave es @AMLE84 (manual) o está en tu GitHub, entra.
if [[ "$user_key" == "@AMLE84" ]] || curl -s "$URL_KEYS" | grep -qw "$user_key"; then
    echo -e "${VERDE}✅ ACCESO CONCEDIDO.${NC}"
    sleep 2
else
    echo -e "${ROJO}❌ KEY INVÁLIDA. Contacta a @amle84${NC}"
    exit 1
fi

# --- 2. DISEÑO DEL MENÚ PRINCIPAL ---
menu_principal() {
    clear
    # Datos de sistema para Termux
    MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
    MEM_USADA=$(free -m | grep Mem | awk '{print $3}')
    
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}  ${VERDE}🛡️  INSTALADOR OFICIAL @amle84${NC}  ${AZUL}║${NC}"
    echo -e "${AZUL}║${NC}        ${CYAN}Versión V1.0 - Panel de Control${NC}        ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN} 🔹 S.O:${NC} Android  ${CYAN}🔹 IP:${NC} $(curl -s https://ifconfig.me)"
    echo -e "${CYAN} 🔹 RAM:${NC} ${MEM_USADA}MB / ${MEM_TOTAL}MB  ${CYAN}🔹 FECHA:${NC} $(date +'%d/%m/%Y')"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -e " ${VERDE}[01]${NC} ${AMARILLO}➡${NC} CONTROL USUARIOS (SSH/SSL/VMESS)"
    echo -e " ${VERDE}[02]${NC} ${AMARILLO}➡${NC} [!] OPTIMIZAR VPS"
    echo -e " ${VERDE}[03]${NC} ${AMARILLO}➡${NC} CONTADOR ONLINE USERS"
    echo -e " ${VERDE}[04]${NC} ${AMARILLO}➡${NC} INSTALADOR DE PROTOCOLOS"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -e " ${VERDE}[05]${NC} ${ROJO}[!] UPDATE / REMOVE${NC}  |  ${VERDE}[0]${NC} ${AMARILLO}➡${NC} SALIR"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Opcion : "
    read opcion

        case $opcion in
        1) control_usuarios ;; # Esta la programaremos luego
        2) 
            echo -e "${AMARILLO}🧹 Iniciando optimización...${NC}"
            sleep 1
            pkg clean # Limpia archivos temporales de paquetes
            echo -e "${VERDE}✅ Memoria de paquetes limpiada.${NC}"
            sleep 1
            echo -e "${VERDE}🚀 Sistema optimizado con éxito.${NC}"
            sleep 2
            menu_principal
            ;;
        0) 
            echo -e "${ROJO}Saliendo del panel... 👋${NC}"
            exit 0 
            ;;
        *) 
            echo -e "${ROJO}⚠️ Opción no válida.${NC}"
            sleep 1
            menu_principal 
            ;;
    esac

}

# Ejecutar el menú
menu_principal
