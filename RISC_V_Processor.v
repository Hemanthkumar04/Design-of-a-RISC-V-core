`timescale 1ns/1ps

module RISC_V_Processor(
    input clk,
    input rst,
    output [31:0] debug_output 
);

    // Internal wires for interconnecting components
    
    wire [31:0] PC_OUT, INSTRUCTION, READ_DATA1, READ_DATA2, ALU_RESULT, MEM_DATA, WRITE_DATA;
    wire [31:0] IMM;
    wire [4:0] RS1, RS2, RD;
    wire [6:0] OPCODE, FUNCT7;
    wire [2:0] FUNCT3;
    wire [3:0] ALU_OP_internal;     // ALU Operation signal
    wire MEM_READ_internal, MEM_WRITE_internal, REG_WRITE_internal;
    wire ALU_SRC_internal, MEM_TO_REG_internal, BRANCH_internal, JUMP_internal;
    wire [3:0] SHIFT_AMOUNT;

    // Program Counter (PC) Module
    PC pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_op({BRANCH_internal, JUMP_internal}),  // Control signal for PC operation
        .target_addr(ALU_RESULT),                   // ALU result as target address
        .pc_out(PC_OUT)                             // Output current PC value
    );

    // Instruction Memory Module
    InstructionMemory im_inst (
        .address(PC_OUT),      // PC value as address
        .instruction(INSTRUCTION)  // Fetched instruction
    );

    // Instruction Decode Unit
    instruction_decode id_inst (
        .instruction(INSTRUCTION),
        .rs1(RS1),
        .rs2(RS2),
        .rd(RD),
        .imm(IMM),
        .opcode(OPCODE),
        .funct3(FUNCT3),
        .funct7(FUNCT7)
    );

    // Extract Shift Amount from RS2 field
    assign SHIFT_AMOUNT = RS2[4:0];

    // Control Unit (CU) Module
    ControlUnit cu_inst (
        .opcode(OPCODE),
        .funct3(FUNCT3),
        .funct7(FUNCT7),
        .ALUOp(ALU_OP_internal),          // ALU operation signal
        .RegWrite(REG_WRITE_internal),    // Register write enable signal
        .ALUSrc(ALU_SRC_internal),        // ALU source select signal
        .MemRead(MEM_READ_internal),      // Memory read enable signal
        .MemWrite(MEM_WRITE_internal),    // Memory write enable signal
        .MemToReg(MEM_TO_REG_internal),   // Memory to register signal
        .Branch(BRANCH_internal),         // Branch signal for control
        .Jump(JUMP_internal)              // Jump signal for control
    );

    // Register File Module
    RegisterFile rf_inst (
        .clk(clk),
        .rst(rst),
        .read_addr1(RS1),
        .read_addr2(RS2),
        .write_addr(RD),
        .write_data(WRITE_DATA),            // Data to write back to register file
        .write_enable(REG_WRITE_internal),  // Enable register write
        .read_data1(READ_DATA1),            // Output of read data 1
        .read_data2(READ_DATA2)             // Output of read data 2
    );

    // ALU (Arithmetic Logic Unit) Module
    ALU alu_inst (
        .Operand1(READ_DATA1),                // Operand 1 input to ALU
        .Operand2(ALU_SRC_internal ? IMM : READ_DATA2),  // Operand 2 input (either immediate or register data)
        .Control(ALU_OP_internal),            // ALU control signal
        .n(SHIFT_AMOUNT),                     // Shift amount for ALU operations
        .Result(ALU_RESULT)                   // Result output from ALU
    );

    // Data Memory Module
    DataMemory dm_inst (
        .clk(clk),
        .mem_read(MEM_READ_internal),         // Memory read enable
        .mem_write(MEM_WRITE_internal),       // Memory write enable
        .address(ALU_RESULT),                 // Address for memory access (ALU result)
        .write_data(READ_DATA2),              // Data to write to memory
        .funct3(FUNCT3),                      // Funct3 bits used for memory operations
        .read_data(MEM_DATA)                  // Data read from memory
    );

    // Mux to select between ALU result and memory data for write-back to register file
    assign WRITE_DATA = MEM_TO_REG_internal ? MEM_DATA : ALU_RESULT;

    // Debug signal generation (used to prevent optimization of key signals during simulation)
    assign debug_output = PC_OUT;  // You can modify this to output other signals as needed for testing

endmodule
