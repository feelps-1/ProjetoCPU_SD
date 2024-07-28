module program_counter (
    input wire clk,       // Clock signal
    input wire reset,     // Reset signal
    input wire enable,    // Enable signal for writing to the register
    input wire [31:0] d,  // Data input (32-bit)
    output reg [31:0] q   // Data output (32-bit)
);

    // Register logic
    always @(posedge clk or posedge reset) begin
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
            32'd0: instruction = 32'b100011_01000_01001_0000000000000000; // lw r8
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
        Registers[10] = 32'h00000000;
        Registers[11] = 32'h00000000;
        Registers[12] = 32'h00000000;
        Registers[13] = 32'h00000000;
        Registers[14] = 32'h00000000;
        Registers[15] = 32'h00000009;
        Registers[16] = 32'h00000000;
        Registers[17] = 32'h00000000;
        Registers[18] = 32'h00000000;
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
        end
    end
    
  always @(negedge Clk) begin
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
            RAM[a[31:0]] <= wd;  // Write data to memory if write enable is high
        end
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

module cpu(
    input wire clock,
    input wire reset
);
    // Sinais internos
    wire [31:0] pcAdress;
    wire [31:0] nextPCAdress;
    wire [31:0] instructionWord;
    wire [4:0] dataRegister1;
    wire [4:0] dataRegister2;
    wire [4:0] wRegister;
    wire [31:0] readDR1;
    wire [31:0] readDR2;
    wire [15:0] wordToExtend;
    wire [31:0] extendedWord;
    wire [31:0] ALUSrcA, ALUSrcB, resultALU;
    wire [3:0] controlSignalALU;
    wire ALUZero;
    wire [31:0] readDataMem;

    // Instanciar PC
    program_counter PC(
        .clk(clock),
        .reset(reset),
        .enable(1'b1),
        .d(nextPCAdress),
        .q(pcAdress)
    );

    // Instanciar Adder Plus 4
    adder_plus_4 adderP4(
        .in(pcAdress),
        .out(nextPCAdress)
    );

    // Instanciar Instruction Memory
    instruction_memory Imem(
        .address(pcAdress),
        .instruction(instructionWord)
    );

    // Conectar campos da instrução
    assign dataRegister1 = instructionWord[25:21];
    assign dataRegister2 = instructionWord[20:16];
    assign wRegister = instructionWord[20:16];
    assign wordToExtend = instructionWord[15:0];

    // Instanciar Register File
    RegisterFile register_file(
        .ReadRegister1(dataRegister1), 
        .ReadRegister2(dataRegister2), 
        .WriteRegister(wRegister), 
        .WriteData(readDataMem), 
        .RegWrite(1'b1), 
        .Clk(clock), 
        .ReadData1(readDR1), 
        .ReadData2(readDR2)
    );

    // Instanciar Sign Extension
    sign_extension se(
        .in(wordToExtend),
        .out(extendedWord)
    );

    // Configurar sinais da ULA
    assign controlSignalALU = 4'b0000;  // Adição
    assign ALUSrcA = readDR1;
    assign ALUSrcB = extendedWord;

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
        .we(1'b0),  // Não escreve na memória
        .a(resultALU),
        .wd(32'b0),  // Nenhum dado para escrever
        .rd(readDataMem)
    );

endmodule
