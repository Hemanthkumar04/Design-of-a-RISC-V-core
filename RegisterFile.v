module RegisterFile(
    output reg [31:0] read_data1,      // Data from first operand (32 bits)
    output reg [31:0] read_data2,      // Data from second operand (32 bits)
    input clk,                         // Clock signal
    input rst,                         // Reset signal
    input [4:0] read_addr1,            // Address for first operand (5 bits for 32 registers)
    input [4:0] read_addr2,            // Address for second operand (5 bits for 32 registers)
    input [4:0] write_addr,            // Address for writing result (5 bits for 32 registers)
    input [31:0] write_data,           // Data to be written (32 bits)
    input write_enable                 // Write enable signal
);

    reg [31:0] registers [0:31];       // Register array: 32 registers of 32 bits each
    integer i;

    // Initialize all registers with specific values for simulation
    initial begin
        registers[0] = 32'h00000000; // x0 is usually hardwired to 0 in RISC-V
        for (i = 1; i < 32; i = i + 1) begin
            registers[i] = 32'hDEADBEEF; // Default value for all registers except x0
        end
    end

    // Reset all registers on reset signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0] <= 32'h00000000; // Reset all registers
            for (i = 1; i < 32; i = i + 1)
                registers[i] <= i;
        end else if (write_enable && write_addr != 0) begin
            registers[write_addr] <= write_data; // Write only when reset is not active
        end
    end

    // Read data from registers
    always @(*) begin
        read_data1 = registers[read_addr1];      // Read the first operand
        read_data2 = registers[read_addr2];      // Read the second operand
    end

endmodule

