`timescale 1ns/1ps

module cpu_tb;

    // Declarações dos sinais
    reg clock;
    reg reset;
  	reg enable;
    wire [31:0] pcAdress;
    wire [31:0] nextPCAdress;
    wire [31:0] instructionWord;
    wire [4:0] dataRegister1;
    wire [4:0] dataRegister2;
    wire [4:0] wRegister1, wRegister2;
    wire [31:0] readDR1;
    wire [31:0] readDR2;
    wire [15:0] wordToExtend;
    wire [31:0] extendedWord;
    wire [31:0] ALUSrcA, ALUSrcB, resultALU;
    wire [3:0] controlSignalALU;
    wire ALUZero;
    wire [31:0] readDataMem;
    wire ALUSrc, RegDst, MemToReg, regWrite, memWrite;
    wire [31:0] result;

    // Instanciar a CPU
    cpu uut (
        .clock(clock),
      .reset(reset),
      .enable(enable)
    );

    // Gerar o sinal de clock
    initial begin
        clock = 1;
        forever #5 clock = ~clock;
    end

    // Sequência de testes
    initial begin
      $monitor("Time: %0t | PC: %h | Instr: %h | RegWrite: %b | MemToReg: %b | RegDst: %b | MemWrite: %b | ReadDR1: %h | ReadDR2: %h | ALUResult: %h | ReadDataMem: %h | Branch: %b | Clock: %b | PCSrc: %b | JumpA: %h | Jump: %b",
            $time, uut.pcAdress, uut.instructionWord, uut.regWrite, uut.MemToReg, uut.RegDst, uut.memWrite, uut.readDR1, uut.readDR2, uut.resultALU, uut.readDataMem, uut.Branch, clock, uut.PCSrc, uut.JumpAdress, uut.Jump);

        // Inicializar o reset
      	enable = 0;
        reset = 1;
        #10;
        reset = 0;
      	enable = 1;
        
        // Esperar um tempo para cada instrução ser executada
        #290;
      

        // Verificar o resultado da instrução lw $9, 0($8)
      if (uut.register_file.Registers[9] !== 32'hDEADBEEF) begin
            $display("Test failed for lw $9, 0($8)");
         
        end else begin
            $display("Test passed for lw $9, 0($8)");
        end

        // Verificar o resultado da instrução sw $13, 0($8)
      if (uut.dataMemory.RAM[16] !== 32'hFF) begin
            $display("Test failed for sw $13, 0($8)");
          
        end else begin
            $display("Test passed for sw $13, 0($8)");
        end

        // Verificar o resultado da instrução add $12, $10, $11
        if (uut.register_file.Registers[12] !== (uut.register_file.Registers[10] + uut.register_file.Registers[11])) begin
            $display("Test failed for add $12, $10, $11");
         
        end else begin
            $display("Test passed for add $12, $10, $11");
        end

        $finish;
    end
endmodule
