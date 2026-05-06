
#!/bin/bash

# --- CONFIGURACIÓN ---
# Reemplaza la URL de abajo con tu enlace RAW de GitHub cuando lo tengas listo
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

# Validación: Acepta @AMLE84 o lo que haya en tu GitHub
if [[ "$user_key" == "@AMLE84" ]] || curl -s "$URL_KEYS" | grep -qw "$user_key"; then
    echo -e "${VERDE}✅ ACCESO CONCEDIDO.${NC}"
    sleep 2
else
    echo -e "${ROJO}❌ KEY INVÁLIDA. Contacta a @amle84${NC}"
    exit 1
fi

# --- 2. FUNCIONES DE LAS OPCIONES ---

optimizador() {
    echo -e "\n${AMARILLO}🧹 Iniciando optimización de sistema...${NC}"
    pkg clean
    echo -e "${VERDE}✅ Caché de paquetes limpia.${NC}"
    sleep 2
}

instalador_python() {
    clear
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}      ${VERDE}🐍 INSTALADOR DE PYTHON - @amle84${NC}       ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "${AMARILLO}📦 Descargando e instalando Python y Pip...${NC}"
    
    pkg update -y
    pkg install python python-pip -y
    
    echo -e "\n${VERDE}✅ Python instalado con éxito.${NC}"
    python --version
    echo -e "${CYAN}Presiona Enter para volver...${NC}"
    read
}

# --- 3. DISEÑO DEL MENÚ PRINCIPAL ---
menu_principal() {
    clear
    # Datos de sistema
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
    echo -e " ${VERDE}[04]${NC} ${AMARILLO}➡${NC} INSTALADOR DE PYTHON"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -e " ${VERDE}[05]${NC} ${ROJO}[!] UPDATE / REMOVE${NC}  |  ${VERDE}[0]${NC} ${AMARILLO}➡${NC} SALIR"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Opcion : "
    read opcion

    case $opcion in
        1) echo -e "${VERDE}Función en desarrollo...${NC}"; sleep 2; menu_principal ;;
        2) optimizador; menu_principal ;;
        3) echo -e "${VERDE}Buscando usuarios online...${NC}"; sleep 2; menu_principal ;;
        4) instalador_python; menu_principal ;;
        0) echo -e "${ROJO}Saliendo... 👋${NC}"; exit 0 ;;
        *) echo -e "${ROJO}Opcion invalida${NC}"; sleep 1; menu_principal ;;
    esac
}

# Ejecutar el programa
menu_principal
