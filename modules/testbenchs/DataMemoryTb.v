`timescale 1ns / 1ps

module dmem_tb;

    // Sinais de entrada do DUT (Device Under Test)
    reg clk;
    reg we;
    reg [31:0] a;
    reg [31:0] wd;
    
    // Sinal de saída do DUT
    wire [31:0] rd;
    
    // Instância do módulo de memória de dados
    dmem uut (
        .clk(clk),
        .we(we),
        .a(a),
        .wd(wd),
        .rd(rd)
    );
    
    // Gerador de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Gera um clock de 10ns
    end
    
    // Processo de teste
    initial begin
        // Inicialização
        we = 0;
        a = 0;
        wd = 0;
        
        // Ciclo 1: Escreve na memória
        #10;
        we = 1;
        a = 32'h00000004; // Endereço 1 (word aligned)
        wd = 32'hAABBCCDD; // Dados a serem escritos
        #10;
        we = 0; // Desabilita escrita
        
        // Ciclo 2: Ler da memória
        #10;
        a = 32'h00000004; // Endereço 1 (word aligned)
        #10;
        
        // Ciclo 3: Escreve na memória
        #10;
        we = 1;
        a = 32'h00000008; // Endereço 2 (word aligned)
        wd = 32'h11223344; // Dados a serem escritos
        #10;
        we = 0; // Desabilita escrita
        
        // Ciclo 4: Ler da memória
        #10;
        a = 32'h00000008; // Endereço 2 (word aligned)
        #10;
        
        // Ciclo 5: Ler novamente do primeiro endereço
        #10;
        a = 32'h00000004; // Endereço 1 (word aligned)
        #10;

        // Finaliza a simulação
        $stop;
    end

endmodule
