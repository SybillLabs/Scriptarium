# 💻 Mes débuts dans le script Bash

![Scripting](https://img.shields.io/badge/Scripting-Automation-white?style=for-the-badge&logo=bitrise)
![Linux](https://img.shields.io/badge/OS-Linux-orange?style=for-the-badge&logo=linux)
![Bash](https://img.shields.io/badge/Langage-Bash-green?style=for-the-badge&logo=gnubash)

## 📝 Contexte

Dans le cadre de ma formation **Technicien Supérieur Systèmes et Réseaux**, j’ai eu à réaliser un exercice pratique consistant à développer un script Bash automatisant une procédure de sauvegarde.  
L’objectif était de mettre en œuvre les bases du scripting Bash tout en respectant un enchaînement logique d’étapes :
- 📂 Demander à l’utilisateur le dossier à sauvegarder  
- ❌ Vérifier l’existence du dossier, sinon afficher un message d’erreur  
- 💾 Demander l’emplacement de sauvegarde du fichier  
- ✅ Demander une confirmation avant la création de la sauvegarde  
- 🛠️ Créer le dossier de sauvegarde si nécessaire  
- 🎉 Afficher un message de réussite une fois la sauvegarde effectuée  
- 🔄 Proposer à l’utilisateur d’effectuer une autre sauvegarde  

## 📜 Script de la formation

Voici le script que j’ai développé dans le cadre de cet exercice.

```bash
#!/bin/bash

#Le script demande quel dossier l'utilisateur souhaite sauvegarder
echo "Quel le nom du dossier que vous voulez sauvegarder ?"
read nom_dossier
echo "Vous avez choisi le dossier $nom_dossier."

#Si le dossier n'existe pas, il affiche un message d'erreur
echo "Merci de mettre le chemin du dossier où vous voulez vérifier son existance :"
read directory_path
if [ -d "$directory_path/$nom_dossier" ];
then
	echo "Le dossier $nom_dossier est existant à $directory_path."
	echo "Voulez-vous relancer le script? [Y/N]"
	read confirmation0
		if [ $confirmation0 = "Y" ];
		then
			bash /home/mirhazka/Documents/script_bash/my_first_script.sh
		else
			echo "Le script se termine."
			exit
		fi
else
	echo "Le dossier $nom_dossier est inexistant à $directory_path."
fi

#Le script demande ensuite où sauvegarder le fichier
echo "Où souhaitez vous sauvegarder votre fichier ?"
read file_path
echo "Quel est le nom du dossier ?"
read name_directory

#Le script demande confirmation de sauvegarder à l'endroit choisit
echo "Vous avez choisi $file_path comme chemin. Merci de le confirmer [Y/N]"
read confirmation1

#Le cas échéant, le script créé le dossier
if [ $confirmation1 = "Y" ];
then
	mkdir $file_path/$name_directory
	echo "Votre dossier $name_directory a été créer à l'endroit suivant $file_path."
fi

#Le script affiche un message quand la sauvegarde est correctement effectuée
#Voir echo dans le if ci-dessus

#Le script demande si l'utilisateur veux sauvegarder un autre dossier
echo "Voulez-vous sauvegarder un autre dossier ?[Y/N]"
read confirmation2
if [ $confirmation2 = "Y" ];
then
	echo "Le script va être relancé."
	bash /home/mirhazka/Documents/script_bash/my_first_script.sh
else
	echo "Le script est fini."
	exit
fi

#Copier dans l'éditeur de code fourni le script, une fois conçu et testé sur son ordinateur
```

## ⚙️ Version actuelle
Vous pouvez consulter la version mise à jour du script [ici](/first-script/script.sh).  


### 🧩 Ce qui a changé et pourquoi  

- **Copie réelle des données** : passage d’une simple création de dossier à une **sauvegarde complète et automatisée** via `rsync -a --info=progress2`.  
  ➜ Assure une copie fidèle (droits, horodatages, liens symboliques) tout en affichant une **barre de progression** lisible pour l’utilisateur.

- **Sémantique de copie maîtrisée** : ajout d’un **slash final** sur la source et la destination  
  (`rsync -a --info=progress2 "$directory_path"/ "$backup_path"/`) afin de copier **le contenu** du dossier, et non le dossier lui-même.  
  ➜ Résultat attendu : les fichiers de `Pictures` se retrouvent directement dans `PicturesBackUp/`.

- **Robustesse des chemins** : **quotage systématique** des variables (`"$var"`) pour supporter les espaces, majuscules et caractères spéciaux.  
  ➜ Évite les erreurs d’interprétation et les copies incomplètes.

- **Création contrôlée du répertoire cible** : le script crée le dossier de sauvegarde uniquement si nécessaire via `mkdir -p`, avec gestion d’erreur claire.  
  ➜ Améliore la fiabilité et la transparence du processus.

- **Ergonomie améliorée** : confirmations explicites avant la copie et messages d’état à chaque étape.  
  ➜ Réduit les erreurs de saisie et rend le comportement plus prévisible pour l’utilisateur.

- **Relance propre** : utilisation de `exec "$0"` pour relancer le script sans empiler de processus Bash.  
  ➜ Meilleure gestion des ressources et comportement plus stable.

### ⚙️ Choix techniques  
- **`rsync`** choisi à la place de `cp` pour sa fiabilité, sa capacité de reprise et son affichage en temps réel (`--info=progress2`).  
- **Chemins absolus** exigés pour éviter toute ambiguïté et garantir la précision des opérations.  
- Structure de script basée sur des **conditions imbriquées claires** et des **retours utilisateur explicites**.

### 🚀 Pistes d’amélioration (prochaines itérations)  
- Accepter les saisies contenant `$HOME` ou `~` (expansion automatique après lecture).  
- Bloquer les sauvegardes dont la destination se situe à l’intérieur du dossier source (prévention des boucles de copie).  
- Ajouter des options avancées :  
  - `--dry-run` pour la simulation sans écriture,  
  - `--exclude` pour ignorer certains sous-dossiers,  
  - `--delete` pour un miroir strict entre source et destination.

> 💡 **Conclusion :**  
> Cette nouvelle version du script est **plus fiable, plus sûre et plus ergonomique**, tout en restant lisible pour un utilisateur en apprentissage.  
> Elle applique les **bonnes pratiques Bash** (quotage, contrôle de flux, modularité) et introduit une logique de sauvegarde réellement exploitable dans un contexte professionnel.

### 💻 Exemple d'exécution du script
```bash
sybill-labs @ cyphernyx in ~ [15:50:21]
$ ./Documents/Scriptarium/first-script/script.sh 
[+] Chemin du dossier à sauvegarder (Chemin absolu) :
/home/sybill-labs/Pictures
Dossier trouvé. Où voulez-vous stocker la sauvegarde (chemin absolu) ?
/home/sybill-labs/Documents/PicturesBackUp
[+] Vous avez choisi "/home/sybill-labs/Documents/PicturesBackUp" comme chemin. Merci de le confirmer : [Y/N]
y
Le chemin de sauvegarde est inexistant, création du dossier…
Chemin de sauvegarde : "/home/sybill-labs/Documents/PicturesBackUp".
    118.796.982 100%    1,03GB/s    0:00:00 (xfr#31, to-chk=0/33) 
Sauvegarde effectuée avec succès dans : "/home/sybill-labs/Documents/PicturesBackUp".
[+] Voulez-vous faire une sauvegarde d'un autre dossier ? [Y/N]
n
Fin du script.
```

### ⏳ Avant sauvegarde
![beforebackup](/first-script/Ressources/beforebackup.png)

### 💾 Après sauvegarde
![afterbackup](/first-script/Ressources/afterbackup.png)

---

👉 Retour au fichier [README](/README.md).