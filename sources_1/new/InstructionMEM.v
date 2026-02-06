`timescale 1ns / 1ps

module InstructionMEM(clk, rst, readADD, InsOut);
    input clk, rst;
    input [31:0] readADD;
    output reg [31:0] InsOut;

    reg [31:0] I_Mem [63:0];
    integer k;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (k = 0; k < 64; k = k + 1)
                I_Mem[k] <= 32'b0;
        end else begin
            InsOut <= I_Mem[readADD[7:2]];
        end
    end
endmodule
