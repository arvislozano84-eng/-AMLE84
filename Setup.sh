#!/bin/bash

# --- CONFIGURACIÓN ---
URL_KEYS="https://raw.githubusercontent.com/arvislozano84-eng/-AMLE84/refs/heads/main/keys.txt"
URL_SCRIPT="https://raw.githubusercontent.com/arvislozano84-eng/-AMLE84/refs/heads/main/Setup.sh"

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

if [[ "$user_key" == "@AMLE84" ]] || curl -sL "$URL_KEYS" | grep -qw "$user_key"; then
    echo -e "${VERDE}✅ ACCESO CONCEDIDO.${NC}"
    sleep 1
else
    echo -e "${ROJO}❌ KEY INVÁLIDA. Contacta a @amle84${NC}"
    exit 1
fi

# --- 2. FUNCIONES ---

control_usuarios() {
    clear
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}       ${VERDE}👤 GESTIÓN DE USUARIOS - @amle84${NC}        ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e " ${VERDE}[1]${NC} ${AMARILLO}➡${NC} CREAR NUEVO USUARIO"
    echo -e " ${VERDE}[2]${NC} ${AMARILLO}➡${NC} LISTAR USUARIOS REGISTRADOS"
    echo -e " ${VERDE}[3]${NC} ${AMARILLO}➡${NC} ELIMINAR USUARIO"
    echo -e " ${VERDE}[0]${NC} ${AMARILLO}➡${NC} VOLVER AL MENÚ"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Seleccione una opción: "
    read opt_user

    case $opt_user in
        1)
            echo -n "📝 Nombre del nuevo usuario: "
            read new_name
            echo "$new_name" >> lista_usuarios.db
            echo -e "${VERDE}✅ Usuario $new_name guardado.${NC}"
            sleep 2; control_usuarios ;;
        2)
            echo -e "\n${CYAN}📋 LISTA DE USUARIOS:${NC}"
            if [ -f lista_usuarios.db ] && [ -s lista_usuarios.db ]; then
                echo -e "${AMARILLO}--------------------------------${NC}"
                cat -n lista_usuarios.db
                echo -e "${AMARILLO}--------------------------------${NC}"
            else
                echo -e "${ROJO}La lista está vacía.${NC}"
            fi
            echo -e "\n${AMARILLO}Presiona Enter para volver...${NC}"
            read; control_usuarios ;;
        3)
            if [ -f lista_usuarios.db ] && [ -s lista_usuarios.db ]; then
                echo -e "\n${ROJO}--- ELIMINAR USUARIO ---${NC}"
                cat -n lista_usuarios.db
                echo -n "Escribe el NÚMERO del usuario a borrar: "
                read num_borrar
                
                # Obtener el nombre para confirmar
                USER_NAME=$(sed -n "${num_borrar}p" lista_usuarios.db)
                
                if [ -z "$USER_NAME" ]; then
                    echo -e "${ROJO}Número inválido.${NC}"
                else
                    echo -n "⚠️ ¿Borrar a $USER_NAME? (s/n): "
                    read confirmar
                    if [[ "$confirmar" == "s" || "$confirmar" == "S" ]]; then
                        sed -i "${num_borrar}d" lista_usuarios.db
                        echo -e "${VERDE}✅ Usuario eliminado.${NC}"
                    else
                        echo -e "${AMARILLO}Operación cancelada.${NC}"
                    fi
                fi
            else
                echo -e "${ROJO}No hay usuarios para eliminar.${NC}"
            fi
            sleep 2; control_usuarios ;;
        0) menu_principal ;;
        *) echo -e "${ROJO}Opción inválida${NC}"; sleep 1; control_usuarios ;;
    esac
}

optimizador() {
    echo -e "\n${AMARILLO}🧹 Optimizando sistema...${NC}"
    pkg clean
    echo -e "${VERDE}✅ Limpieza completada.${NC}"
    sleep 2
}

contador_online() {
    clear
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}       ${VERDE}👥 USUARIOS CONECTADOS - @amle84${NC}        ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    CONEXIONES=$(ps -ef | grep -v grep | grep -c "bash")
    echo -e "\n ${CYAN}📊 Sesiones activas:${NC} ${AMARILLO}$CONEXIONES${NC}"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    ps -ef | grep "bash" | grep -v grep | awk '{print " • ID: " $2 " | Hora: " $5}'
    echo -e "\n${AMARILLO}Presiona Enter para volver...${NC}"
    read
}

instalador_python() {
    clear
    echo -e "${AMARILLO}📦 Instalando Python...${NC}"
    pkg update -y && pkg install python -y
    echo -e "\n${VERDE}✅ Proceso terminado.${NC}"
    sleep 2
}

actualizar_script() {
    echo -e "${AMARILLO}🔄 Actualizando...${NC}"
    wget -O setup.sh "$URL_SCRIPT" &> /dev/null
    chmod +x setup.sh
    ./setup.sh
    exit
}

# --- 3. MENÚ PRINCIPAL ---
menu_principal() {
    clear
    MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
    MEM_USADA=$(free -m | grep Mem | awk '{print $3}')
    
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}  ${VERDE}🛡️  INSTALADOR OFICIAL @amle84${NC}  ${AZUL}║${NC}"
    echo -e "${AZUL}║${NC}        ${CYAN}Versión V1.0 - Panel de Control${NC}        ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN} 🔹 S.O:${NC} Android  ${CYAN}🔹 IP:${NC} $(curl -s https://ifconfig.me)"
    echo -e "${CYAN} 🔹 RAM:${NC} ${MEM_USADA}MB / ${MEM_TOTAL}MB  ${CYAN}🔹 FECHA:${NC} $(date +'%d/%m/%Y')"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -e " ${VERDE}[01]${NC} ${AMARILLO}➡${NC} CONTROL USUARIOS"
    echo -e " ${VERDE}[02]${NC} ${AMARILLO}➡${NC} [!] OPTIMIZAR VPS"
    echo -e " ${VERDE}[03]${NC} ${AMARILLO}➡${NC} CONTADOR ONLINE USERS"
    echo -e " ${VERDE}[04]${NC} ${AMARILLO}➡${NC} INSTALADOR DE PYTHON"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -e " ${VERDE}[05]${NC} ${ROJO}[!] UPDATE${NC}  |  ${VERDE}[0]${NC} ${AMARILLO}➡${NC} SALIR"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Opcion : "
    read opcion

    case $opcion in
        1) control_usuarios ;;
        2) optimizador; menu_principal ;;
        3) contador_online; menu_principal ;;
        4) instalador_python; menu_principal ;;
        5) actualizar_script ;;
        0) exit 0 ;;
        *) menu_principal ;;
    esac
}

menu_principal
