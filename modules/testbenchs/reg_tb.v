module register_tb;

    reg clk;               // Clock signal
    reg reset;             // Reset signal
    reg enable;            // Enable signal
    reg [31:0] d;          // Data input
    wire [31:0] q;         // Data output

    // Instantiate the register module
    register uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .d(d),
        .q(q)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // Generate a clock with period of 10 units
    end

    // Test sequence
    initial begin
        // Check the data
        $display("Register value: %h", q);
        // Initialize signals
        clk = 0;
        reset = 0;
        enable = 0;
        d = 32'b0;

        // Reset the register
        #10 reset = 1;
        // Check the data
        $display("Register value: %h", q);
        #10 reset = 0;
        // Check the data
        $display("Register value: %h", q);

        // Write data to the register
        #10 enable = 1;
        d = 32'hA5A5A5A5;
        #10 enable = 0;

        // Check if the data is held correctly
        #10;
        $display("Register value: %h", q);

        // Write new data to the register
        #10 enable = 1;
        d = 32'h5A5A5A5A;
        #10 enable = 0;

        // Check if the new data is held correctly
        #10;
        $display("Register value: %h", q);

        // Reset the register again
        #10 reset = 1;
        #10 reset = 0;

        // Check if the register is reset
        #10;
        $display("Register value after reset: %h", q);

        // Finish the simulation
        #10 $finish;
    end

endmodule

