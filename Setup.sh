#!/bin/bash

# --- COLORES ---
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARILLO='\033[1;33m'
ROJO='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- CONFIGURACIÓN ---
# Recuerda cambiar este link por tu link RAW de GitHub después de subirlo
URL_SCRIPT="https://raw.githubusercontent.com/arvislozano84-eng/-AMLE84/main/setup.sh"

# --- FUNCIÓN DE LOGIN (SEGURIDAD) ---
login_sistema() {
    clear
    echo -e "${AZUL}╔════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}   ${AMARILLO}🔐 ACCESO RESTRINGIDO - @amle84${NC}      ${AZUL}║${NC}"
    echo -e "${AZUL}╚════════════════════════════════════════╝${NC}"
    
    echo -n "👤 Usuario: "
    read user_login
    echo -n "🔑 Contraseña: "
    read -s pass_login
    echo ""

    # Verifica si el usuario y pass existen en el archivo
    if grep -q "^$user_login|$pass_login$" lista_usuarios.db; then
        echo -e "${VERDE}✅ Acceso concedido. Bienvenido $user_login.${NC}"
        sleep 2
        menu_principal
    else
        echo -e "${ROJO}❌ Datos incorrectos. Acceso denegado.${NC}"
        sleep 2
        exit
    fi
}

# --- GESTIÓN DE USUARIOS ---
control_usuarios() {
    clear
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}       ${VERDE}👤 GESTIÓN DE USUARIOS - @amle84${NC}        ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e " ${VERDE}[1]${NC} ${AMARILLO}➡️${NC} CREAR NUEVO USUARIO Y PASS"
    echo -e " ${VERDE}[2]${NC} ${AMARILLO}➡️${NC} VER LISTA DE CREDENCIALES"
    echo -e " ${VERDE}[3]${NC} ${AMARILLO}➡️${NC} ELIMINAR USUARIO"
    echo -e " ${VERDE}[0]${NC} ${AMARILLO}➡️${NC} VOLVER AL MENÚ"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Seleccione una opción: "
    read opt_user

    case $opt_user in
        1)
            echo -e "\n${CYAN}--- NUEVO REGISTRO ---${NC}"
            echo -n "📝 Nombre del usuario: "
            read new_name
            echo -n "🔑 Asigna una contraseña: "
            read new_pass
            echo "$new_name|$new_pass" >> lista_usuarios.db
            echo -e "${VERDE}✅ Usuario [$new_name] creado con éxito.${NC}"
            sleep 2; control_usuarios ;;
        2)
            echo -e "\n${CYAN}📋 USUARIOS Y CONTRASEÑAS:${NC}"
            if [ -s lista_usuarios.db ]; then
                echo -e "${AMARILLO} ID | USUARIO  | CONTRASEÑA ${NC}"
                echo -e "${AMARILLO}----------------------------${NC}"
                awk -F'|' '{printf " %02d | %-8s | %-10s\n", NR, $1, $2}' lista_usuarios.db
            else
                echo -e "${ROJO}No hay usuarios registrados.${NC}"
            fi
            echo -e "\nPresiona Enter para volver..."; read; control_usuarios ;;
        3)
            if [ -s lista_usuarios.db ]; then
                cat -n lista_usuarios.db
                echo -n "Número de ID a borrar: "
                read num; sed -i "${num}d" lista_usuarios.db
                echo -e "${VERDE}✅ Eliminado.${NC}"
            else
                echo -e "${ROJO}Lista vacía.${NC}"
            fi
            sleep 2; control_usuarios ;;
        0) menu_principal ;;
        *) control_usuarios ;;
    esac
}

# --- FUNCIÓN UPDATE ---
actualizar_script() {
    echo -e "${AMARILLO}⏳ Buscando actualizaciones...${NC}"
    wget -q -O setup.sh.tmp "$URL_SCRIPT"
    if [ $? -eq 0 ]; then
        mv setup.sh.tmp setup.sh
        chmod +x setup.sh
        echo -e "${VERDE}✅ Actualizado con éxito. Reiniciando...${NC}"
        sleep 2
        exec ./setup.sh
    else
        echo -e "${ROJO}❌ Error al descargar. Revisa tu conexión.${NC}"
    fi
}

# --- MENÚ PRINCIPAL ---
menu_principal() {
    clear
    echo -e "${AZUL}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${AZUL}║${NC}       ${AMARILLO}🚀 PANEL DE CONTROL - @amle84${NC}           ${AZUL}║${NC}"
    echo -e "${AZUL}╚══════════════════════════════════════════════════╝${NC}"
    echo -e " ${VERDE}[01]${NC} ➡️ GESTIÓN DE USUARIOS"
    echo -e " ${VERDE}[05]${NC} ➡️ ACTUALIZAR SISTEMA"
    echo -e " ${VERDE}[00]${NC} ➡️ SALIR"
    echo -e "${AZUL}════════════════════════════════════════════════════${NC}"
    echo -n " Opción: "
    read opcion

    case $opcion in
        1|01) control_usuarios ;;
        5|05) actualizar_script ;;
        0|00) exit ;;
        *) menu_principal ;;
    esac
}

# Iniciar con Login
if [ ! -f lista_usuarios.db ]; then
    # Si es la primera vez, crea un admin por defecto
    echo "admin|1234" > lista_usuarios.db
fi
login_sistema
