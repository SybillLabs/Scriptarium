# 📜 Scriptarium

![Statut](https://img.shields.io/badge/Statut-En%20perp%C3%A9tuelle%20%C3%A9volution-purple?style=flat-square&logo=github)
![FR](https://img.shields.io/badge/Langue-Fran%C3%A7ais-blue?style=flat-square&logo=github)

![Bash](https://img.shields.io/badge/Script-Bash-orange?style=flat-square&logo=gnubash)
![Powershell](https://img.shields.io/badge/Script-PowerShell-blue?style=flat-square&logo=github)
![Python](https://img.shields.io/badge/Script-Python-green?style=flat-square&logo=python)

![Logiciel](https://img.shields.io/badge/Editeur%20de%20script-VisualStudioCode-white?style=flat-square&logo=github)

## 📝 Contexte
Le **Scriptarium** me permettra de regrouper des scripts que j'ai travaillé, en équipe ou seule.  
Ces scripts seront écrits en **différents langages**, selon leur environnement cible :
- 🐧 **Bash** : 
  - *Système* : Linux & macOS
  - *Extension* : `sh`
  - *Rôle* : Langage de script pour automatiser des tâches système (commandes shell, gestion de fichiers, ...)
- 🪟 **PowerShell** : 
  - *Système* : Windows (mais fonctionne aussi sur Linux et macOS maintenant)
  - *Extension* : `.ps1`
  - *Rôle* : Langage et environnement pour administrer Windows (fichiers, services, registres, ...)
- 🐍 **Python** : 
  - *Système* : Universel, fonctionne sur **Windows, Linux, macOS** et même sur **Android, iOS, microcontrôleurs, ...**.
  - *Extension* : `.py`
  - *Rôle* : Langage **polyvalent** utilisé pour :
    - l'**automatisation système** et la **gestion d'infrastructure**
    - le **développement d'outils DevOps**
    - le **traitement de données** et les **scripts d'intégration (API, Cloud, CI/CD)**
    - ainsi que le **développement logiciel** (web, IA, ...)

## 📂 Organisation du dépôt
```
/
├── README.md
├── Dossier du script
│   └── script.sh
│   └── script.ps1
│   └── script.py
│   └── guide-script.md
│   └── Ressources
│       └── Files
├── Archives
```
👉 À chaque nouveau thème, un dossier dédié sera créé suivant cette structure.  
👉 Le dossier **Archives** servira à conserver les scripts plus anciens ou remplacés.  

## 🧰 Installation
Pour que les chemins relatifs utilisés dans certains scripts fonctionnent correctement, il est recommandé de **cloner ce dépôt dans le dossier `Documents`** de votre répertoire personnel.

### 🐧 Sous Linux / macOS
```bash
git clone https://github.com/SybillLabs/Scriptarium.git "$HOME/Documents/"
```

### 🪟 Sous Windows (PowerShell)
```powershell
git clone https://github.com/tonpseudo/scriptarium.git "$env:USERPROFILE\Documents\"
```

> Vous pouvez bien sûr choisir un autre emplacement.  
> Si c’est le cas, veillez simplement à **adapter les chemins** dans les scripts concernés (par exemple pour pointer vers les bons fichiers ou dossiers de sauvegarde).

## ☰ Sommaire
Cette section recense les fichiers `guide-script.md` des derniers scripts en date.

### [![FirstScript](https://img.shields.io/badge/First%20Script-Script%20de%20sauvegarde%20automatis%C3%A9e%20avec%20validation%20utilisateur-blue?style=social&logo=github)](/first-script/guide-script.md)
- Sauvegarde automatisée en **Bash** & en **PowerShell**
- Sauvegarde déclenchée via **menu interactif** avec validation utilisateur avant exécution des actions
- Script non dédié à une machine ou un environnement unique

### [![Maintenance](https://img.shields.io/badge/Maintenance-Script%20de%20maintenance%20syst%C3%A8me%20automatis%C3%A9e%20avec%20journalisation-blue?style=social&logo=github)](/maintenance/guide-script.md)
- Script de maintenance système en **Bash** & en **PowerShell**
- Gestion des mises à jours, du nettoyage et du contrôle des ressources
- Journalisation des actions élémentaire des erreurs

## ⚡ Prérequis
Pour utiliser ce dépôt, il est recommandé d’avoir :  
- 🐧 Des notions en **Bash** (Linux)  
- 🪟 Des notions en **PowerShell** (Windows)  
- 🐍 Des notions en **Python** (DevOps & scripting avancé)  
- 🖥️ Des connaissances en **virtualisation** pour tester les scripts avant une utilisation sur machine physique  

> Des prérequis spécifiques (modules Python, droits administrateur, etc.) seront indiqués directement dans les scripts concernés.  

## ⚠️ Avertissements
Ces scripts sont fournis **à titre éducatif** et ne sont pas forcément universels.  
➡️ Utilisez-les avec prudence et **testez toujours en environnement isolé avant un usage en production**. 

---

[![Profil](https://img.shields.io/badge/Back%20to-SybillLabs%20(Profil)-blue?style=social&logo=github)](https://github.com/SybillLabs)