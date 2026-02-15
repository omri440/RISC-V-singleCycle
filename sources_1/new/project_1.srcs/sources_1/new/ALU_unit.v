module ALU_unit(
    input [31:0] A, B,
    input [3:0] ALU_Control,
    output reg [31:0] res,
    output reg zero
);
    
    always @(*) begin
        // ערך ברירת מחדל למניעת Latches
        zero = 1'b0; 
        
        case(ALU_Control)
            4'b0000: res = A & B;       // AND
            4'b0001: res = A | B;       // OR
            4'b0010: res = A + B;       // ADD
            4'b0110: res = A - B;       // SUB
            default: res = 32'b0;
        endcase
        
        // חישוב דגל האפס
        zero = (res == 32'b0);
    end
endmodule