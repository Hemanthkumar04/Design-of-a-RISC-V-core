`timescale 1ns/1ps

module RISC_V_Processor_tb;

    // Testbench signals
    reg clk;
    reg rst;
    wire [31:0] debug_output ;

    // Instantiate the top-level RISC-V processor module
    RISC_V_Processor uut (
        .clk(clk),
        .rst(rst),
        .debug_output(debug_output)
    );


    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period: 10 ns
    end

    // Test procedure
    initial begin
        // Initialize signals
        rst = 1;
        #20; // Hold reset for 20 ns

        // Release reset
        rst = 0;

        // Wait for a few clock cycles to observe the processor behavior
        #200;

        // Open file for writing final register values
        end
    // Monitor signals for debugging (display other signals in TCL console)
    initial begin
        $monitor("Time: %0t | PC: %h | Instruction: %h | Operand1: %h | Operand2: %h | Immediate: %h | ALU_RESULT: %h | WRITE_DATA: %h",
                 $time, uut.PC_OUT, uut.INSTRUCTION, uut.READ_DATA1, uut.READ_DATA2, uut.IMM, uut.ALU_RESULT, uut.WRITE_DATA);
    end

endmodule
