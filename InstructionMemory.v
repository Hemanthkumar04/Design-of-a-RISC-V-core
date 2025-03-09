module InstructionMemory (
    input [31:0] address,           // Input address from the Program Counter (PC)
    output reg [31:0] instruction   // Output instruction at the given address
);

    // Instruction memory: a memory array to store the program instructions
    (* ram_style = "block" *) reg [31:0] memory [0:1023];     // Memory size: 1024 words (each word is 32 bits)
    integer i;

    // Preload instructions and initialize other memory to 0
    initial begin
        // Initialize all memory to zero
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end

         // Manually load the instructions into the memory
        memory[0]  = 32'h002081b3; // ADD x3, x1, x2
        memory[1]  = 32'h402081b3; // SUB x3, x1, x2
        memory[2]  = 32'h002091b3; // SLL x3, x2, x2
        memory[3]  = 32'h0020a1b3; // SLT x3, x2, x2
        memory[4]  = 32'h0020b1b3; // SLTU x3, x2, x2

        memory[5]  = 32'h00208133; // ADDI x2, x1, 2
        memory[6]  = 32'h00209133; // SLLI x2, x2, 2
        memory[7]  = 32'h0020a133; // SLTI x2, x2, 2
        memory[8]  = 32'h0020b133; // SLTIU x2, x2, 2
        memory[9]  = 32'h0020c133; // XORI x2, x2, 2
        memory[10] = 32'h0020d133; // ORI x2, x2, 2

        memory[11] = 32'h00208133; // ADDI x2, x1, 2 (repeat)
        memory[12] = 32'h00209133; // SLLI x2, x2, 2 (repeat)
        memory[13] = 32'h0020a133; // SLTI x2, x2, 2 (repeat)
        memory[14] = 32'h0020b133; // SLTIU x2, x2, 2 (repeat)

        memory[15] = 32'h00100193; // ADDI x3, x0, 1
        memory[16] = 32'h00101113; // ADDI x2, x0, 1
        memory[17] = 32'h00102193; // ADDI x3, x0, 1

        memory[18] = 32'h00002283; // LW x5, 0(x0)
        memory[19] = 32'h00003203; // LW x4, 0(x1)
        memory[20] = 32'h00004283; // LW x5, 0(x2)

        memory[21] = 32'h00502223; // SW x5, 0(x0)
        memory[22] = 32'h00402223; // SW x4, 0(x0)
        memory[23] = 32'h00302223; // SW x3, 0(x0)

        memory[24] = 32'h00006263; // BEQ x0, x0, 4
        memory[25] = 32'h00107263; // BNE x0, x0, 4
        memory[26] = 32'h00008263; // BLT x0, x0, 4
        memory[27] = 32'h00109263; // BGE x0, x0, 4

        memory[28] = 32'h0000006F; // JAL x0, 0
        memory[29] = 32'h00008067; // JALR x0, x0, 0
    end

    // Synchronous read
    always @(*) begin
        instruction <= memory[address[31:2]];  // Fetch the instruction from memory
    end
//    assign address[0] = 0;
//    assign address[1] = 0;
endmodule
