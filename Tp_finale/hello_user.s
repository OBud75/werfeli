.section .data
prompt:
    .asciz "Entrez votre nom : "
greeting:
    .asciz "Bonjour, "
newline:
    .asciz "\n"

.bss
    .lcomm name, 32

.section .text
.globl _start
_start:
    # Afficher le message de demande
    mov $4, %eax          # syscall: write
    mov $1, %ebx          # fd: stdout
    mov $prompt, %ecx     # adresse du message
    mov $17, %edx         # longueur du message
    int $0x80

    # Lire l'entrée utilisateur
    mov $3, %eax          # syscall: read
    mov $0, %ebx          # fd: stdin
    mov $name, %ecx       # buffer pour l'entrée
    mov $32, %edx         # taille maximum
    int $0x80

    # Nettoyer le retour à la ligne
    mov $name, %ecx
    mov %eax, %edx        # longueur de l'entrée
clean_input:
    dec %edx
    cmpb $10, (%ecx, %edx, 1)
    jne skip_clean
    movb $0, (%ecx, %edx, 1)
skip_clean:

    # Afficher "Bonjour, "
    mov $4, %eax          # syscall: write
    mov $1, %ebx          # fd: stdout
    mov $greeting, %ecx   # adresse du message
    mov $9, %edx          # longueur du message
    int $0x80

    # Afficher le nom
    mov $4, %eax          # syscall: write
    mov $1, %ebx          # fd: stdout
    mov $name, %ecx       # adresse du nom
    mov $32, %edx         # longueur maximale
    int $0x80

    # Afficher une nouvelle ligne
    mov $4, %eax          # syscall: write
    mov $1, %ebx          # fd: stdout
    mov $newline, %ecx    # adresse de la nouvelle ligne
    mov $1, %edx          # longueur
    int $0x80

    # Quitter le programme
    mov $1, %eax          # syscall: exit
    xor %ebx, %ebx        # code de sortie : 0
    int $0x80
