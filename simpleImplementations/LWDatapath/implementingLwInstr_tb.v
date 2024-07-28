module cpu_tb;

    reg clock;
    reg reset;
    
    // Instância do módulo CPU
    cpu uut (
        .clock(clock),
        .reset(reset)
    );

    // Gerar o clock
    always #5 clock = ~clock;

    initial begin
        // Inicialização
        clock = 1;
        reset = 1;
        #15 reset = 0;  // Aumentar o tempo de reset para garantir a inicialização

        // Esperar alguns ciclos para observar o comportamento do datapath
        #10;
      
        // Exibir sinais importantes
        $display("Program Counter Address: %h", uut.pcAdress);
        $display("Next Program Counter Address: %h", uut.nextPCAdress);
        $display("Instruction Word: %h", uut.instructionWord);
        $display("Read Register 1: %h", uut.dataRegister1);
        $display("Write Register: %h", uut.wRegister);
        $display("Read Data Register 1: %h", uut.readDR1);
        $display("Read Data Register 2: %h", uut.readDR2);
        $display("Sign Extended Word: %h", uut.extendedWord);
        $display("ALU Source A: %h", uut.ALUSrcA);
        $display("ALU Source B: %h", uut.ALUSrcB);
        $display("ALU Result: %h", uut.resultALU);
        $display("ALU Zero Flag: %b", uut.ALUZero);
        $display("Read Data Memory: %h", uut.readDataMem);

        // Verificar o valor carregado em $9
        if (uut.register_file.Registers[9] == 32'hDEADBEEF) begin
            $display("Sucesso: Valor correto carregado em $9: %h", uut.register_file.Registers[9]);
        end else begin
          $display("Erro: Valor incorreto carregado em $9: %h", uut.register_file.Registers[9]);
        end

        // Finaliza a simulação
        $stop;
    end

    // Monitorar mudanças nos sinais
    initial begin
        $monitor("Time: %d, PC: %h, Instr: %h, ALURes: %h, MemReadData: %h",
                 $time, uut.pcAdress, uut.instructionWord, uut.resultALU, uut.readDataMem);
    end

endmodule
