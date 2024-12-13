#include <stdio.h>

int main() {
    char name[50];

    printf("What's your name?: ");
    fgets(name, sizeof(name), stdin);  // Lit le nom de l'utilisateur

    printf("Hello, %s", name);  // Affiche le message
    return 0;
}
