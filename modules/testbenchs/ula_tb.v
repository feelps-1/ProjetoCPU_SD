module ULA_tb;

    reg [3:0] ALUControl;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] ALUResult;
    wire Zero;

    ULA uut (
        .ALUControl(ALUControl),
        .A(A),
        .B(B),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        $monitor("Time: %0d, ALUControl: %b, A: %d, B: %d, ALUResult: %d, Zero: %b", $time, ALUControl, A, B, ALUResult, Zero);

        ALUControl = 4'b0000; A = 32'd213; B = 32'd0;
        #10; B = 32'd213;
        #10; B = 32'd60;
        #10;

        ALUControl = 4'b0001; A = 32'd213; B = 32'd60;
        #10;

        ALUControl = 4'b0010; A = 32'hFF; B = 32'h0F;
        #10;

        ALUControl = 4'b0011; A = 32'hF0; B = 32'h0F;
        #10;

        ALUControl = 4'b0100; A = 32'hFF; B = 32'h0F;
        #10;

        ALUControl = 4'b0101; A = 32'd1; B = 32'd2;
        #10;

        ALUControl = 4'b0110; A = 32'd4; B = 32'd1;
        #10;

        ALUControl = 4'b0111; A = 32'd213; B = 32'd9;
        #10;
        ALUControl = 4'b0111; A = 32'd60; B = 32'd16;
        #10;

        ALUControl = 4'b1000; A = 32'd1917; B = 32'd960;
        #10;
        ALUControl = 4'b1000; A = 32'd960; B = 32'd960;
        #10;

        $stop;
    end

endmodule
