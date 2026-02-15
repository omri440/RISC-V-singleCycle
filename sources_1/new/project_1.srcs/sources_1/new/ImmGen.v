`timescale 1ns / 1ps


module ImmGen(
    input  [31:0] instruction,
    output reg [31:0] ImmExt
);

    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            // I-type
            7'b0000011, // LOAD
            7'b0010011: // OP-IMM
                ImmExt = {{20{instruction[31]}}, instruction[31:20]};

            // S-type
            7'b0100011:
                ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            // B-type
            7'b1100011:
                ImmExt = {{19{instruction[31]}},
                          instruction[31],
                          instruction[7],
                          instruction[30:25],
                          instruction[11:8],
                          1'b0};

            default:
                ImmExt = 32'b0;
        endcase
    end
endmodule
