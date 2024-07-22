main:
    addi $t0, $t0, 213 # Armazena largura da imagem em $t0
    addi $t1, $t1, 60  # Armazena altura da imagem em $t1

    addi $t2, $t2, 9 # Armazena constante 9 da proporção 16:9 em $t2
    mul $s0, $t0, $t2 # Multiplica largura($t0) por 9($t2) e guarda em $s0                

    addi $t3, $t3, 16 # Armazena constante 16 da proporção 16:9 em $t3
    mul $s1, $t1, $t3 # Multiplica altura($t1) por 16($t3) e guarda em $s1        

    beq $s0, $s1, found_prop1 # Verifica se $s0 e $s1 tem valores iguais, se sim, a proporção é 16:9  

    addi $t4, $t4, 3 # Armazena constante 3 da proporção 4:3 em $t4
    mul $s0, $t0, $t4 # Multiplica largura($t0) por 3($t4) e guarda em $s0                 

    addi $t5, $t5, 4 # Armazena constante 4 da proporção 4:3 em $t5
    mul $s1, $t1, $t5 # Multiplica altura($t1) por 4($t5) e guarda em $s1                   

    beq $s0, $s1, found_prop2 # Verifica se $s0 e $s1 tem valores iguais, se sim, a proporção é 4:3   
 
    j no_valid_prop # Se nenhuma dessas condições for real, vai para no_valid_prop

found_prop1:
    addi $s2, $s2, 1 # Retorna 1 se a proporção for 16:9 e vai para o final do programa                
    j end_program

found_prop2:
    addi $s2, $s2, 2 # Retorna 2 se a proporção for 4:3 e vai para o final do programa                
    j end_program

no_valid_prop:
    addi $s2, $s2, 0 # Retorna 0 se não for nenhuma das proporções e vai para o final do programa
    j end_program                  

end_program:
    j end_program # Entra num loop infinito do final do programa
