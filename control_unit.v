module control_unit(input [31:26]opcode,
                    input [5:0] funct,
                    output MemToReg,
                    output MemWrite,
                    output Branch,
                    output [3:0]ALUControl,
                    output ALUSrc,
                    output RegDst,
                    output RegWrite,
                    output Jump);
  
    begin
        if opcode == 6'b000000: //Type R instruction
            assign RegWrite = 1'b1
            assign RegDst = 1'b1
            assign ALUSrc = 1'b0
            assign Branch = 1'b0
            assign MemWrite = 1'b0
            assign MemToReg = 1'b0
            assign ALUControl = 3'b010
            assign Jump = 1'b0
      
        else if opcode == 6'b001000: //Addi instruction
            assign RegWrite = 1'b1
            assign RegDst = 1'b0
            assign ALUSrc = 1'b1
            assign Branch = 1'b0
            assign MemWrite = 1'b0
            assign MemToReg = 1'b0
            assign ALUControl = 3'b000
            assign Jump = 1'b0
       
        else if opcode == 6'b000100: //Branch instruction
            assign RegWrite = 1'b0
            assign RegDst = 1'bX
            assign ALUSrc = 1'b0
            assign Branch = 1'b1
            assign MemWrite = 1'b0
            assign MemToReg = 1'bX
            assign ALUControl = 3'b001
            assign Jump = 1'b0
     
        else if opcode == 6'b000010: //Type J instruction
            assign RegWrite = 1'b0
            assign RegDst = 1'bX
            assign ALUSrc = 1'bX
            assign Branch = 1'bX
            assign MemWrite = 1'b0
            assign MemToReg = 1'bX
            assign ALUControl = 3'bXXX
            assign Jump = 1'b1
       
        else:
    end
      
endmodule