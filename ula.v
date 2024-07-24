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
