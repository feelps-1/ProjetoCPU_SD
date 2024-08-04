# Inicialização dos registradores
addi $t0, $0, 213      # Armazena largura da imagem em $t0
addi $t1, $0, 60         # Armazena altura da imagem em $t1
addi $t2, $0, 9          # Armazena constante 9 da proporção 16:9 em $t2
addi $t3, $0, 16         # Armazena constante 16 da proporção 16:9 em $t3
addi $t4, $0, 3          # Armazena constante 3 da proporção 4:3 em $t4
addi $t5, $0, 4          # Armazena constante 4 da proporção 4:3 em $t5

# Armazena largura e altura na memória de dados
sw $t0, 0x1000($zero)   # Armazena largura (213) no endereço 0x1000
sw $t1, 0x1004($zero)   # Armazena altura (60) no endereço 0x1004

# Cálculos
mul $s0, $t0, $t2       # Multiplica largura($t0) por 9($t2) e guarda em $s0
mul $s1, $t1, $t3       # Multiplica altura($t1) por 16($t3) e guarda em $s1

# Armazena os resultados parciais na memória de dados
sw $s0, 0x1008($zero)   # Armazena o resultado da multiplicação (largura * 9) no endereço 0x1008
sw $s1, 0x100C($zero)   # Armazena o resultado da multiplicação (altura * 16) no endereço 0x100C

# Comparações
beq $s0, $s1, found_prop1 # Verifica se $s0 e $s1 têm valores iguais, se sim, a proporção é 16:9

mul $s0, $t0, $t4       # Multiplica largura($t0) por 3($t4) e guarda em $s0
mul $s1, $t1, $t5       # Multiplica altura($t1) por 4($t5) e guarda em $s1

# Armazena os resultados parciais na memória de dados
sw $s0, 0x1010($zero)   # Armazena o resultado da multiplicação (largura * 3) no endereço 0x1010
sw $s1, 0x1014($zero)   # Armazena o resultado da multiplicação (altura * 4) no endereço 0x1014

beq $s0, $s1, found_prop2 # Verifica se $s0 e $s1 têm valores iguais, se sim, a proporção é 4:3

# Finalização
j no_valid_prop

found_prop1:
    addi $s2, $0, 1      # Retorna 1 se a proporção for 16:9 e vai para o final do programa
    sw $s2, 0x1018
    j end_program

found_prop2:
    addi $s2, $0, 2      # Retorna 2 se a proporção for 4:3 e vai para o final do programa
    sw $s2, 0x1018
    j end_program

no_valid_prop:
    addi $s2, $0, 0      # Retorna 0 se não for nenhuma das proporções e vai para o final do programa
    sw $s2, 0x1018
    j end_program

end_program:
    j end_program        # Entra num loop infinito no final do programa