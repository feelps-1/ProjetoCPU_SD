module tb_mux2to1;

  	reg [31:0] word_a;
  	reg [31:0] word_b;
    reg sel;    
  wire [31:0]data_out;   


    mux2to1 uut (
      .word_a(word_a),
      .word_b(word_b),
        .sel(sel),
        .data_out(data_out)
    );

    initial begin

      $monitor("Time=%0t, sel=%b, word_a=%b, word_b=%b, data_out=%b", $time, sel, word_a, word_b, data_out);

    	word_b = 32'b00111010001110100011101000111010;
        word_a = 32'b10101010101010101010101010101010; 
      	sel = 1'b0; #10;
         
      	sel = 1'b1; #10;


        $finish;
    end

endmodule
