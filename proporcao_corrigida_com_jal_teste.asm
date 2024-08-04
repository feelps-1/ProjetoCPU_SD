.data
   resultado:
      .asciiz "O resultado do teste de proporção é:\n"
   myarray:
      .align 2 # Array de inteiros
      .space 20 # Espaço para 4 inteiros
.text
main:
   addi $s0, $zero, 0
   addi $a0, $zero, 161 # Armazena largura da imagem em $a0
   sw $a0, myarray($s0)
   addi $a1, $zero, 90  # Armazena altura da imagem em $a1
   addi $s0, $s0, 4
   sw $a1, myarray($s0)
   addi $a2, $zero, 3 # Armazena constante 3 da proporcao 4:3 em $a2
   addi $s0, $s0, 4
   sw $a2, myarray($s0)
   addi $a3, $zero, 4 # Armazena constante 4 da proporcao 4:3 em $a3
   addi $s0, $s0, 4
   sw $a3, myarray($s0)
   jal teste_de_proporcao
   addi $s0, $s0, 4
   sw $v1, myarray($s0)
   li $v0, 4
   la $a0, resultado
   syscall
   li $v0, 1
   lw $a0, myarray($s0)
   syscall
   li $v0, 10
   syscall
teste_de_proporcao:
   mul $t0, $a0, $a2
   mul $t1, $a1, $a3
   beq $t0, $t1, prop_4_3
   mul $t2, $a2, $a2
   mul $t3, $a3, $a3
   mul $t0, $a0, $t2
   mul $t1, $a1, $t3
   beq $t0, $t1, prop_16_9
   addi $v1, $zero, 0
   jr $ra
   prop_4_3:
      addi $v1, $zero, 2
      jr $ra
   prop_16_9:
      addi $v1, $zero, 1
      jr $ra
