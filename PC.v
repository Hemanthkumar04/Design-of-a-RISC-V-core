module PC(
    input clk,
    input rst,
    input [1:0] pc_op,
    input [31:0] target_addr,
    output reg [31:0] pc_out
);

    reg [31:0] stored_return_addr; // Holds the return address for Jump operations

    // Sequential block: Updates PC based on pc_op and resets when rst is active
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 32'b0;                 // Reset PC to 0
            stored_return_addr <= 32'b0;     // Reset stored return address to 0
        end else begin
            case (pc_op)
                2'b00: pc_out <= pc_out + 4; // Increment PC by 4
                2'b01: begin
                    stored_return_addr <= pc_out + 4; // Store return address
                    pc_out <= target_addr;           // Jump to target address
                end
                2'b10: pc_out <= pc_out + $signed(target_addr); // Branch to target
                default: pc_out <= pc_out;           // Default: No operation
            endcase
        end
    end

endmodule
