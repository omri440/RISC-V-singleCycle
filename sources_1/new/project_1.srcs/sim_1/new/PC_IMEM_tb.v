`timescale 1ns / 1ps

module PC_IMEM_tb;

    reg clk;
    reg rst;

    wire [31:0] PC_out;
    reg  [31:0] PC_in;
    wire [31:0] InsOut;

    // PC
    PC pc (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_in),
        .PC_out(PC_out)
    );

    // Instruction Memory
    InstructionMe imem (
        .rst(rst),
        .A(PC_out),
        .InsOut(InsOut)
    );

    // clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        PC_in = 0;

        // reset
        #10 rst = 0;

        // load instructions AFTER reset
        imem.mem[0] = 32'h00500093; // addi x1, x0, 5
        imem.mem[1] = 32'h00A00113; // addi x2, x0, 10
        imem.mem[2] = 32'h002081B3; // add x3, x1, x2
        imem.mem[3] = 32'h00000073; // ecall

        // run PC
        repeat (6) begin
            PC_in = PC_out + 4;
            #10;
        end

        $stop;
    end

endmodule
