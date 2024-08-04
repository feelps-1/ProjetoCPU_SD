module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
);
    always @(*) begin
        case(address)
            32'd0: instruction = 32'b001000_00000_10000_0000000000000000; //addi $s0, $zero, 0
            32'd4: instruction = 32'b001000_00000_00100_0000000010100001 ; //addi $a0, $zero, 161
            32'd8: instruction = 32'b101011_10000_00100_0000000000000000 ; //sw $a0, 0($s0)
            32'd12: instruction = 32'b001000_00000_00101_0000000001011010 ; //addi $a1, $zero, 90
            32'd16: instruction = 32'b101011_10000_00101_0000000000000100; //sw $a1, 4($s0)
            32'd20: instruction = 32'b001000_00000_00110_0000000000000011; //addi $a2, $zero, 3
            32'd24: instruction = 32'b101011_10000_00110_0000000000001000; //sw $a2, 8($s0)
            32'd28: instruction = 32'b001000_00000_00111_0000000000000100; //addi $a3, $zero, 4
            32'd32: instruction = 32'b101011_10000_00111_0000000000001100; //sw $a3, 12($s0)
            32'd36: instruction = 32'b000011_00000000000000000000001101; //jal teste_de_proporcao
            32'd40: instruction = 32'b101011_10000_00010_0000000000010000 ; //sw $v0, 16($s0)
            32'd44: instruction = 32'b000011_00000000000000000000001100 ; //jal loop_infinito
            32'd48: instruction = 32'b000000_11111_00000_00000_00000_001000 ; //jr $ra
            32'd52: instruction = 32'b000000_00100_00110_01000_00000011000 ; //	mul $t0, $a0, $a2
            32'd56: instruction = 32'b000000_00101_00111_0100100000011000 ; //mul $t1, $a1, $a3
            32'd60: instruction = 32'b00100_01000_01001_0000000000001000 ; //beq $t0, $t1, prop_4_3
            32'd64: instruction = 32'b000000_00110_00110_01010_00000011000 ; //mul $t2, $a2, $a2
            32'd68: instruction = 32'b000000_00111_00111_01011_00000011000 ; //mul $t3, $a3, $a3
            32'd72: instruction = 32'b000000_00100_01010_01000_00000011000 ; //mul $t0, $a0, $t2
            32'd76: instruction = 32'b000000_00101_01011_01001_00000011000 ; //mul $t1, $a1, $t3
            32'd80: instruction = 32'b000100_01000_01001_0000000000000101 ; //beq $t0, $t1, prop_16_9
            32'd84: instruction = 32'b001000_00000_00010_0000000000000000 ; //addi $v0, $zero, 0
            32'd88: instruction = 32'b000000_11111_00000_00000_00000_001000 ; //jr $ra
            32'd92: instruction = 32'b001000_00000_00010_0000000000000010 ; //addi $v0, $zero, 2
            32'd96: instruction = 32'b000000_11111_00000_00000_00000_001000  ; //jr $ra
            32'd100: instruction = 32'b001000_00000_00010_0000000000000001 ; //addi $v0, $zero, 1
            32'd104: instruction = 32'b000000_11111_00000_00000_00000_001000 ; //jr $ra
            
            default: instruction = 32'b0;
        endcase
    end
endmodule
