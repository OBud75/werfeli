#!/bin/bash


# Utilisation de ls et grep pour trouver les fichiers .txt et les renommer
for i in $(ls | grep '\.txt'); do
    mv "$i" "${i%.txt}.jpeg"
done

