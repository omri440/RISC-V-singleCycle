`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2026 14:47:50
// Design Name: 
// Module Name: PC_tb1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC_tb1;
    reg clk;
    reg rst;
    reg [31:0] PC_in;
    wire [31:0] PC_out;

    // Instantiate DUT
    PC dut (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        // init
        clk   = 0;
        rst   = 1;
        PC_in = 32'b0;

        // hold reset
        #10;
        rst = 0;

        // advance PC
        repeat (5) begin
            PC_in = PC_out + 4;
            #10;
        end

        $stop;
    end
endmodule
