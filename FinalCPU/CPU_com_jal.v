module instruction_memory(address, instruction);
    input [31:0] address;
    output reg [31:0] instruction;
    
    always @(*) begin
        case(address)
            32'd0: instruction = 32'b001000_00000_00100_0000000010100001 ; //addi $a0, $zero, 161
            //32'd0: instruction = 32'b001000_00000_00100_0000000010100000 ; //addi $a0, $zero, 160
            //32'd0: instruction = 32'b001000_00000_00100_0000000001111000 ; //addi $a0, $zero, 120
            32'd4: instruction = 32'b001000_00000_00101_0000000001011010 ; //addi $a1, $zero, 90
            32'd8: instruction = 32'b001000_00000_00110_0000000000000011; //addi $a2, $zero, 3
            32'd12: instruction = 32'b001000_00000_00111_0000000000000100; //addi $a3, $zero, 4
            32'd16: instruction = 32'b001000_00000_10000_0000000000000000; //addi $s0, $zero, 0
            32'd20: instruction = 32'b101011_10000_00100_0000000000000000 ; //sw $a0, 0($s0)
            32'd24: instruction = 32'b101011_10000_00101_0000000000000100; //sw $a1, 4($s0)
            32'd28: instruction = 32'b101011_10000_00110_0000000000001000; //sw $a2, 8($s0)
            32'd32: instruction = 32'b101011_10000_00111_0000000000001100; //sw $a3, 12($s0)
            32'd36: instruction = 32'b000011_00000000000000000000001101; //jal teste_de_proporcao
            32'd40: instruction = 32'b101011_10000_00010_0000000000010000 ; //sw $v0, 16($s0)
            32'd44: instruction = 32'b000011_00000000000000000000001100 ; //jal loop_infinito
            32'd48: instruction = 32'b000000_11111_000000000000000001000 ; //jr $ra
            32'd52: instruction = 32'b000000_00100_00110_01000_00000011000 ; //	mul $t0, $a0, $a2
            32'd56: instruction = 32'b000000_00101_00111_01001_00000011000 ; //mul $t1, $a1, $a3
            32'd60: instruction = 32'b000100_01000_01001_0000000000000101 ; //beq $t0, $t1, prop_4_3
            32'd64: instruction = 32'b000000_01000_00110_01000_00000011000 ; //mul $t0, $t0, $a2
            32'd68: instruction = 32'b000000_01001_00111_01001_00000011000 ; //mul $t1, $t1, $a3
            32'd72: instruction = 32'b000100_01000_01001_0000000000000100 ; //beq $t0, $t1, prop_16_9
            32'd76: instruction = 32'b001000_00000_00010_0000000000000000 ; //addi $v0, $zero, 0
            32'd80: instruction = 32'b000000_11111_000000000000000001000 ; //jr $ra
            32'd84: instruction = 32'b001000_00000_00010_0000000000000010 ; //addi $v0, $zero, 2
            32'd88: instruction = 32'b000000_11111_000000000000000001000  ; //jr $ra
            32'd92: instruction = 32'b001000_00000_00010_0000000000000001 ; //addi $v0, $zero, 1
            32'd96: instruction = 32'b000000_11111_000000000000000001000 ; //jr $ra
            default: instruction = 32'b0;
        endcase
    end
endmodule

module control_unit(instructionWord, MemToReg, memWrite, Branch, ALUSrc, RegDst, regWrite, Jump, JumpR, ALUControl);
    input [31:0] instructionWord;
    output reg MemToReg, memWrite, Branch, ALUSrc, RegDst, regWrite, Jump, JumpR;
    output reg [3:0]ALUControl;
  
    always @(instructionWord) begin
        case (instructionWord[31:26])
            6'b000000: begin
                if (instructionWord[5:0] == 6'b001000) begin //jr
                    regWrite <= 1'b0;
                    RegDst <= 1'bX;
                    ALUSrc <= 1'bX;
                    memWrite <= 1'b0;
                    MemToReg <= 1'bX;
                    Branch <= 1'b0;
                    ALUControl <= 4'bXXXX;
                    Jump <= 1'b1;
                    JumpR <= 1'b1;
                end else begin
                    regWrite <= 1'b1;
                    RegDst <= 1'b1;
                    ALUSrc <= 1'b0;
                    memWrite <= 1'b0;
                    MemToReg <= 1'b0;
                    Branch <= 1'b0;
                    Jump <= 1'b0;
                    JumpR <= 1'bX;
                    case (instructionWord[5:0])
                        6'b100000: ALUControl <= 4'b0000; //add
                        6'b100010: ALUControl <= 4'b0001; //sub
                        6'b100100: ALUControl <= 4'b0010; //and
                        6'b100101: ALUControl <= 4'b0011; //or
                        6'b100110: ALUControl <= 4'b0100; //xor
                        6'b000000: ALUControl <= 4'b0101; //shift left logical
                        6'b000010: ALUControl <= 4'b0110; //shift right logical
                        6'b011000: ALUControl <= 4'b0111; //mult
                        default: ALUControl <= 4'b0000;
                    endcase
                end
            end
            6'b100011: begin //lw
                regWrite <= 1'b1;
                RegDst <= 1'b0;
                ALUSrc <= 1'b1;
                memWrite <= 1'b0;
                MemToReg <= 1'b1;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
                JumpR <= 1'bX;
            end
            6'b101011: begin //sw
                regWrite <= 1'b0;
                RegDst <= 1'bX;
                ALUSrc <= 1'b1;
                memWrite <= 1'b1;
                MemToReg <= 1'bX;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
                JumpR <= 1'bX;
            end
            6'b000100: begin //beq
                regWrite <= 1'b0;
                RegDst <= 1'bX;
                ALUSrc <= 1'b0;
                memWrite <= 1'b0;
                MemToReg <= 1'bX;
                Branch <= 1'b1;
                ALUControl <= 4'b0001;
                Jump <= 1'b0;
                JumpR <= 1'bX;
            end
            6'b001000: begin //addi
                regWrite <= 1'b1;
                RegDst <= 1'b0;
                ALUSrc <= 1'b1;
                memWrite <= 1'b0;
                MemToReg <= 1'b0;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
                JumpR <= 1'bX;
            end
            6'b000011: begin //jal
                regWrite <= 1'b1;
                RegDst <= 1'bX;
                ALUSrc <= 1'bX;
                memWrite <= 1'b0;
                MemToReg <= 1'bX;
                Branch <= 1'bX;
                ALUControl <= 4'bXXXX;
                Jump <= 1'b1;
                JumpR <= 1'b0;
            end
            default: begin
                regWrite <= 1'b0;
                RegDst <= 1'bX;
                ALUSrc <= 1'b1;
                memWrite <= 1'b0;
                MemToReg <= 1'bX;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
                JumpR <= 1'bX;
            end
        endcase        
    end      
endmodule

module cpu(clock, reset, enable);
    input clock, reset, enable;
    
    // Sinais internos
    wire [31:0] pcAdress, nextPCAdress, offsetPC, pcBranch, pcPlus4, notJumpAdress, dataWriteRegister, JumpAdressR, extendedWord, ALUSrcA, ALUSrcB, resultALU, result;
    reg [31:0] JumpAdress, instructionWord, readDR1, readDR2, readDataMem;
    reg [25:0] partJump;
    reg [27:0] lowJump;
    reg [15:0] wordToExtend;
    reg [4:0] dataRegister1, dataRegister2;
    reg [3:0] controlSignalALU;
    wire [4:0] wRegister1, wRegister2, wRegister, Reg31, wRegister0;
    wire ALUZero;
    reg ALUSrc, RegDst, MemToReg, regWrite, memWrite, Branch, PCSrc, Jump, JumpR;
    
    assign Reg31 = 5'b11111;
    assign ALUSrcA = readDR1;

    // Conectar campos da instrução
    assign dataRegister1 = instructionWord[25:21];
    assign dataRegister2 = instructionWord[20:16];
    assign wRegister1 = instructionWord[20:16];
    assign wRegister2 = instructionWord[15:11];
    assign wordToExtend = instructionWord[15:0];

    always @(*) begin 
        PCSrc <= ALUZero && Branch;
        JumpAdress[27:0] <= lowJump;
        JumpAdress[31:28] <= pcPlus4[31:28];
        partJump <= instructionWord[25:0];
    end

    control_unit CU(
        .instructionWord(instructionWord),
        .MemToReg(MemToReg),
        .memWrite(memWrite),
        .Branch(Branch),
        .ALUControl(controlSignalALU),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .regWrite(regWrite),
        .Jump(Jump),
        .JumpR(JumpR)
    );

    mux2to132bit PCSRCMux(
        .word_a(pcBranch),
        .word_b(pcPlus4),
        .sel(PCSrc),
        .data_out(notJumpAdress)
    );

    program_counter PC(
        .clk(clock),
        .reset(reset),
        .enable(enable),
        .d(nextPCAdress),
        .q(pcAdress)
    );

    instruction_memory Imem(
        .address(pcAdress),
        .instruction(instructionWord)
    );

    mux2to15bit RegDstMux(
        .word_a(wRegister2),
        .word_b(wRegister1),
        .sel(RegDst),
        .data_out(wRegister0)
    );
  
    mux2to15bit jrMux(
        .word_a(Reg31),
        .word_b(wRegister0),
        .sel(Jump),
        .data_out(wRegister)
    );

    RegisterFile register_file(
        .ReadRegister1(dataRegister1), 
        .ReadRegister2(dataRegister2), 
        .WriteRegister(wRegister), 
        .WriteData(dataWriteRegister), 
        .RegWrite(regWrite), 
        .Clk(clock), 
        .ReadData1(readDR1), 
        .ReadData2(readDR2)
    );

    sign_extension se(
        .in(wordToExtend),
        .out(extendedWord)
    );

    adder_plus_4 adderP4(
        .in(pcAdress),
        .out(pcPlus4)
    );

    multiply_by_4 BranchMult(
        .in(extendedWord),
        .out(offsetPC)
    );

    adder PCBranchAdder(
        .p1(offsetPC),
        .p2(pcPlus4),
        .out(pcBranch)
    );

    multiply_by_426 jumpMult(
        .in(partJump),
        .out(lowJump)
    );

    mux2to132bit JRMux(
        .word_a(readDR1),
        .word_b(JumpAdress),
        .sel(JumpR),
        .data_out(JumpAdressR)
    );

    mux2to132bit JumpMux(
        .word_a(JumpAdressR),
        .word_b(notJumpAdress),
        .sel(Jump),
        .data_out(nextPCAdress)
    );

    mux2to132bit AluSRCMux(
        .word_a(extendedWord),
        .word_b(readDR2),
        .sel(ALUSrc),
        .data_out(ALUSrcB)
    );

    ULA ALU(
        .ALUControl(controlSignalALU),
        .A(ALUSrcA),
        .B(ALUSrcB),
        .ALUResult(resultALU),
        .Zero(ALUZero)
    );

    dmem dataMemory(
        .clk(clock),
        .we(memWrite),  
        .a(resultALU),
        .wd(readDR2),  
        .rd(readDataMem)
    );

    mux2to132bit MemtoRegMux(
        .word_a(readDataMem),
        .word_b(resultALU),
        .sel(MemToReg),
        .data_out(result)
    );
  
    mux2to132bit NextPCtoRegMux(
      .word_a(pcPlus4),
      .word_b(result),
      .sel(Jump),
      .data_out(dataWriteRegister)
    );
endmodule

module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData,  RegWrite, Clk, ReadData1, ReadData2);
    input [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    input [31:0] WriteData;
    input RegWrite, Clk;
    output reg [31:0] ReadData1, ReadData2;
    
    reg [31:0] Registers [0:31];
    
    initial begin
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            Registers[i] = 32'h00000000;
        end
    end
    
    always @(posedge Clk) begin
        if (RegWrite == 1) begin
          Registers[WriteRegister] <= WriteData;
          $display("Dados que estao sendo escritos no Register File: %d", WriteData);
        end
    end
    
    always @(*) begin
        ReadData1 <= Registers[ReadRegister1];
        ReadData2 <= Registers[ReadRegister2];
    end    
endmodule

module sign_extension(in, out);
    input [15:0] in;
    output reg [31:0] out;

    always@(in) begin
        if (in[15] == 0) begin
            out <= {16'h0000 , in};
        end else begin
            if (in[15]==1) begin
                out <= {16'hffff , in};
            end
            else begin
                out <= in;
            end
        end
    end
endmodule

module dmem(clk, we, a, wd, rd);
    input clk;            // Clock signal
    input we;             // Write enable signal
    input [31:0] a;       // Address input (32-bit)
    input [31:0] wd;      // Write data input (32-bit)
    output reg [31:0] rd;  // Read data output (32-bit)

    reg [31:0] RAM[63:0];  // Memory array with 64 32-bit words

    // Initialize memory with specific value at address 15
    initial begin
        integer i;
        for (i = 0; i < 64; i = i + 1) begin
            RAM[i] = 32'h00000000;  // Initialize all memory locations to 0
        end
        RAM[15] = 32'hDEADBEEF;     // Set address 15 to DEADBEEF
    end

    // Read data
    always @(posedge clk) begin
        if (we) begin
            RAM[a[31:0]] <= wd;
          $display("Dados que estao sendo escritos na Data Memory: %d", wd);// Write data to memory if write enable is high
        end
    end

    always @(*)begin
        rd <= RAM[a[31:0]];      // Read data from memory
    end
endmodule

module program_counter(clk, reset, enable, d, q);
    input wire clk;       // Clock signal
    input wire reset;     // Reset signal
    input wire enable;    // Enable signal for writing to the register
    input wire [31:0] d;  // Data input (32-bit)
  	output reg [31:0] q;  // Data output (32-bit)

    // Register logic
    always @(negedge reset or posedge clk) begin
        if (reset) begin
            q <= 32'b0;  // Reset the register value to 0
        end else if (enable) begin
            q <= d;  // Load the input data into the register
        end
    end
endmodule

module ULA(ALUControl, A, B, ALUResult, Zero);
    input [3:0] ALUControl;    // Código de controle da ULA (4 bits)
    input [31:0] A;            // Operando A (32 bits)
    input [31:0] B;            // Operando B (32 bits)
    output reg [31:0] ALUResult; // Resultado da ULA (32 bits)
    output reg Zero;            // Sinal de Zero (1 bit)

    reg [31:0] ALUResult_reg;  // Registrador para armazenar o resultado

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult_reg = A + B;           // Adição
            4'b0001: ALUResult_reg = A - B;           // Subtração
            4'b0010: ALUResult_reg = A & B;           // AND
            4'b0011: ALUResult_reg = A | B;           // OR
            4'b0100: ALUResult_reg = A ^ B;           // XOR
            4'b0101: ALUResult_reg = A << B;          // Deslocamento para a esquerda
            4'b0110: ALUResult_reg = A >> B;          // Deslocamento para a direita
            4'b0111: ALUResult_reg = A * B;           // Multiplicação
            4'b1000: ALUResult_reg = (A == B) ? 1 : 0;// Comparação de igualdade
            default: ALUResult_reg = 0;               // Padrão
        endcase
        ALUResult = ALUResult_reg;                    // Atribui o valor do registrador à saída
        Zero = (ALUResult == 0) ? 1 : 0;              // Sinal Zero
    end
endmodule

module adder_plus_4(in, out);
    input [31:0] in;
    output [31:0] out;
    
    assign out = in + 4;
endmodule

module adder(p1, p2, out);
    input [31:0] p1, p2;
    output [31:0] out;
    
    assign out = p1 + p2;
endmodule

module mux2to132bit(word_a, word_b, sel, data_out);
    input [31:0] word_a, word_b;   // Entradas de dados
    input sel;                     // Seletor
    output [31:0]data_out;         // Saída de dados

    assign data_out = sel ? word_a : word_b;
endmodule

module mux2to15bit(word_a, word_b, sel, data_out);
    input [4:0] word_a, word_b;   // Entradas de dados
    input sel;                    // Seletor
    output [4:0] data_out;        // Saída de dados

    assign data_out = sel ? word_a : word_b;
endmodule

module multiply_by_4(in, out);
    input [31:0] in;
    output [31:0] out;
    // Multiplica o valor de entrada por 4 usando deslocamento à esquerda
    assign out = in << 2;
endmodule

module multiply_by_426(in, out);
    input [25:0] in;
    output [27:0] out;
    
    assign out = {in, 2'b00};
endmodule
