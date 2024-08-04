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