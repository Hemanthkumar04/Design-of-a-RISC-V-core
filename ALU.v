module ALU(Result, Operand1, Operand2, Control, n, ZeroFlag, CarryFlag, OverflowFlag);
input [31:0] Operand1, Operand2;   
input [3:0] Control, n;
output reg [31:0] Result;           
output reg ZeroFlag, CarryFlag, OverflowFlag;

always @(*) begin
    // Reset flags by default
    ZeroFlag = 0;
    CarryFlag = 0;
    OverflowFlag = 0;
    
    case(Control)
        4'b0000: begin // ADD
            {CarryFlag, Result} = Operand1 + Operand2; // CarryFlag captures carry out
            if ((Operand1[31] == Operand2[31]) && (Result[31] != Operand1[31]))
                OverflowFlag = 1; // Set Overflow for signed addition
        end
        4'b0001: begin // SUBTRACTION
            Result = Operand1 - Operand2;
            if (Operand1 < Operand2)
                CarryFlag = 1; // Borrow in unsigned subtraction
            if ((Operand1[31] != Operand2[31]) && (Result[31] != Operand1[31]))
                OverflowFlag = 1; // Set Overflow for signed subtraction
        end
        4'b0010: Result = Operand1 * Operand2; // MULTIPLICATION
        4'b0011: Result = (Operand2 != 0) ? (Operand1 / Operand2) : 32'hx; // Division
        4'b0100: Result = Operand1 & Operand2; // AND
        4'b0101: Result = Operand1 | Operand2; // OR
        4'b0110: Result = Operand1 ^ Operand2; // XOR
        4'b0111: Result = ~Operand1; // NOT
        4'b1000: Result = ~(Operand1 & Operand2); // NAND
        4'b1001: Result = ~(Operand1 | Operand2); // NOR
        4'b1010: Result = ~(Operand1 ^ Operand2); // XNOR
        4'b1011: Result = Operand1 << n; // LEFT SHIFT
        4'b1100: Result = Operand1 >> n; // RIGHT SHIFT
        4'b1101: Result = Operand1 <<< n; // CIRCULAR LEFT SHIFT
        4'b1110: Result = Operand1 >>> n; // CIRCULAR RIGHT SHIFT
        4'b1111: Result = (Operand2 != 0) ? (Operand1 % Operand2) : 32'hx; // MODULUS
        default: Result = 32'b0;
    endcase
    
    // Set Zero Flag if result is zero
    if (Result == 32'b0)
        ZeroFlag = 1;
        
    if (Control == 4'b0000 || Control == 4'b0001) begin
                    CarryFlag = (Control == 4'b0000) ? (Result < Operand1) : (Result > Operand1);
                    OverflowFlag = ((Operand1[31] == Operand2[31]) && (Result[31] != Operand1[31]));
                end
           else begin
                // Idle state: Maintain outputs and avoid unnecessary toggling
                Result = Result;
                ZeroFlag = ZeroFlag;
                CarryFlag = CarryFlag;
                OverflowFlag = OverflowFlag;
            end

end
endmodule







