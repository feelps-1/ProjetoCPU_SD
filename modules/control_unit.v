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
                        6'b011000: ALUControl <= 4'b0111; //mul
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