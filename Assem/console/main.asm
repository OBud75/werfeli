section .data
  input_msg db "type something:", 0xA
  input_msg_len equ $ - input_msg
  msg db "You typed: "
  msg_len equ $ - msg

section .bss
  buffer resb 128
  bytes_read resq 1          ; Stocker le nombre de caractères lus

section .text
  global _start

_start:
  ; Afficher le message d'invite
  mov rax, 1
  mov rdi, 1
  lea rsi, [input_msg]
  mov rdx, input_msg_len
  syscall

  ; Lire l'entrée utilisateur
  mov rax, 0
  mov rdi, 0
  lea rsi, [buffer]
  mov rdx, 128
  syscall
  mov [bytes_read], rax       ; Sauvegarder le nombre de caractères lus

  ; Afficher "You typed: "
  mov rax, 1
  mov rdi, 1
  lea rsi, [msg]
  mov rdx, msg_len
  syscall

  ; Réécrire uniquement les caractères lus
  mov rax, 1
  mov rdi, 1
  lea rsi, [buffer]
  mov rdx, [bytes_read]       ; Utiliser le nombre de caractères lus
  syscall

  ; Terminer le programme
  mov rax, 60
  xor rdi, rdi                ; Code de sortie 0
  syscall
