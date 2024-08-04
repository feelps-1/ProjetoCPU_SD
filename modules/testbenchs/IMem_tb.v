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
        address = 32'd80; #10;
        address = 32'd84; #10;
        address = 32'd88; #10;
        address = 32'd92; #10;
        address = 32'd96; #10;

        

        // Finaliza a simulação
        $finish;
    end
endmodule
