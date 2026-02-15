`timescale 1ns / 1ps

module ALU_Mux(
    input [31:0] ReadData2, // נתון מהרגיסטרים (rs2)
    input [31:0] ImmExt,    // נתון מה-Immediate Generator
    input ALUSrc,           // אות בקרה: 0 לרגיסטר, 1 ל-Immediate
    output [31:0] out
);

    assign out = (ALUSrc == 1'b1) ? ImmExt : ReadData2;

endmodule