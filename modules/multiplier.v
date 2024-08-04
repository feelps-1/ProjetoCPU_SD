module multiply_by_4(in, out);
    input [31:0] in;
    output [31:0] out;
    // Multiplica o valor de entrada por 4 usando deslocamento à esquerda
    assign out = in << 2;
endmodule

module multiply_by_426(in, out);
    input [25:0] in;
    output [27:0] out;
    
    assign out = {in, 2'b00};
endmodule
