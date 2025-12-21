if ($env:OS -ne "Windows_NT") {
    Write-Host "Ce script de sauvegarde utilise Robocopy et doit être exécuter sous Windows."
    exit
}

# Asks for the path of the folder to back up
Write-Host "[+] Chemin du dossier à sauvegarder (chemin absolu) :"
$directory_path = Read-Host

# If the folder exists, prompts the user to choose where it should be backed up
# If the folder does not exist, displays an error message indicating the path is invalid or missing, and restarts the script
if (Test-Path $directory_path -PathType Container) {    # Test-Path : returns true if the path exists and -PathType Container if it's a directory, for a file use Leaf
    Write-Host "Dossier trouvé. Où voulez-vous stocker la sauvegarde (chemin absolu) ?"
    $backup_path = Read-Host

    # Asks for confirmation of the chosen backup path
    Write-Host "[+] Vous avez choisi $backup_path comme chemin. Merci de le confirmer : [Y/N]"
    $confirmation_choice = Read-Host

    if ($confirmation_choice -eq "y" -or $confirmation_choice -eq "yes") {       # Checks if the user's input matches "y" or "yes" (in any case)
        if (Test-Path $backup_path -PathType Container) {
            # If the backup folder exists, the script doesn't need to create it
			Write-Host "Le chemin de sauvegarde existe déjà."
			Write-Host "Chemin de sauvegarde : $backup_path"
        }
        else {
            # If the backup folder doesn't exist, the script creates it
			Write-Host "Le chemin de sauvegarde est inexistant, création du dossier…"
			# Creates a folder at the path stored in $backup_path; if it fails, displays an error message and restarts the script.
            try {
                New-Item -ItemType Directory -Path $backup_path
            }
            catch {
                Write-Host "Erreur : impossible de créer '$backup_path'"
                Write-Host "Relancement du script..."

                powershell -NoProfile -File $PSCommandPath
                exit
            }
            Write-Host "Chemin de sauvegarde : $backup_path."
        }

        # Now that the folder is created, the script backs up the source folder to the new backup path
        # Build Robocopy argument list
        $robocopyArgs = @(
            $directory_path          # Source directory
            $backup_path             # Destination directory
            "/E"                     # Copy subdirectories, including empty ones
            "/COPY:DAT"              # Copy Data, Attributes, Timestamps
            "/R:3"                   # Retry up to 3 times on failure
            "/W:5"                   # Wait 5 seconds between retries
            "/ETA"                   # Display estimated time of arrival
        )
        # Run Robocopy
        & robocopy @robocopyArgs
        $exitCode = $LASTEXITCODE
        # Interpret Robocopy exit code
        if ($exitCode -lt 8) {
            Write-Host "Sauvegarde effectuée avec succès dans : $backup_path."
        }
        else {
            Write-Host "Erreur pendant le backup. Robocopy exit code: $exitCode"
            Write-Host "Relancement du script."
            
            powershell -NoProfile -File $PSCommandPath
            exit
        }

        # Asks the user if they want to back up another folder
        Write-Host "[+] Voulez-vous faire une sauvegarde d'un autre dossier ? [Y/N]"
        $another_choice = Read-Host
        if ($another_choice -eq "y" -or $another_choice -eq "yes") {
            Write-Host "Relancement du script."
            
            powershell -NoProfile -File $PSCommandPath
            exit
        }
        else {
            Write-Host "Fin du script."
            exit
        }
    }
    else {
        Write-Host "Relancement du script."
            
        powershell -NoProfile -File $PSCommandPath
        exit
    }
}
else {
    Write-Host "Le dossier n'a pas été trouvé, ou le chemin est incorrect."
    Write-Host "Relancement du script."

    powershell -NoProfile -File $PSCommandPath
    exit
}