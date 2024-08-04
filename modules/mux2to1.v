module mux2to132bit(word_a, word_b, sel, data_out);
    input [31:0] word_a, word_b;   // Entradas de dados
    input sel;                     // Seletor
    output [31:0]data_out;         // Saída de dados

    assign data_out = sel ? word_a : word_b;
endmodule

module mux2to15bit(word_a, word_b, sel, data_out);
    input [4:0] word_a, word_b;   // Entradas de dados
    input sel;                    // Seletor
    output [4:0] data_out;        // Saída de dados

    assign data_out = sel ? word_a : word_b;
endmodule