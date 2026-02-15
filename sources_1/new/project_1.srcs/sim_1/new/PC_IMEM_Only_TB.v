`timescale 1ns / 1ps

module PC_IMEM_Only_TB();
reg clk, rst;
    wire [31:0] pc_out;
    wire [31:0] instruction;
    
    // PC פשוט שמקדם את עצמו
    wire [31:0] next_pc = pc_out + 4;
    PC pc_unit (.clk(clk), .rst(rst), .PC_in(next_pc), .PC_out(pc_out));

    // זיכרון פקודות 
    InstructionMe imem_unit (.rst(rst), .A(pc_out), .InsOut(instruction));

    always #5 clk = ~clk;

    initial begin
        // שלב 1: טעינת פקודות לזיכרון (חייב לקרות לפני הקריאה)
        // כתובת 0
           imem_unit.mem[0] = 32'hFFC4A303;
           imem_unit.mem[1] = 32'h00832383;
           imem_unit.mem[2] = 32'h0064A423;
           imem_unit.mem[3] = 32'h00B62423;
           imem_unit.mem[4] = 32'h0062E233;

    
        clk = 0; rst = 1;
        #15 rst = 0; // שחרור Reset

        #100;
        $stop;
    end
endmodule