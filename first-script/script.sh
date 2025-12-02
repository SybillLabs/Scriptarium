#!/usr/bin/env bash

# Asks for the path of the folder to back up
echo "[+] Chemin du dossier à sauvegarder (Chemin absolu) :"
read -r directory_path

# If the folder exists, prompts the user to choose where it should be backed up
# If the folder does not exist, displays an error message indicating the path is invalid or missing, and restarts the script
if [[ -d "$directory_path" ]]	# -d : returns true if the path exists and is a directory
then
	echo "Dossier trouvé. Où voulez-vous stocker la sauvegarde (chemin absolu) ?"
	read -r backup_path
	# Asks for confirmation of the chosen backup path
	echo "[+] Vous avez choisi \"$backup_path\" comme chemin. Merci de le confirmer : [Y/N]"
	read -r confirmation_choice

	if [[ "$confirmation_choice" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]	# Checks if the user's input matches "y" or "yes" (in any case)
	then
		if [[ -d "$backup_path" ]]
		then
			# If the backup folder exists, the script doesn't need to create it
			echo "Le chemin de sauvegarde existe déjà."
			echo "Chemin de sauvegarde : \"$backup_path\"."
		else
			# If the backup folder doesn't exist, the script creates it
			echo "Le chemin de sauvegarde est inexistant, création du dossier…"
			# Creates a folder at the path stored in $backup_path; if it fails, displays an error message and restarts the script.
			mkdir -p "$backup_path" || { 
				echo "Erreur : impossible de créer \"$backup_path\""
				echo "Relancement du script..."
				sleep 2
				exec "$0"
			}
			echo "Chemin de sauvegarde : \"$backup_path\"."
		fi
		
		# Now that the folder is created, the script backs up the source folder to the new backup path
		if rsync -a --info=progress2 "$directory_path"/ "$backup_path"/	
		# The trailing slashes ensure that the contents of the source folder are copied into the destination folder, rather than the folder itself.
		# Using -a, rsync preserves metadata (permissions, timestamps, ownership, links, etc.) and, by default, overwrites existing files without interactive confirmation.
		then
			echo "Sauvegarde effectuée avec succès dans : \"$backup_path\"."
		else
			echo "Erreur pendant la sauvegarde."
			echo "Relancement du script."
			exec "$0"
		fi

		# Asks the user if they want to back up another folder
		echo "[+] Voulez-vous faire une sauvegarde d'un autre dossier ? [Y/N]"
		read -r another_choice
		if [[ "$another_choice" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]
		then
			echo "Relancement du script."
			exec "$0"  # Replaces the current process with a new instance of the script. Unlike "bash $HOME/Documents/Scriptarium/first-script/script.sh", it restarts the script without keeping the previous one running.
		else
			echo "Fin du script."
			exit 0
		fi
	else
		echo "Relancement du script."
		exec "$0"
	fi
else
	echo "Le dossier n'a pas été trouvé, ou le chemin est incorrect."
	echo "Relancement du script."
	exec "$0"
fi
