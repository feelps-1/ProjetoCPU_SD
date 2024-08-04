module program_counter (
    input wire clk,       // Clock signal
    input wire reset,     // Reset signal
    input wire enable,    // Enable signal for writing to the register
    input wire [31:0] d,  // Data input (32-bit)
    output reg [31:0] q   // Data output (32-bit)
);

    // Register logic
    always @(negedge reset or posedge clk) begin
        if (reset) begin
            q <= 32'b0;  // Reset the register value to 0
        end else if (enable) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule

module instruction_memory(
    input [31:0] address,
    output reg [31:0] instruction
);
    always @(*) begin
        case(address)
            32'h00000000: instruction = 32'h200800D5; //addi $t0, $0, 213
            32'h00000004: instruction = 32'h2009003C; //addi $t1, $0, 60
            32'h00000008: instruction = 32'h200A0009; //addi $t2, $0, 9
            32'h0000000C: instruction = 32'h200B0010; //addi $t3, $0, 16
            32'h00000010: instruction = 32'h200C0003; //addi $t4, $0, 3
            32'h00000014: instruction = 32'h200D0004; //addi $t5, $0, 4
            32'h00000018: instruction = 32'hAC081000; //sw $t0, 1000($zero)
            32'h0000001C: instruction = 32'hAC091004; //sw $t1, 1004($zero)
            32'h00000020: instruction = 32'h010A8018; //mul $s0, $t0, $t2
            32'h00000024: instruction = 32'h012B8818; //mul $s1, $t1, $t3
            32'h00000028: instruction = 32'hAC101008; //sw $s0, 1008($zero)
            32'h0000002C: instruction = 32'hAC11100C; //sw $s1, 100C($zero)
            32'h00000030: instruction = 32'h12110007; //beq $s0, $s1, found_prop1
            32'h00000034: instruction = 32'h010C8018; //mul $s0, $t0, $t4
            32'h00000038: instruction = 32'h012D8818; //mul $s1, $t1, $t5
            32'h0000003C: instruction = 32'hAC101010; //sw $s0, 1010($zero)
            32'h00000040: instruction = 32'hAC111014; //sw $s1, 1014($zero)
            32'h00000044: instruction = 32'h12110005; //beq $s0, $s1, found_prop2
            32'h00000048: instruction = 32'h08000019; //j no_valid_prop
            32'h0000004C: instruction = 32'h20120001; //addi $s2, $0, 1
            32'h00000050: instruction = 32'hAC121018; //sw $s2, 1018
            32'h00000054: instruction = 32'h0800001C; //j end_program
            32'h00000058: instruction = 32'h20120002; //addi $s2, $0, 2
            32'h0000005C: instruction = 32'hAC121018; //sw $s2, 1018
            32'h00000060: instruction = 32'h0800001C; //j end_program
            32'h00000064: instruction = 32'h20120000; //addi $s2, $0, 0
            32'h00000068: instruction = 32'hAC121018; //sw $s2, 1018
            32'h0000006C: instruction = 32'h0800001C; //j end_program
            32'h00000070: instruction = 32'h0800001C; //j end_program
            default: instruction = 32'b0;
        endcase
    end
endmodule

module RegisterFile(ReadRegister1, ReadRegister2, WriteRegister, WriteData,  RegWrite, Clk, ReadData1, ReadData2);

    input [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    input [31:0] WriteData;
    input RegWrite, Clk;
    
    output reg [31:0] ReadData1, ReadData2;
    
    reg [31:0] Registers [0:31];
    
    initial begin
        Registers[0] = 32'h00000000;
        Registers[8] = 32'h0000000F;
        Registers[9] = 32'h00000000;
        Registers[10] = 32'h00000004;
        Registers[11] = 32'h00000005;
        Registers[12] = 32'h00000000;
        Registers[13] = 32'h000000FF;
        Registers[14] = 32'h00000000;
        Registers[15] = 32'h00000009;
        Registers[16] = 32'h00000000;
        Registers[17] = 32'h0000000F;
        Registers[18] = 32'h0000000F;
        Registers[19] = 32'h00000000;
        Registers[20] = 32'h00000000;
        Registers[21] = 32'h00000000;
        Registers[22] = 32'h00000000;
        Registers[23] = 32'h00000000;
        Registers[24] = 32'h00000000;
        Registers[25] = 32'h00000000;
        Registers[29] = 32'd252; 
        Registers[31] = 32'b0;
    end
    
    always @(posedge Clk) begin
        if (RegWrite == 1) begin
          Registers[WriteRegister] <= WriteData;
          //$display(WriteData);
        end
    end
    
    always @(*) begin
        ReadData1 <= Registers[ReadRegister1];
        ReadData2 <= Registers[ReadRegister2];
    end
    
endmodule

module sign_extension(out, in);

    /* A 32-Bit output word */
    output [31:0] out;
    
    /* A 16-Bit input word */
    input [15:0] in;
    reg [31:0] out;

    /* Fill in the implementation here... */ 
    always@(in)
    begin
        if (in[15] == 0) begin
            out <= {16'h0000 , in};
        end else begin
            if (in[15]==1)
            begin
            out <= {16'hffff , in};
            end
            else 
            begin
            out <= in;
            end
        end

    end
endmodule

module dmem (
    input clk,            // Clock signal
    input we,             // Write enable signal
    input [31:0] a,       // Address input (32-bit)
    input [31:0] wd,      // Write data input (32-bit)
    output reg [31:0] rd  // Read data output (32-bit)
);

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
          $display("Dados que estao sendo escritos: %h", wd);// Write data to memory if write enable is high
        end
        
    end

    always @(*)begin
        rd <= RAM[a[31:0]];      // Read data from memory
    end

endmodule

module ULA (
    input [3:0] ALUControl,    // Código de controle da ULA (4 bits)
    input [31:0] A,            // Operando A (32 bits)
    input [31:0] B,            // Operando B (32 bits)
    output reg [31:0] ALUResult, // Resultado da ULA (32 bits)
    output reg Zero            // Sinal de Zero (1 bit)
);

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

module adder_plus_4(
    input  [31:0] in,
    output [31:0] out
);
    assign out = in + 4;
endmodule

module adder(
    input  [31:0] p1,
    input [31:0] p2,
    output [31:0] out
);
    assign out = p1 + p2;
endmodule

module mux2to132bit (
    input [31:0]word_a,
    input [31:0]word_b,// Entradas de dados
    input sel,     // Seletores
    output [31:0]data_out      // Saída de dados
);

assign data_out = sel ? word_a : word_b;

endmodule

module mux2to15bit (
    input [4:0]word_a,
    input [4:0]word_b,// Entradas de dados
    input sel,     // Seletores
    output [4:0]data_out      // Saída de dados
);

    assign data_out = sel ? word_a : word_b;

endmodule

module multiply_by_4(
    input wire [31:0] in,
    output wire [31:0] out
);

    // Multiplica o valor de entrada por 4 usando deslocamento à esquerda
    assign out = in << 2;

endmodule

module multiply_by_426(
    input wire [25:0] in,
    output wire [27:0] out
);

    // Multiplica o valor de entrada por 4 usando deslocamento à esquerda
    assign out = {in, 2'b00};

endmodule

module control_unit(input [31:0] instructionWord,
                    output reg MemToReg,
                    output reg memWrite,
                    output reg Branch,
                    output reg [3:0]ALUControl,
                    output reg ALUSrc,
                    output reg RegDst,
                    output reg regWrite,
                    output reg Jump);
  
   always @(instructionWord) begin
        case (instructionWord[31:26])
            6'b000000: begin
                regWrite <= 1'b1;
                RegDst <= 1'b1;
                ALUSrc <= 1'b0;
                memWrite <= 1'b0;
                MemToReg <= 1'b0;
                Branch <= 1'b0;
                Jump <= 1'b0;
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

            6'b100011: begin
                regWrite <= 1'b1;
                RegDst <= 1'b0;
                ALUSrc <= 1'b1;
                memWrite <= 1'b0;
                MemToReg <= 1'b1;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
            end

            6'b101011: begin
                regWrite <= 1'b0;
                RegDst <= 1'bX;
                ALUSrc <= 1'b1;
                memWrite <= 1'b1;
                MemToReg <= 1'bX;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
            end

            6'b000100: begin
                regWrite <= 1'b0;
                RegDst <= 1'bX;
                ALUSrc <= 1'b0;
                memWrite <= 1'b0;
                MemToReg <= 1'bX;
                Branch <= 1'b1;
                ALUControl <= 4'b0001;
                Jump <= 1'b0;
            end

            6'b001000: begin
                regWrite <= 1'b1;
                RegDst <= 1'b0;
                ALUSrc <= 1'b1;
                memWrite <= 1'b0;
                MemToReg <= 1'b0;
                Branch <= 1'b0;
                ALUControl <= 4'b0000;
                Jump <= 1'b0;
            end
            6'b000010: begin 
                regWrite <= 1'b0;
                RegDst <= 1'bX;
                ALUSrc <= 1'bX;
                memWrite <= 1'b0;
                MemToReg <= 1'bX;
                Branch <= 1'bX;
                ALUControl <= 4'bXXXX;
                Jump <= 1'b1;
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
            end
        endcase
        
    end
      
endmodule

module cpu(
    input wire clock,
    input wire reset,
    input wire enable
);
    // Sinais internos
    wire [31:0] pcAdress, nextPCAdress, offsetPC, pcBranch, pcPlus4, notJumpAdress;
    reg [31:0]JumpAdress;
    reg [31:0] instructionWord;
    reg [25:0] partJump;
    reg [27:0] lowJump;
    reg [4:0] dataRegister1, dataRegister2;
    wire [4:0] wRegister1, wRegister2, wRegister;
    reg [31:0] readDR1, readDR2;
    reg [15:0] wordToExtend;
    wire [31:0] extendedWord;
    wire [31:0] ALUSrcA, ALUSrcB, resultALU;
    reg [3:0] controlSignalALU;
    wire ALUZero;
    reg [31:0] readDataMem;
    reg ALUSrc, RegDst, MemToReg, regWrite, memWrite, Branch, PCSrc, Jump;
    wire [31:0] result;

    control_unit CU(
        .instructionWord(instructionWord),
        .MemToReg(MemToReg),
        .memWrite(memWrite),
        .Branch(Branch),
        .ALUControl(controlSignalALU),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .regWrite(regWrite),
        .Jump(Jump)
    );

    always @(*) begin 
        PCSrc <= ALUZero && Branch;
        JumpAdress[27:0] <= lowJump;
        JumpAdress[31:28] <= pcPlus4[31:28];
        partJump <= instructionWord[25:0];
    end


    mux2to132bit PCSRCMux(
        .word_a(pcBranch),
        .word_b(pcPlus4),
        .sel(PCSrc),
        .data_out(notJumpAdress)
    );

    // Instanciar PC
    program_counter PC(
        .clk(clock),
        .reset(reset),
        .enable(enable),
        .d(nextPCAdress),
        .q(pcAdress)
    );

    // Instanciar Instruction Memory
    instruction_memory Imem(
        .address(pcAdress),
        .instruction(instructionWord)
    );

    // Conectar campos da instrução
    assign dataRegister1 = instructionWord[25:21];
    assign dataRegister2 = instructionWord[20:16];

    assign wRegister1 = instructionWord[20:16];
    assign wRegister2 = instructionWord[15:11];

    // Instanciar MuxREGDST
    mux2to15bit RegDstMux(
        .word_a(wRegister2),
        .word_b(wRegister1),
        .sel(RegDst),
        .data_out(wRegister)
    );

    // Instanciar Register File
    RegisterFile register_file(
        .ReadRegister1(dataRegister1), 
        .ReadRegister2(dataRegister2), 
        .WriteRegister(wRegister), 
        .WriteData(result), 
        .RegWrite(regWrite), 
        .Clk(clock), 
        .ReadData1(readDR1), 
        .ReadData2(readDR2)
    );

    assign wordToExtend = instructionWord[15:0];

    // Instanciar Sign Extension
    sign_extension se(
        .in(wordToExtend),
        .out(extendedWord)
    );

     // Instanciar Adder Plus 4
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

    mux2to132bit JumpMux(
        .word_a(JumpAdress),
        .word_b(notJumpAdress),
        .sel(Jump),
        .data_out(nextPCAdress)
    );

    assign ALUSrcA = readDR1;

    // Instanciar MuxAluSRC
    mux2to132bit AluSRCMux(
        .word_a(extendedWord),
        .word_b(readDR2),
        .sel(ALUSrc),
        .data_out(ALUSrcB)
    );

    // Instanciar ULA
    ULA ALU(
        .ALUControl(controlSignalALU),
        .A(ALUSrcA),
        .B(ALUSrcB),
        .ALUResult(resultALU),
        .Zero(ALUZero)
    );

    // Instanciar Data Memory
    dmem dataMemory(
        .clk(clock),
        .we(memWrite),  
        .a(resultALU),
        .wd(readDR2),  
        .rd(readDataMem)
    );

     // Instanciar MemtoRegMux
    mux2to132bit MemtoRegMux(
        .word_a(readDataMem),
        .word_b(resultALU),
        .sel(MemToReg),
        .data_out(result)
    );

endmodule
