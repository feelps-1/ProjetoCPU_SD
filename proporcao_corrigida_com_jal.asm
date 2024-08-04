main:
   addi $s0, $zero, 0
   addi $a0, $zero, 161 # Armazena largura da imagem em $a0
   sw $a0, 0($s0)
   addi $a1, $zero, 90  # Armazena altura da imagem em $a1
   sw $a1, 4($s0)
   addi $a2, $zero, 3 # Armazena constante 3 da proporcao 4:3 em $a2
   sw $a2, 8($s0)
   addi $a3, $zero, 4 # Armazena constante 4 da proporcao 4:3 em $a3
   sw $a3, 12($s0)
   jal teste_de_proporcao
   sw $v0, 16($s0)
   jal loop_infinito
loop_infinito:
   jr $ra
teste_de_proporcao:
   mul $t0, $a0, $a2
   mul $t1, $a1, $a3
   beq $t0, $t1, prop_4_3
   mul $t2, $a2, $a2
   mul $t3, $a3, $a3
   mul $t0, $a0, $t2
   mul $t1, $a1, $t3
   beq $t0, $t1, prop_16_9
   addi $v0, $zero, 0
   jr $ra
   prop_4_3:
      addi $v0, $zero, 2
      jr $ra
   prop_16_9:
      addi $v0, $zero, 1
      jr $ra
