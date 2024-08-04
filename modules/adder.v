module adder(p1, p2, out);
    input [31:0] p1, p2;
    output [31:0] out;
    
    assign out = p1 + p2;
endmodule

module adder_plus_4(
    input  [31:0] in,
    output [31:0] out
);
    assign out = in + 4;
endmodule