# 📘 Guide de l'utilisateur : Script de maintenance

![Statut](https://img.shields.io/badge/Statut-En%20cours-yellow?style=flat-square&logo=github)

![Bash](https://img.shields.io/badge/Script-Bash-orange?style=flat-square&logo=gnubash)
![Powershell](https://img.shields.io/badge/Script-PowerShell-blue?style=flat-square&logo=github)

![Logiciel](https://img.shields.io/badge/Editeur%20de%20script-VisualStudioCode-white?style=flat-square&logo=github)

## 📝 Contexte
Dans un environnement personnel et professionnel, la maintenance régulière des systèmes d’exploitation est essentielle afin de garantir leur stabilité, leurs performances et leur bon fonctionnement dans le temps.  
Cette maintenance comprend notamment la gestion des mises à jour, le nettoyage des éléments inutiles et la vérification de l’état général des ressources système.

Dans ce cadre, deux postes sont utilisés au quotidien :
- un poste personnel dédié au **gaming et au divertissement**, fonctionnant sous **Windows 11 Famille** ;
- un poste professionnel fonctionnant sous **Windows 11 Professionnel**, utilisé dans un contexte orienté systèmes et réseaux.

L’objectif initial était de disposer d’un **outil simple et maîtrisé** permettant :
- de garder un contrôle sur les mises à jour du système,
- d’effectuer un nettoyage régulier,
- et de réaliser un check-up rapide des ressources matérielles (disque, mémoire, charge système).

Afin d’unifier cette approche et de renforcer la cohérence avec un parcours orienté **infrastructure systèmes et réseaux**, cette logique de maintenance a également été adaptée à un système **Linux**, à l’aide d’un script écrit en **Bash**.

Ainsi, deux scripts de maintenance ont été conçus :
- un script **PowerShell** pour les systèmes Windows 11 (Famille et Professionnel),
- un script **Bash** pour les systèmes Linux.

Bien que les langages et les outils diffèrent selon le système d’exploitation, les scripts reposent sur une **logique commune**, basée sur des étapes de maintenance identiques et des commandes natives à chaque environnement.


## 📋 Étapes communes des scripts de maintenance

> Les deux scripts mettent en œuvre une **gestion élémentaire des erreurs** (Bash / PowerShell). En cas d’échec d’une commande, l’erreur est consignée dans le fichier de **journalisation**, afin d’assurer la traçabilité de l’exécution.

### 📝 Etape 1 : Journalisation
- Les fichiers de journalisation sont enregistrés dans un répertoire dédié :
    - sous Linux : `var/log/maintenance`
    - sous Windows : `C:\Logs\Maintenance`
- Chaque exécution du script génère un fichier de log nommé selon le format suivant : `LOG-DD-MM-YYYY.log`.
- Le fichier de journalisation contient l’ensemble des sorties du script, incluant les messages d’information ainsi que les éventuelles erreurs, afin d’assurer la traçabilité de l’exécution.

### 🔐 Etape 2 : Vérification des droits administrateur
- Le script vérifie qu'il est exécuté avec des droits administrateur.
- Si l'utilisateur ne dispose pas des privilèges nécessaires :
    - un message d'erreur est affiché indiquant que le script doit être relancé avec des droits administrateur ;
    - le script s'arrête automatiquement.
- Cette vérification garantit que l'ensemble des opérations de maintenance peut être exécuté correctement.

### 🔄 Etape 3 : Mise à jour du système
- Le script vérifie la disponibilité de mises à jour, puis déclencheur leur installation via des commandes en ligne, propres à chaque environnement :
    - Sous Linux : 
        - Recherche des mises à jour : `apt update`
        - Installation des mises à jour : `apt upgrade`
    - Sous Windows :
        - Le script s'appuie sur le module **PSWindowsUpdate** afin de piloter Windows Update **sans interface graphique**.
        - Recherche de mises à jour : `Get-WindowsUpdate`
        - Installation des mises à jours : `Install-WindowsUpdate`
- Cette étape permet d'effectuer les mises à jour du système de manière automatisée et contrôlée, à l'initiative de l'utilisateur.

#### ℹ️ Remarque – Module PSWindowsUpdate
Le module **PSWindowsUpdate** n’est pas intégré par défaut à Windows. Il doit être présent sur la machine afin de pouvoir utiliser les commandes `Get-WindowsUpdate` et `Install-WindowsUpdate`.

``` powershell
# Vérification de la présence du module. La présence du module peut être vérifiée à l’aide de la commande suivante :
Get-Module -ListAvailable -Name PSWindowsUpdate
# Si une sortie s’affiche, le module est installé. Sinon le module n’est pas présent sur le système.

# Installation du module (si nécessaire) en administrateur
Install-Module -Name PSWindowsUpdate -Force
# Lors de la première installation, PowerShell peut demander d’autoriser l’utilisation d’un dépôt non approuvé. Dans ce cas, il convient de répondre O (Oui).

# Chargement du module dans la session. Le module peut être installé sans être chargé automatiquement dans la session courante. Il est donc recommandé de le charger explicitement à l’aide de la commande suivante :  
Import-Module PSWindowsUpdate

# La présence du module peut ensuite être confirmée en relançant la commande :  
Get-Module -ListAvailable -Name PSWindowsUpdate
```

### 🧹 Etape 4 : Nettoyage du système
- Le script effectue un nettoyage du système sous plusieurs aspects, en fonction du système d'exploitation :
    - Sous Linux :
        - Suppression des paquets installés automatiquement et devenus inutiles à l'aide de la commande :  
            `apt autoremove`
        - Suppressions des fichiers `.deb`obsolètes, tout en conservant ceux encore téléchargeables, à l'aide de la commande :  
            `apt autoclean`
    - Sous Windows : 
        - Nettoyage des fichiers temporaires de l'utilisateur :  
            `Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue`
        - Nettoyage des fichiers temporaires système : 
            `Remove-Item -Path C:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue`
        - Nettoyage du cache **Windows Update** :  
```PowerShell
Stop-Service -Name wuauserv -Force
Remove-Item -Path C:\Windows\SoftwareDistribution\Download\* -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv
```

### 💾 Etape 5 : Vérification de l'espace disque
- Le script effectuera un inventaire des disques, des volumes et des partitions ainsi que l'état de montage.
- Pour chaque volume et point de montage, le script collectera et fera une liste :
    - L'identifiant *volume label* pour **Windows** et *LABEL* pour **Linux**. Bonus pour **Linux**, son *UUID* s'il est disponible.
    - Le point de montage pour **Linux** et la *lettre et chemin* pour **Windows**.
    - Le type de système de fichier (**FS**) : *ext4*, *ntfs*, *fat32*, ...
    - La taille totale, libre, utilisé, et le % utilisé.
- Pour finir le script affichera un seuil d'alerte :
    - Stockages < 80% : OK
    - Stockages > 80% : Warnning
    - Stockages > 90% : Critique

### 🧠 Etape 6 : Vérification de la mémoire

### 🖥️ Etape 7 : Vérification simple de la charge système

---

[![README](https://img.shields.io/badge/Back%20to-Scriptarium-blue?style=social&logo=github)](/README.md)