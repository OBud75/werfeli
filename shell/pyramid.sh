#!/bin/bash

# Demander à l'utilisateur de saisir un nombre
read -p "Entrez le nombre de lignes de la pyramide : " n

# Boucle pour chaque ligne
for (( i=1; i<=n; i++ ))
do
    # Ajouter des espaces pour centrer les étoiles
    for (( j=i; j<n; j++ ))
    do
        echo -n " "
    done

    # Afficher les étoiles
    for (( k=1; k<=2*i-1; k++ ))
    do
        echo -n "*"
    done

    # Passer à la ligne suivante
    echo
done
