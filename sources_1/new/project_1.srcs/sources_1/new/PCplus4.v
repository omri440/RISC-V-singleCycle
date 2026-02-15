`timescale 1ns / 1ps


module PCplus4(a_in ,out);
    input [31:0] a_in;
    output [31:0] out;
    assign out = a_in + 4; 
endmodule
