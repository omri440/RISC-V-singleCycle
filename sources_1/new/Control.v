`timescale 1ns / 1ps

module Control(
    input [6:0] Opcode, // שיניתי ל-Opcode כדי שיהיה ברור שזה ה-7 ביטים התחתונים
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOp, // 2 ביטים
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

always @(*) begin
    // ערכי ברירת מחדל (Default) כדי למנוע Latches
    Branch = 0; MemRead = 0; MemtoReg = 0; ALUOp = 2'b00;
    MemWrite = 0; ALUSrc = 0; RegWrite = 0;

    case(Opcode)
        // R-type (add, sub, and, or...)
        7'b0110011: begin
            RegWrite = 1;
            ALUSrc   = 0;
            MemtoReg = 0;
            ALUOp    = 2'b10; // "10" מסמן ל-ALU Control להסתכל על funct3 ו-funct7
        end

        // Load (lw)
        7'b0000011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            MemtoReg = 1;
            MemRead  = 1;
            ALUOp    = 2'b00; // "חיבור
        end
        // store (sw)
        7'b0100011:begin
            RegWrite = 0;
            ALUSrc   = 1;
            MemWrite = 1;
            MemRead  = 0;
            Branch = 0;
            ALUOp    = 2'b00; //חיבור
         end
         7'b1100011:begin
            RegWrite = 0;
            ALUSrc   = 0;
            MemWrite = 0;
            MemRead  = 0;
            Branch = 1;
            ALUOp = 2'b01; //  חיסור 
         end

    endcase
    end

endmodule