module register (
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
