#!/bin/bash

# Demander le nom de base des fichiers
read -p "Entrez le nom de base pour les fichiers : " base_name

# Demander le nombre de fichiers à créer
read -p "Entrez le nombre de fichiers à créer : " number

# Boucle pour créer les fichiers
for (( i=1; i<=number; i++ ))
do
    file_name="${base_name}_${i}.txt"
    touch "$file_name"
    echo "Fichier créé : $file_name"
done
