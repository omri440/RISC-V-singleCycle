`timescale 1ns / 1ps

module InstructionMe(
    rst,A,InsOut
    );
    
      input rst;
      input [31:0]A;
      output [31:0]InsOut;

     reg [31:0] mem [1023:0];
  
     assign InsOut = mem[A[31:2]];
endmodule







