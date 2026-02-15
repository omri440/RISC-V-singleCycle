`timescale 1ns / 1ps

module RegFile(
    input clk, rst, RegWrite,
    input [4:0] readReg1, readReg2, WriteRegister,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

    integer k;
    reg [31:0] registers [31:0];    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(k=0; k < 32 ; k = k+1) begin
                registers[k] <= 32'b0;
            end
        end
        else if (RegWrite && (WriteRegister != 5'b0)) begin
            registers[WriteRegister] <= WriteData;
        end
    end

    assign ReadData1 = (readReg1 == 5'b0) ? 32'b0 : registers[readReg1];
    assign ReadData2 = (readReg2 == 5'b0) ? 32'b0 : registers[readReg2];
            
endmodule