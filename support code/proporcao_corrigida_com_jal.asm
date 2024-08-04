   # Função principal:
main:
   # O registrador $zero é mantido sempre com valor igual a 0
   # add immediate: "addi $x, $y, n" é uma instrução que armazena em $x a adição do valor no registrador $y com o valor imediato n
   # Assim, podemos usar addi com $zero para armazenar um valor imediato em um registrador: 
   addi $a0, $zero, 161 # Armazena em $a0 a largura da imagem
   # Costuma-se usar os valores nos registradores $a0, $a1, $a2 e $a3 como argumentos da função que será chamada posteriormente
   addi $a1, $zero, 90  # Armazena em $a1 a altura da imagem
   addi $a2, $zero, 3 # Armazena em $a2 o valor 3, que será usado nos testes de proporção
   addi $a3, $zero, 4 # Armazena em $a3 o valor 4, que será usado nos testes de proporção
   
   # Costuma-se preservar os valores dos registradores $s0, $s1, ... e $s7s ao longo da função
   # Portanto, esses registradores são úteis para guardar endereços da memória de dados
   # No nosso caso de memória inicialmente vazia, podemos usar 0 como endereço base do array de memória
   addi $s0, $zero, 0 # Armazena em $s0 o valor 0 (endereço base da memória)
   
   # store word: "sw $x, n($y)" armazena o valor de $x no endereço de memória que fica n bytes após o endereço $y
   sw $a0, 0($s0) # Armazena o valor de $a0 no nosso endereço base da memória
   sw $a1, 4($s0) # Armazena o valor de $a1 em 4 bytes (isto é, 32 bits, ou 1 palavra) após o endereço base da memória
   sw $a2, 8($s0) # Armazena o valor de $a2 em 8 bytes (isto é, 64 bits, ou 2 palavras) após o endereço base da memória
   sw $a3, 12($s0) # Armazena o valor de $a3 em 12 bytes (isto é, 3 palavras) após o endereço base da memória
   
   # jump and link: "jal label" pula para a função com etiqueta label e salva o endereço do que seria a próxima instrução
   # O endereço da instrução que fica logo após o jal é armazenado no registrador especial $ra (return address)
   # Quando falamos do endereço de uma instrução, estamos nos referindo a um endereço da memória de instruções. 
   jal teste_de_proporcao # Chama a função que testa os tipos de proporções
      
   sw $v0, 16($s0) # Armazena o resultado do teste ($v0) em 4 palavras após o endereço base da memória
   
   jal loop_infinito # Finalizamos o programa com um loop infinito, pois a CPU não rodará outro programa e nem será desligada

loop_infinito:
   jr $ra # Repete o loop
   
   # Função que testa se 4:3 ou 16:9 bate com a proporção largura:altura da imagem:
teste_de_proporcao:
   # multiply: "mul $x, $y, $z" armazena em $x a multiplição do valor em $y com o valor em $z
   mul $t0, $a0, $a2 # Armazena em $t0 a multiplicação da largura ($a0) com 3 ($a2)
   # Os registradores $t0, $t1, ... e $t9 costumam ser usados como variáveis de valores temporários
   mul $t1, $a1, $a3 # Armazena em $t1 a multiplicação da altura ($a1) com 4 ($a3)
   
   # OBS: Como não multiplicaremos números tão grandes, o produto sempre caberá em 32-bits sem overflow
   # Em casos de números muito grandes, seria necessário usar a instrução mult em vez de mul
   
   # branch equal: "beq $x, $y, label" pula para a etiqueta label se os valores em $x e $y forem iguais
   beq $t0, $t1, prop_4_3 # Testa se 3*largura = 4*altura
   
   mul $t0, $t0, $a2 # Armazena em $t0 a multiplicação da largura com 9=3*3
   mul $t1, $t1, $a3 # Armazena em $t1 a multiplicação da altura com 16=4*4
   beq $t0, $t1, prop_16_9 # Testa se 9*largura = 16*altura
   
   # Se as dimensões largura e altura não passarem pelos testes, salvamos o resultado do teste como 0
   addi $v0, $zero, 0 # Armazena em $v0 o resultado do teste como sendo 0
   # Os registradores $v0 e $v1 são comumente usados para guardar os resultados de uma função
   
   # jump return: "jr $x" pula para a instrução cujo endereço está guardada em $x
   jr $ra # Pula para a instrução que fica logo após o "jal teste_de_proporcao"
   
   # Branch do caso 3*largura = 4*altura:
   prop_4_3:
      addi $v0, $zero, 2 # Armazena em $v0 o resultado do teste como sendo 2
      jr $ra # Pula para a instrução que fica logo após o "jal teste_de_proporcao"
   
   # Branch do caso 9*largura = 16*altura:
   prop_16_9:
      addi $v0, $zero, 1 # Armazena em $v0 o resultado do teste como sendo 1
      jr $ra # Pula para a instrução que fica logo após o "jal teste_de_proporcao"
