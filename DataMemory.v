module DataMemory(
    input clk,                       // Clock signal for synchronous write
    input mem_read,                  // Memory read enable signal
    input mem_write,                 // Memory write enable signal
    input [31:0] address,            // Memory address (from ALU)
    input [31:0] write_data,         // Data to be written into memory (from register file)
    input [2:0] funct3,              // Function field (funct3) to distinguish between byte, halfword, word access
    output reg [31:0] read_data      // Data read from memory (to register file)
);

    reg [7:0] memory [0:4095];       // Data memory array (16 KB, 4096 bytes)
    integer i;
    
    // Initialize memory (optional, can be removed if not needed)
    initial begin
        // Initialize memory contents to zero
        for (i = 0; i < 4096; i = i + 1) begin
            memory[i] = 8'b0;
        end
    end

    // Read memory (combinational)
    always @(*) begin
        if (mem_read) begin
            case (funct3)
                3'b000: begin  // LB: Load Byte
                    read_data = {{24{memory[address][7]}}, memory[address]};  // Sign-extend 8-bit byte
                end
                3'b001: begin  // LH: Load Halfword
                    read_data = {{16{memory[address][7]}}, memory[address], memory[address + 1]}; // Sign-extend 16-bit halfword
                end
                3'b010: begin  // LW: Load Word
                    read_data = {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]};  // Read 32-bit word
                end
                3'b100: begin  // LBU: Load Byte Unsigned
                    read_data = {24'b0, memory[address]};  // Zero-extend 8-bit byte
                end
                3'b101: begin  // LHU: Load Halfword Unsigned
                    read_data = {16'b0, memory[address], memory[address + 1]};  // Zero-extend 16-bit halfword
                end
                default: begin
                    read_data = 32'b0;  // Default read data (if funct3 is invalid)
                end
            endcase
        end else begin
            read_data = 32'b0;  // Default to 0 if memory read is disabled
        end
    end

    // Write memory (synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b000: begin  // SB: Store Byte
                    memory[address] <= write_data[7:0];  // Write 8-bit byte
                end
                3'b001: begin  // SH: Store Halfword
                    memory[address] <= write_data[7:0];           // Write lower byte
                    memory[address + 1] <= write_data[15:8];      // Write upper byte
                end
                3'b010: begin  // SW: Store Word
                    memory[address] <= write_data[7:0];           // Write lowest byte
                    memory[address + 1] <= write_data[15:8];      // Write next byte
                    memory[address + 2] <= write_data[23:16];     // Write next byte
                    memory[address + 3] <= write_data[31:24];     // Write highest byte
                end
            endcase
        end
    end

endmodule
