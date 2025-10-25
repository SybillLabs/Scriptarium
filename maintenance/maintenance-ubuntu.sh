#!/bin/bash
# Script d'entretien hebdomadaire
# Etant enregistré dans /usr/local/bin, le script peut être exécuté depuis n'importe quel dossier en tapant la commande weekly-maintenance.sh

# VARIABLES

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
TITLE='\033[30;43m'
NC='\033[0m' # Pas de couleur

# SCRIPTS
clear
# 0. Journalisation
echo -e "${BLUE}--- Journalisation de la maintenance ---${NC}"
sleep 1
LOGDIR="/var/log/weekly-maintenance"
sudo mkdir -p "$LOGDIR"                     # Création du dossier si inexistant
sudo chown $USER:$USER "$LOGDIR"            # Permet à l'utilisateur de l'utiliser
LOGFILE="$LOGDIR/LOG-$(date +%d-%m-%Y).log" # Enregistre le fichier sous la forme LOG-22-08-2025.log, c'est enregistré sous le format de date française
exec > >(tee -a "$LOGFILE") 2>&1
# Explication de la commande :
# 'exec' redirige toute la sortie du script (stdout et stderr) vers une autre commande ou un fichier.
# 'tee' duplique le flux : il l'affiche dans le terminal ET l'écrit dans le fichier de log.
# '-a' permet d'ajouter le texte au fichier au lieu de l'écraser.
# '2>&1' redirige stderr (erreurs) vers stdout pour que les deux soient traités ensemble.
# Résultat : toutes les sorties (normales et erreurs) s'affichent à l'écran et sont enregistrées dans $LOGFILE.
sleep 2

echo -e "${TITLE}=== [$(date)] Début de la maintenance ===${NC}"
sleep 1

# 1. Mise à jour des dépôts Linux
echo -e "${BLUE}--- Mise à jour des dépôts ---${NC}"
sleep 1
sudo apt-get update -y
sleep 2

# 2. Mise à jour des paquets
echo -e "${BLUE}--- Mise à jour des paquets trouvés ---${NC}"
sleep 1
sudo apt-get full-upgrade -y
sleep 2

# 3. Suppression des paquets inutiles
echo -e "${BLUE}--- Nettoyage des paquets inutiles  ---${NC}"
sleep 1
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sleep 2

# 4. Recompilation des modules VMware si nécessaire
echo -e "${BLUE}--- Vérification VMware  ---${NC}"
sleep 1
if [ ! -e /dev/vmmon ]; then
    echo -e "${RED}[VMware] Le module vmmon est absent → recompilation...${NC}"
    sudo vmware-modconfig --console --install-all
else
    echo -e "${GREEN}[VMware] Modules déjà en place, rien à faire.${NC}"
fi
sleep 2

# 5. Vérification de l'espace disque
echo -e "${BLUE}--- Vérification de l'espace disque ---${NC}"
sleep 1
df -h | grep -E '^/dev/' | while read line; do
  partition=$(echo $line | awk '{print $1}')          # Colonne 1 = nom de la partition
  used=$(echo $line | awk '{print $5}' | sed 's/%//') # Colonne 5 = % utilisé, on enlève le symbole %
  mountpoint=$(echo $line | awk '{print $6}')         # Colonne 6 = point de montage

    if [ "$used" -lt 70 ]; then     # Si c'est strictement inférieur (lesser than) à 70
        color=$GREEN
    elif [ "$used" -lt 80 ]; then   # Si c'est strictement inférieur (lesser than) à 80
        color=$YELLOW
    else                            # Sinon
        color=$RED
    fi

    echo -e "${color}${partition} (${mountpoint}) → ${used}% utilisé${NC}"
done
sleep 2

# 6. Vérification de la mémoire
echo -e "${BLUE}--- Vérification de la mémoire ---${NC}"
sleep 1
AVAIL=$(free -m | awk '/Mem:/ {print $7}') # Mémoire disponible (colonne 7) en MiB
TOTAL=$(free -m | awk '/Mem:/ {print $2}') # Mémoire total (colonne 2) en MiB
if [ "$AVAIL" -lt 2000 ]; then
  color=${RED}
  status="CRITIQUE"
elif [ "$AVAIL" -lt 10000 ]; then
  color=${YELLOW}
  status="FAIBLE"
else
  color=${GREEN}
  status="BIEN"
fi
echo -e "${color}[RAM] Disponible : ${AVAIL} Mi / ${TOTAL} Mi --> ${status}${NC}"
sleep 2

echo -e  "${TITLE}=== [$(date)] Maintenance terminée ===${NC}"
