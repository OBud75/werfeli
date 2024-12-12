#!/usr/bin/env bash

display_table(){
  local N=$1
  for i in {1..10}; do
    echo "$i * $N = $((i * N))"
  done
}

case "$1" in
  ''|*[!0-9]*)  # Vérifie si l'argument est vide ou contient des caractères non numériques
    echo "'$1' is not a valid number"
    ;;
  0)            # Gère spécifiquement le cas où l'entrée est 0
    echo "Multiplication by 0 results in all zeros."
    ;;
  *)            # Sinon, c'est un entier positif
    display_table "$1"
    ;;
esac
