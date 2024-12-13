#!/bin/bash

# Demander le sujet de la page Wikipédia
read -p "Entrez le sujet de la page Wikipédia : " sujet

# Encoder le sujet pour l'URL
sujet_encoded=$(echo "$sujet" | sed 's/ /_/g')

# Construire l'URL de la page Wikipédia
url="https://fr.wikipedia.org/wiki/$sujet_encoded"


# Nom du fichier de sortie
output_file="${sujet}_wikipedia.txt"

# Récupérer le contenu de la page et le convertir en texte brut
curl -s "$url" | lynx -stdin -dump > "$output_file"

# Vérifier si le fichier a été créé
if [ -f "$output_file" ]; then
    echo "Le contenu de la page Wikipédia pour '$sujet' a été sauvegardé dans $output_file."
else
    echo "Une erreur s'est produite ou la page n'existe pas."
fi
