module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
);
    always @(*) begin
        case(address)
            32'd0: instruction = 32'b001000_01000_01000_0000_1101_0101; // addi $t0, $t0, 213
            32'd4: instruction = 32'b001000_01001_01001_0000_0011_1100; // addi $t1, $t1, 60
            32'd8: instruction = 32'b001000_01010_01010_0000_0000_1001; // addi $t2, $t2, 9
            32'd12: instruction = 32'b000000_01000_01010_10000_00000_011000; // mul $s0, $t0, $t2
            32'd16: instruction = 32'b001000_01011_01011_0000_0001_0000; // addi $t3, $t3, 16
            32'd20: instruction = 32'b000000_01001_01011_10001_00000_011000; // mul $s1, $t1, $t3
            32'd24: instruction = 32'b000100_10000_10001_0000_0000_0010; // beq $s0, $s1, found_prop1
            32'd28: instruction = 32'b001000_01100_01100_0000_0000_0011; // addi $t4, $t4, 3
            32'd32: instruction = 32'b000000_01000_01100_10000_00000_011000; // mul $s0, $t0, $t4
            32'd36: instruction = 32'b001000_01101_01101_0000_0000_0100; // addi $t5, $t5, 4
            32'd40: instruction = 32'b000000_01001_01101_10001_00000_011000; // mul $s1, $t1, $t5
            32'd44: instruction = 32'b000100_10000_10001_0000_0000_0010; // beq $s0, $s1, found_prop2
            32'd48: instruction = 32'b000010_0000_0000_0000_0000_0101; // j no_valid_prop
            32'd52: instruction = 32'b001000_10010_10010_0000_0000_0001; // addi $s2, $s2, 1
            32'd56: instruction = 32'b000010_0000_0000_0000_0000_0111; // j end_program
            32'd60: instruction = 32'b001000_10010_10010_0000_0000_0010; // addi $s2, $s2, 2
            32'd64: instruction = 32'b000010_0000_0000_0000_0000_0111; // j end_program
            32'd68: instruction = 32'b001000_10010_10010_0000_0000_0000; // addi $s2, $s2, 0
            32'd72: instruction = 32'b000010_0000_0000_0000_0000_0111; // j end_program
            32'd76: instruction = 32'b000010_0000_0000_0000_0000_0111; // j end_program
            default: instruction = 32'b0;
        endcase
    end
endmodule

module tb_instruction_memory;
    // Declaração de variáveis
    reg [31:0] address;
    wire [31:0] instruction;

    // Instancia o módulo de memória de instrução
    instruction_memory im(
        .address(address),
        .instruction(instruction)
    );

    // Procedimento inicial para simulação
    initial begin
        // Monitoramento das variáveis para impressão automática
        $monitor("Address: %0d, Instruction: %b", address, instruction);

        // Define diferentes endereços para teste
        address = 32'd0; #10;
        address = 32'd4; #10;
        address = 32'd8; #10;
        address = 32'd12; #10;
        address = 32'd16; #10;
        address = 32'd20; #10;
        address = 32'd24; #10;
        address = 32'd28; #10;
        address = 32'd32; #10;
        address = 32'd36; #10;
        address = 32'd40; #10;
        address = 32'd44; #10;
        address = 32'd48; #10;
        address = 32'd52; #10;
        address = 32'd56; #10;
        address = 32'd60; #10;
        address = 32'd64; #10;
        address = 32'd68; #10;
        address = 32'd72; #10;
        address = 32'd76; #10;

        // Finaliza a simulação
        $finish;
    end
endmodule
