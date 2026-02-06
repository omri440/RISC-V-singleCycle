`timescale 1ns / 1ps

module ImmGen(
    input [6:0] Opcode,
    input [31:0] instruction,
    output reg [31:0] ImmExt // הגדרנו כ-reg כי הוא מקבל ערך בתוך always
);

    always @(*) begin
        case(Opcode)
            // I-type (Load instructions: lw, lb, etc.)
            7'b0000011: begin
                ImmExt = {{20{instruction[31]}}, instruction[31:20]};
            end

            // S-type (Store instructions: sw, sb, etc.)
            7'b0100011: begin
                ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end

            // B-type (Branch instructions: beq, bne, etc.)
            7'b1100011: begin
                ImmExt = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end

            // מקרה ברירת מחדל - חשוב מאוד למניעת Latches
            default: begin
                ImmExt = 32'b0;
            end
        endcase
    end

endmodule