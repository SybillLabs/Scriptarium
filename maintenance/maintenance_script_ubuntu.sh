#!/usr/bin/env bash
# This script is used to perform maintenance tasks on an Ubuntu system.
# It should be run with root privileges.
# Should be run on a regular basis to keep the system up to date and clean.
# Should be save in /usr/local/bin/maintenance_script_ubuntu.sh and made executable.

# Version 1.0

# Variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'
LOGDIR="/var/log/maintenance"
LOGFILE="${LOGDIR}/maintenance_$(date +%Y-%m-%d).log"

# Functions

function check_root {
    # Vérifie que l'utilisateur qui lance le script est root (EUID = 0)
    # EUID = Effective User ID (ID utilisateur effectif)
    if [ "$EUID" -ne 0 ]; then
        # Si EUID n'est pas égal à 0, l'utilisateur n'est pas root
        # Affiche un message d'erreur en rouge
        echo -e "${RED}Erreur: Ce script doit être exécuté en tant que root.${NC}"
        # Quitte le script avec le code d'erreur 1 (indique une erreur)
        exit 1
    fi
    # Si on arrive ici, c'est que l'utilisateur est root
    # Affiche un message de confirmation en vert
    echo -e "${GREEN}Vérification OK: Vous êtes root. Le script va s'exécuter.${NC}"
}

function logs {
    # Configure la journalisation pour rediriger tous les affichages dans un fichier log
    # Les couleurs seront affichées à l'écran mais retirées du fichier log
    
    # Crée le répertoire de log s'il n'existe pas
    mkdir -p "${LOGDIR}"
    
    # Redirige tous les affichages (stdout et stderr) vers:
    # 1. L'écran (via tee) pour voir en temps réel avec les couleurs ANSI
    # 2. Un fichier log (avec sed) pour supprimer les codes couleurs et garder un log lisible
    # exec remplace le shell courant, donc cette redirection s'applique à tout le script
    exec > >(tee -a >(sed 's/\x1b\[[0-9;]*m//g' >> "${LOGFILE}")) 2>&1
}

function update_system {
    # Met à jour le système Ubuntu en deux étapes
    # 1. Récupère les derniers paquets disponibles
    # 2. Met à jour les paquets installés
    
    # Récupère la liste des derniers paquets disponibles auprès des serveurs
    echo -e "${YELLOW}Mise à jour de la liste des paquets...${NC}"
    apt-get update
    
    # Met à jour tous les paquets installés vers leur dernière version disponible
    echo -e "${YELLOW}Mise à jour des paquets installés...${NC}"
    apt-get upgrade -y
}

function clean_system {
    # Nettoie le système Ubuntu en supprimant les paquets et fichiers inutiles
    # 1. Supprime les paquets orphelins (dépendances obsolètes)
    # 2. Supprime le cache des vieilles versions de paquets
    
    # Supprime les paquets qui ne sont plus nécessaires (orphelins et dépendances inutiles)
    echo -e "${YELLOW}Nettoyage des paquets inutiles...${NC}"
    apt-get autoremove -y
    
    # Supprime le cache des anciens paquets pour libérer de l'espace disque
    # Garde le cache des versions actuelles au cas où on devrait les réinstaller
    echo -e "${YELLOW}Nettoyage du cache des paquets...${NC}"
    apt-get autoclean -y
}

function check_disk_space {
    # Vérifie l'espace disque disponible sur toutes les partitions montées en utilisant df
    # - Exclut les pseudo-systèmes de fichiers (tmpfs, devtmpfs, overlay, squashfs, ...)
    # - Affiche : filesystem (type) mountpoint → used / size (percent utilisé) — STATUT
    # Seuils : OK < 80%, WARNING >= 80% & < 90%, CRITIQUE >= 90%

    df -hT | grep -E -v '^(tmpfs|devtmpfs|overlay|squashfs|sysfs|proc|cgroup|udev)\b' | sed 1d | while read -r filesystem fstype size used avail usep mountpoint; do
        # Nettoie le pourcentage (retire le %)
        usep_num=$(echo "$usep" | sed 's/%//')

        # Détermine la couleur et le statut selon les seuils du guide
        if [ "$usep_num" -lt 80 ]; then
            color=$GREEN
            status="OK"
        elif [ "$usep_num" -lt 90 ]; then
            color=$YELLOW
            status="WARNING"
        else
            color=$RED
            status="CRITIQUE"
        fi

        # Affiche les informations formatées
        echo -e "${color}${filesystem} (${fstype}) ${mountpoint} → ${used} / ${size} (${usep_num}% utilisé) — ${status}${NC}"
    done
}

function check_memory {
    # Vérifie l'utilisation de la mémoire (RAM) en s'appuyant sur MemAvailable (conforme au guide)
    # Calcul: used_percent = (1 - MemAvailable / MemTotal) * 100
    # Seuils : OK < 70%, WARNING >= 70% & < 80%, CRITIQUE >= 80%

    # Récupère les valeurs en kB depuis /proc/meminfo
    mem_total_kb=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
    mem_avail_kb=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)

    # Si MemAvailable n'est pas trouvé (très ancien noyau), fallback sur free
    if [ -z "$mem_avail_kb" ] || [ -z "$mem_total_kb" ]; then
        # Utilise free en MiB
        total_mb=$(free -m | awk '/Mem:/ {print $2}')
        avail_mb=$(free -m | awk '/Mem:/ {print $7}')
        percent_used=$(awk -v t="$total_mb" -v a="$avail_mb" 'BEGIN{printf "%.0f", (1 - a/t)*100}')
        total_display="${total_mb} Mi"
        avail_display="${avail_mb} Mi"
    else
        # Calcul en kB -> convertit en MiB pour l'affichage
        total_mb=$((mem_total_kb/1024))
        avail_mb=$((mem_avail_kb/1024))
        percent_used=$(awk -v t="$mem_total_kb" -v a="$mem_avail_kb" 'BEGIN{printf "%.0f", (1 - a/t)*100}')
        total_display="${total_mb} Mi"
        avail_display="${avail_mb} Mi"
    fi

    # Détermine la couleur et le statut selon les seuils
    if [ "$percent_used" -lt 70 ]; then
        color=$GREEN
        status="OK"
    elif [ "$percent_used" -lt 80 ]; then
        color=$YELLOW
        status="WARNING"
    else
        color=$RED
        status="CRITIQUE"
    fi

    # Affiche les informations mémoire
    echo -e "${color}Mémoire → Disponible : ${avail_display} / Totale : ${total_display} — ${percent_used}% utilisé — ${status}${NC}"
}

function check_system_load {
    # Vérifie la charge système (1 min) et la compare à la capacité CPU
    # Calcul du pourcentage de charge : (load1 / nombre_coeurs) * 100
    # Seuils (conformes au guide) :
    # - OK : < 70%
    # - WARNING : >= 70% et < 90%
    # - CRITIQUE : >= 90%

    # Récupère la charge moyenne 1,5,15 minutes depuis /proc/loadavg
    read load1 load5 load15 _ < /proc/loadavg

    # Nombre de cœurs logiques
    cores=$(nproc)

    # Calcul du pourcentage de charge (arrondi)
    percent=$(awk -v l="$load1" -v c="$cores" 'BEGIN{printf "%.0f", (l/c)*100}')

    # Détermine le statut et la couleur selon les seuils
    if [ "$percent" -lt 70 ]; then
        color=$GREEN
        status="OK"
    elif [ "$percent" -lt 90 ]; then
        color=$YELLOW
        status="WARNING"
    else
        color=$RED
        status="CRITIQUE"
    fi

    # Affiche le résultat (charge 1 min, 5 min, 15 min, nombre de cœurs et pourcentage)
    echo -e "${color}Charge système → ${load1} (1m), ${load5} (5m), ${load15} (15m) — Cœurs: ${cores} — ${percent}% (${status})${NC}"
}

# Script execution
echo -e "${GREEN}--- Démarrage de la maintenance ---${NC}"

echo -e "${BLUE}--- Vérification des privilèges root ---${NC}"
check_root
sleep 1

echo -e "${BLUE}--- Journalisation active ---${NC}"
echo -e "${YELLOW}--- Les actions de maintenance seront enregistrées dans ${LOGDIR} ---${NC}"
logs
sleep 1

echo -e "${BLUE}--- Mise à jour du système ---${NC}"
update_system
sleep 1

echo -e "${BLUE}--- Nettoyage du système ---${NC}"
clean_system
sleep 1

echo -e "${BLUE}--- Vérification de l'espace disque ---${NC}"
check_disk_space
sleep 1

echo -e "${BLUE}--- Vérification de la mémoire ---${NC}"
check_memory
sleep 1

echo -e "${BLUE}--- Vérification simple de la charge système ---${NC}"
check_system_load
sleep 1

echo -e "${GREEN}--- Maintenance terminée ---${NC}"