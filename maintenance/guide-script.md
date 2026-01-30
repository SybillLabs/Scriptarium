# 📘 Guide de l'utilisateur

![Statut](https://img.shields.io/badge/Statut-En%20cours-yellow?style=flat-square&logo=github)

![Bash](https://img.shields.io/badge/Script-Bash-orange?style=flat-square&logo=gnubash)
![Powershell](https://img.shields.io/badge/Script-PowerShell-blue?style=flat-square&logo=github)

![Logiciel](https://img.shields.io/badge/Editeur%20de%20script-VisualStudioCode-white?style=flat-square&logo=github)

## 🌍 Généralités

Ce guide explique les scripts que j’ai créés pour assurer la maintenance des systèmes d’exploitation de mon ordinateur.

* 🐧 Un script **Bash** pour mon système d’exploitation **Linux (Kubuntu)**
* 🪟 Un script **PowerShell** pour mon système d’exploitation **Windows (Windows 11 Famille)**

---

## ❓ Que doivent faire ces scripts ?

> ℹ️ Attention : il est possible qu’il y ait des similitudes entre les scripts.

### 🐧 Linux (Kubuntu)

Voici chaque étape de mon script Bash :

1. 📝 **Journalisation**  
   À chaque exécution du script, un fichier log est créé pour enregistrer l’ensemble des opérations de maintenance.

2. 🔄 **Mise à jour des dépôts Linux**  
   Vérifie les dépôts officiels d’Ubuntu afin de détecter si des mises à jour sont disponibles.

3. ⬆️ **Mise à jour des paquets Linux**  
   Installe les mises à jour des paquets trouvées à l’étape précédente.

4. 🧹 **Suppression des paquets inutiles**  
   Nettoie le système Linux des paquets et applications devenus inutiles.

5. 🖥️ **Recompilation des modules VMware**  
   J’utilise VMware Workstation pour la virtualisation. Après certaines mises à jour Linux, il arrive que les modules VMware soient à recompiler. Cette étape permet de vérifier leur état et de les recompiler si nécessaire.

6. 💾 **Vérification de l’espace disque**  
   Contrôle l’utilisation des disques (système et données) pour prévenir tout problème futur.

7. 🧠 **Vérification de la mémoire**  
   Comme j’utilise beaucoup la virtualisation, un suivi de la mémoire disponible est essentiel pour moi. Cette étape donne une visualisation rapide de l’état de la RAM.

### 🪟 Windows (Windows 11)

⚠️ **En cours de construction…**

---

## 📌 Les choses à savoir

### 🐧 Linux (Kubuntu)

Dans la première version du script, j’utilisais la commande **`apt`**.
Lorsque j’ai ajouté la commande **`tee`**, des *Warnings* s’affichaient, car je redirigeais à la fois `stdout` et `stderr`.

👉 Rien de grave en soi, mais je n’aime pas voir des *Warnings* dans mon terminal.
J’ai donc cherché à les masquer, et **ChatGPT m’a conseillé d’utiliser `apt-get`** pour les scripts. Résultat : plus de *Warnings* 🎉.

Mais quelle est la différence entre **`apt`** et **`apt-get`** ?

* `apt` → plus récent, pensé pour un usage **interactif** en terminal (affichage utilisateur amélioré).
* `apt-get` → plus **stable et fiable**, spécialement recommandé pour le **scripting et l’automatisation**.
* C’est une **bonne pratique** et c’est même **recommandé dans la documentation Debian & Ubuntu**.

📖 **Extrait du `man apt` (Debian/Ubuntu) :**

```
SCRIPT USAGE AND DIFFERENCES FROM OTHER APT TOOLS
       The apt(8) commandline is designed as an end-user tool and it may change behavior between versions. While it tries not to break backward
       compatibility this is not guaranteed either if a change seems beneficial for interactive use.

       All features of apt(8) are available in dedicated APT tools like apt-get(8) and apt-cache(8) as well.  apt(8) just changes the default value of
       some options (see apt.conf(5) and specifically the Binary scope). So you should prefer using these commands (potentially with some additional
       options enabled) in your scripts as they keep backward compatibility as much as possible.
```

---

### 🪟 Windows (Windows 11)

⚠️ **En cours de construction…**

