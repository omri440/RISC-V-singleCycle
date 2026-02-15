`timescale 1ns / 1ps

module DataMemory(
    input clk,
    input rst,
    input memWrite,        // אות בקרה לכתיבה (עבור פקודת sw)
    input memRead,         // אות בקרה לקריאה (עבור פקודת lw)
    input [31:0] address,  // כתובת מה-ALU
    input [31:0] writeData, // הנתונים שכותבים (מ-Register File)
    output [31:0] readData  // הנתונים שנקראו מהזיכרון
);

    // הגדרת זיכרון של 64 מילים (כל מילה 32 ביט)
    reg [31:0] RAM [0:63];
    integer i;

    // קריאה אסינכרונית (או לפי הצורך)
    assign readData = (memRead) ? RAM[address[7:2]] : 32'b0;

    // כתיבה מסונכרנת לשעון
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // איפוס הזיכרון (אופציונלי, עוזר בסימולציה)
            for (i = 0; i < 64; i = i + 1) begin
                RAM[i] <= 32'b0;
            end
        end
        else if (memWrite) begin
            // כתיבה לתא הזיכרון המתאים
            RAM[address[7:2]] <= writeData;
        end
    end

endmodule