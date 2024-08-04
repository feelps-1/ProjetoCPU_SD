   # Fun��o principal:
main:
   # O registrador $zero � mantido sempre com valor igual a 0
   # add immediate: "addi $x, $y, n" � uma instru��o que armazena em $x a adi��o do valor no registrador $y com o valor imediato n
   # Assim, podemos usar addi com $zero para armazenar um valor imediato em um registrador: 
   addi $a0, $zero, 161 # Armazena em $a0 a largura da imagem
   # Costuma-se usar os valores nos registradores $a0, $a1, $a2 e $a3 como argumentos da fun��o que ser� chamada posteriormente
   addi $a1, $zero, 90  # Armazena em $a1 a altura da imagem
   addi $a2, $zero, 3 # Armazena em $a2 o valor 3, que ser� usado nos testes de propor��o
   addi $a3, $zero, 4 # Armazena em $a3 o valor 4, que ser� usado nos testes de propor��o
   
   # Costuma-se preservar os valores dos registradores $s0, $s1, ... e $s7s ao longo da fun��o
   # Portanto, esses registradores s�o �teis para guardar endere�os da mem�ria de dados
   # No nosso caso de mem�ria inicialmente vazia, podemos usar 0 como endere�o base do array de mem�ria
   addi $s0, $zero, 0 # Armazena em $s0 o valor 0 (endere�o base da mem�ria)
   
   # store word: "sw $x, n($y)" armazena o valor de $x no endere�o de mem�ria que fica n bytes ap�s o endere�o $y
   sw $a0, 0($s0) # Armazena o valor de $a0 no nosso endere�o base da mem�ria
   sw $a1, 4($s0) # Armazena o valor de $a1 em 4 bytes (isto �, 32 bits, ou 1 palavra) ap�s o endere�o base da mem�ria
   sw $a2, 8($s0) # Armazena o valor de $a2 em 8 bytes (isto �, 64 bits, ou 2 palavras) ap�s o endere�o base da mem�ria
   sw $a3, 12($s0) # Armazena o valor de $a3 em 12 bytes (isto �, 3 palavras) ap�s o endere�o base da mem�ria
   
   # jump and link: "jal label" pula para a fun��o com etiqueta label e salva o endere�o do que seria a pr�xima instru��o
   # O endere�o da instru��o que fica logo ap�s o jal � armazenado no registrador especial $ra (return address)
   # Quando falamos do endere�o de uma instru��o, estamos nos referindo a um endere�o da mem�ria de instru��es. 
   jal teste_de_proporcao # Chama a fun��o que testa os tipos de propor��es
      
   sw $v0, 16($s0) # Armazena o resultado do teste ($v0) em 4 palavras ap�s o endere�o base da mem�ria
   
   jal loop_infinito # Finalizamos o programa com um loop infinito, pois a CPU n�o rodar� outro programa e nem ser� desligada

loop_infinito:
   jr $ra # Repete o loop
   
   # Fun��o que testa se 4:3 ou 16:9 bate com a propor��o largura:altura da imagem:
teste_de_proporcao:
   # multiply: "mul $x, $y, $z" armazena em $x a multipli��o do valor em $y com o valor em $z
   mul $t0, $a0, $a2 # Armazena em $t0 a multiplica��o da largura ($a0) com 3 ($a2)
   # Os registradores $t0, $t1, ... e $t9 costumam ser usados como vari�veis de valores tempor�rios
   mul $t1, $a1, $a3 # Armazena em $t1 a multiplica��o da altura ($a1) com 4 ($a3)
   
   # OBS: Como n�o multiplicaremos n�meros t�o grandes, o produto sempre caber� em 32-bits sem overflow
   # Em casos de n�meros muito grandes, seria necess�rio usar a instru��o mult em vez de mul
   
   # branch equal: "beq $x, $y, label" pula para a etiqueta label se os valores em $x e $y forem iguais
   beq $t0, $t1, prop_4_3 # Testa se 3*largura = 4*altura
   
   mul $t0, $t0, $a2 # Armazena em $t0 a multiplica��o da largura com 9=3*3
   mul $t1, $t1, $a3 # Armazena em $t1 a multiplica��o da altura com 16=4*4
   beq $t0, $t1, prop_16_9 # Testa se 9*largura = 16*altura
   
   # Se as dimens�es largura e altura n�o passarem pelos testes, salvamos o resultado do teste como 0
   addi $v0, $zero, 0 # Armazena em $v0 o resultado do teste como sendo 0
   # Os registradores $v0 e $v1 s�o comumente usados para guardar os resultados de uma fun��o
   
   # jump return: "jr $x" pula para a instru��o cujo endere�o est� guardada em $x
   jr $ra # Pula para a instru��o que fica logo ap�s o "jal teste_de_proporcao"
   
   # Branch do caso 3*largura = 4*altura:
   prop_4_3:
      addi $v0, $zero, 2 # Armazena em $v0 o resultado do teste como sendo 2
      jr $ra # Pula para a instru��o que fica logo ap�s o "jal teste_de_proporcao"
   
   # Branch do caso 9*largura = 16*altura:
   prop_16_9:
      addi $v0, $zero, 1 # Armazena em $v0 o resultado do teste como sendo 1
      jr $ra # Pula para a instru��o que fica logo ap�s o "jal teste_de_proporcao"
