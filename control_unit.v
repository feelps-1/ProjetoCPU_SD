module control_unit(input [31:0] instructionWord,
                    output MemToReg,
                    output memWrite,
                    output Branch,
                    output [3:0]ALUControl,
                    output ALUSrc,
                    output RegDst,
                    output regWrite,
                    output Jump);
  
   always @(instructionWord) begin
        case (instructionWord[31:26])
            6'b000000: begin
                regWrite <= 1'b1;
                RegDst <= 1'b1;
                ALUSrc <= 1'b0;
                memWrite <= 1'b0;
                MemToReg <= 1'b0;
                Branch <= 1'b0;
                case (instructionWord[5:0])
                    6'b100000: ALUControl <= 4'b0000; //add
                    6'b100010: ALUControl <= 4'b0001; //sub
                    6'b100100: ALUControl <= 4'b0010; //and
                    6'b100101: ALUControl <= 4'b0011; //or
                    6'b100110: ALUControl <= 4'b0100; //xor
                    6'b000000: ALUControl <= 4'b0101; //shift left logical
                    6'b000010: ALUControl <= 4'b0110; //shift right logical
                    6'b011000: ALUControl <= 4'b0111; //mult
                    6'b100000: ALUControl <= 4'b1000; //
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