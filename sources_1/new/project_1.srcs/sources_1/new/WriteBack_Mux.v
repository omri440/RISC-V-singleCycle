`timescale 1ns / 1ps

module WriteBack_Mux(
    input [31:0] ALU_Result, // תוצאה מה-ALU
    input [31:0] Mem_Data,   // נתון שנקרא מה-Data Memory
    input MemtoReg,          // אות בקרה: 0 ל-ALU, 1 לזיכרון
    output [31:0] out
);

    assign out = (MemtoReg == 1'b1) ? Mem_Data : ALU_Result;

endmodule