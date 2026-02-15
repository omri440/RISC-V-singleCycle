`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Branch_Addr_Calc(
    input [31:0] pc_in,
    input [31:0] imm_ext,
    output [31:0] br_addr_out
    );
    
    assign br_addr_out = pc_in + imm_ext;
    
endmodule
