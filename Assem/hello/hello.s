.global _start
.intel_syntax noprefix

_start:
  # Write console
  mov rax, 1
  mov rdi, 1
  lea rsi, [hello_ptr] # Adresse de la chaîne
  mov rdx, hello_size  # Taille de la chaîne
  syscall

  # Exit
  mov rax, 60
  xor rdi, rdi         # Code de retour 0
  syscall

hello_ptr:
  .asciz "Hello world\n"

# Calcul automatique de la taille
.equ hello_size, .-hello_ptr
