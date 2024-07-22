main:
    addi $t0, $t0, 213
    addi $t1, $t1, 60  

    addi $t2, $t2, 9
    mul $s0, $t0, $t2                

    addi $t3, $t3, 16
    mul $s1, $t1, $t3      

    beq $s0, $s1, found_prop1  

    addi $t4, $t4, 3
    mul $s0, $t0, $t4                

    addi $t5, $t5, 4
    mul $s1, $t1, $t5                    

    beq $s0, $s1, found_prop2  
    j no_valid_prop

found_prop1:
    lw $s2, 1                
    j end_program

found_prop2:
    lw $s2, 2                
    j end_program

no_valid_prop:
    lw $s2, 0
    j end_program                  

end_program:



