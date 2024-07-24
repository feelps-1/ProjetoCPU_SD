module mux2to1 (
  	input [31:0]word_a,
  	input [31:0]word_b,// Entradas de dados
    input sel,     // Seletores
  output [31:0]data_out      // Saída de dados
);

  assign data_out = sel ? word_a : word_b;

endmodule
