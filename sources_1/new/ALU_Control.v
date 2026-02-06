`timescale 1ns / 1ps

module ALU_Control(
    input [1:0] ALUOp,
    input fun7,           // ביט 30 של הפקודה
    input [2:0] fun3,     // ביטים 14-12 של הפקודה
    output reg [3:0] Control_out
);

    always @(*) begin
        // שימוש ב-Blocking (=) וקביעת ערך דיפולט למניעת Latches
        Control_out = 4'b0000; 

        case({ALUOp, fun7, fun3})
            // ALUOp 00: פקודות Load/Store/ADDI -> תמיד ADD
            6'b00_0_000: Control_out = 4'b0010; 

            // ALUOp 01: פקודת Branch (beq) -> תמיד SUB
            6'b01_0_000: Control_out = 4'b0110; 

            // ALUOp 10: פקודות R-type (מסתכלים על funct)
            6'b10_0_000: Control_out = 4'b0010; // ADD
            6'b10_1_000: Control_out = 4'b0110; // SUB
            6'b10_0_111: Control_out = 4'b0000; // AND
            6'b10_0_110: Control_out = 4'b0001; // OR
            
            // ברירת מחדל למקרה של פקודה לא מוכרת
            default: Control_out = 4'b0010; 
        endcase
    end

endmodule