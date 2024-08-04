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
      $monitor("Time: %0t | PC: %d | Instr: %h | RegWrite: %b | MemToReg: %b | RegDst: %b | MemWrite: %b | ReadDR1: %h | ReadDR2: %h | ALUResult: %h | ReadDataMem: %h | Branch: %b | Clock: %b | PCSrc: %b | JumpA: %h | Jump: %b",
            $time, uut.pcAdress, uut.instructionWord, uut.regWrite, uut.MemToReg, uut.RegDst, uut.memWrite, uut.readDR1, uut.readDR2, uut.resultALU, uut.readDataMem, uut.Branch, clock, uut.PCSrc, uut.JumpAdress, uut.Jump);

        // Inicializar o reset
      	enable = 0;
        reset = 1;
        #10;
        reset = 0;
      	enable = 1;
        
        // Esperar um tempo para cada instrução ser executada
        #220;

        $finish;
    end
endmodule
