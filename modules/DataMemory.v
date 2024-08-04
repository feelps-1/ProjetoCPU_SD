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