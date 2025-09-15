# 💻 Mon premier script Bash
## 📌 Présentation

L’objectif est de créer un script de sauvegarde respectant les étapes suivantes :
- 📂 Demander à l’utilisateur quel dossier il souhaite sauvegarder
- ❌ Vérifier si le dossier existe, sinon afficher un message d’erreur
- 💾 Demander ensuite l’emplacement où sauvegarder le fichier
- ✅ Demander une confirmation avant de sauvegarder dans l’emplacement choisi
- 🛠️ Créer le dossier si nécessaire
- 🎉 Afficher un message lorsque la sauvegarde a été réalisée avec succès
- 🔄 Proposer à l’utilisateur de sauvegarder un autre dossier

## 📝 Le script

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
