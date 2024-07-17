    .data
w:      .word 1920         # largura
h:      .word 1080         # altura

result: .word 0            # variável para armazenar o resultado da função prop

prop_msg: .asciiz "Proporção encontrada: "
prop_1:   .asciiz "16:9\n"
prop_2:   .asciiz "4:3\n"
prop_0:   .asciiz "Nenhuma proporção válida encontrada.\n"

    .text
    .globl main

main:
    lw $t0, w            # carrega largura (w) em $t0
    lw $t1, h            # carrega altura (h) em $t1

    # Calcula width * 9 e height * 16
    li $t2, 9
    mult $t0, $t2        # $t2 = $t0 * 9
    mflo $t2             # resultado da multiplicação em $t2

    li $t3, 16
    mult $t1, $t3        # $t3 = $t1 * 16
    mflo $t3             # resultado da multiplicação em $t3

    # Compara width * 9 == height * 16
    beq $t2, $t3, found_prop1   # se width * 9 == height * 16, vai para found_prop1

    # Calcula width * 3 e height * 4
    li $t4, 3
    mult $t0, $t4        # $t4 = $t0 * 3
    mflo $t4             # resultado da multiplicação em $t4

    li $t5, 4
    mult $t1, $t5        # $t5 = $t1 * 4
    mflo $t5             # resultado da multiplicação em $t5

    # Compara width * 3 == height * 4
    beq $t4, $t5, found_prop2   # se width * 3 == height * 4, vai para found_prop2

    # Se não encontrar nenhuma proporção válida
    j no_valid_prop

found_prop1:
    li $t6, 1            # retorna 1 (proporção 16:9)
    sw $t6, result       # armazena resultado em result
    j end_program

found_prop2:
    li $t7, 2            # retorna 2 (proporção 4:3)
    sw $t7, result       # armazena resultado em result
    j end_program

no_valid_prop:
    li $t8, 0            # retorna 0 (nenhuma proporção válida encontrada)
    sw $t8, result       # armazena resultado em result

end_program:
    # Imprime mensagem de proporção encontrada
    li $v0, 4
    la $a0, prop_msg
    syscall

    # Imprime resultado da função prop
    lw $a0, result       # carrega resultado em $a0

    li $v0, 1            # syscall para imprimir inteiro
    syscall

    # Imprime nova linha
    li $v0, 4
    la $a0, newline
    syscall

    # Termina o programa
    li $v0, 10
    syscall

